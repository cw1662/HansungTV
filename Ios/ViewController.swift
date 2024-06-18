//
//  ViewController.swift
//  Ios
//
//  Created by cw on 2024/6/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

// 섹션 유형 정의
enum Section: Hashable {
    case double
}

// 드라마 데이터 아이템 정의
enum Item: Hashable {
    case normal(TV)
}

class ViewController: UIViewController, UISearchBarDelegate  {
    
    // RxSwift를 이용한 리소스 관리
    var disposeBag = DisposeBag()
    
    // 뷰가 사라질 때 DisposeBag 초기화 방지
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // 데이터 소스 객체 선언
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    // 컬렉션 뷰의 헤더 뷰
    private let headerView = HeaderView()
    
    // 컬렉션 뷰 인스턴스
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .white
        collectionView.register(CollectionViewItem.self, forCellWithReuseIdentifier: CollectionViewItem.id)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.id)
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()
    
    // 검색창
    let searchBar = UISearchBar()
    
    // 뷰 모델 인스턴스 생성
    let viewModel = ViewModel()
    
    //  데이터 가져오기
    let tvTrigger = PublishSubject<Void>()
    
    // 검색 처리
    let searchQuery = BehaviorSubject<String>(value: "")
    
    // 검색어 입력 시 호출
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchQuery.onNext(searchText)
    }
    
    // 검색 버튼 클릭 시 호출
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        searchQuery.onNext(searchText)
        searchBar.resignFirstResponder()
    }
    
    // 뷰가 로드된 후 초기 설정을 위한 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setDatasource()
        bindViewModel()
        bindView()
        tvTrigger.onNext(())
        searchBar.delegate = self
        configureNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tvTrigger.onNext(())
    }
    
    // 네비게이션 바 (헤더 부분)
    private func configureNavigationBar() {
        if let navigationController = navigationController {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .blue // 배경
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // 제목 색상
            
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
            navigationController.navigationBar.compactAppearance = appearance
            navigationController.navigationBar.tintColor = .white
            
            navigationItem.title = "한성TV" // 제목
            navigationController.navigationBar.isTranslucent = false
        }
    }
    
    // UI
    private func setUI() {
        view.backgroundColor = .white
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        // 검색창
        searchBar.placeholder = "검색어를 입력하세요."
        searchBar.barTintColor = .white
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
    }
    
    // 뷰모델 바인딩
    private func bindViewModel() {
        let input = ViewModel.Input(tvTrigger: tvTrigger.asObservable(), searchQuery: searchQuery.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.tvList.bind { [weak self] tvList in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            let items = tvList.map { Item.normal($0) }
            let section = Section.double
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
    }
    
    // 뷰 바인딩
    private func bindView() {
        collectionView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                if let tvData = self.dataSource?.itemIdentifier(for: indexPath) {
                    switch tvData {
                    case .normal(let tv):
                        self.showTVDetail(tv)
                    }
                }
            }.disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .bind { [weak self] in
                guard let searchText = self?.searchBar.text, !searchText.isEmpty else {
                    return
                }
                self?.searchQuery.onNext(searchText)
                self?.searchBar.resignFirstResponder()
            }.disposed(by: disposeBag)
    }
    
    // 레이아웃 설정
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 14
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            return self?.createDoubleSection()
        }, configuration: config)
    }
    
    // 2Xn 형태 설정
    private func createDoubleSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 8, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0)
        
        let header = createHeader()
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    // 헤더를 생성
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return header
    }
    
    // 데이터 설정(중요!!)
    private func setDatasource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .normal(let tvData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewItem.id, for: indexPath) as? CollectionViewItem
                cell?.configure(title: tvData.name, review: "\(tvData.vote)", desc: tvData.overview, imageURL: tvData.posterURL)
                return cell
            }
        }
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath) as? HeaderView else {
                fatalError("Cannot create header view")
            }
            
            // 현재 섹션의 title 결정
            let section = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
            var title: String?
            
            switch section {
            case .double:
                title = "인기 TV프로그램 Top 50"
            case nil:
                title = nil
            }
            
            // 섹션 헤더에 title 설정
            sectionHeader.delegate = self
            sectionHeader.configure(title: title)
            
            return sectionHeader
        }
    }

    
    // 상세 페이지
    private func showTVDetail(_ tvShow: TV) {
        guard let navigationController = navigationController else { return }
        
        if let detailVC = navigationController.viewControllers.first(where: { $0 is DetailViewController }) as? DetailViewController {
            detailVC.tvShow = tvShow
            navigationController.popToViewController(detailVC, animated: true)
        } else {
            let detailVC = DetailViewController()
            detailVC.tvShow = tvShow
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
}

// HeaderViewDelegate 프로토콜 준수를 확장으로 구현
extension ViewController: HeaderViewDelegate {
    func didTapPopularButton() {
        print("Popular button tapped")
    }
    
    func didTapAllButton() {
        print("All button tapped")
    }
}
