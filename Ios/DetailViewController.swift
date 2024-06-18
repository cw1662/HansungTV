import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    var tvShow: TV? // TV 정보를 담을 변수
    
    // 스크롤 뷰 선언 및 설정
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false // 수직 스크롤 인디케이터 숨김
        return scrollView
    }()
    
    // 스크롤 뷰의 콘텐츠 뷰 선언
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    // TV 포스터 이미지를 보여줄 이미지 뷰 선언 및 설정
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill // 비율 유지하며 채우기
        imageView.clipsToBounds = true // 경계를 넘어서지 않도록 클립
        imageView.layer.cornerRadius = 8 // 둥근 모서리 설정
        imageView.layer.masksToBounds = true // 이미지 뷰 경계 내에서만 마스킹
        return imageView
    }()
    
    // TV 제목을 보여줄 레이블 선언 및 설정
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold) // 폰트 설정
        label.textColor = .black // 글자 색상 설정
        return label
    }()
    
    // TV 줄거리를 보여줄 레이블 선언 및 설정
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular) // 폰트 설정
        label.numberOfLines = 0 // 여러 줄 표시 가능하도록 설정
        label.textColor = .darkGray // 글자 색상 설정
        return label
    }()
    
    // TV 평점을 보여줄 레이블 선언 및 설정
    let voteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium) // 폰트 설정
        label.textColor = .gray // 글자 색상 설정
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white // 배경색 설정
        setupScrollView() // 스크롤 뷰 설정 메서드 호출
        setupUI() // UI 구성 설정 메서드 호출
        configureView() // 뷰 데이터 설정 메서드 호출
    }
    
    // 스크롤 뷰를 설정하고 뷰에 추가하는 메서드
    private func setupScrollView() {
        view.addSubview(scrollView) // 뷰에 스크롤 뷰 추가
        scrollView.addSubview(contentView) // 스크롤 뷰에 콘텐츠 뷰 추가
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // 스크롤 뷰를 뷰의 경계에 맞춤
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // 콘텐츠 뷰를 스크롤 뷰의 경계에 맞춤
            make.width.equalToSuperview() // 콘텐츠 뷰의 너비를 스크롤 뷰의 너비와 같게 설정
        }
    }
    
    // UI 요소들을 콘텐츠 뷰에 추가하고 레이아웃을 설정하는 메서드
    private func setupUI() {
        contentView.addSubview(imageView) // 이미지 뷰를 콘텐츠 뷰에 추가
        contentView.addSubview(titleLabel) // 제목 레이블을 콘텐츠 뷰에 추가
        contentView.addSubview(overviewLabel) // 줄거리 레이블을 콘텐츠 뷰에 추가
        contentView.addSubview(voteLabel) // 평점 레이블을 콘텐츠 뷰에 추가
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(16) // 이미지 뷰의 상단을 콘텐츠 뷰의 safe area 상단에서 16만큼 내림
            make.leading.trailing.equalToSuperview().inset(16) // 이미지 뷰를 좌우 여백 16로 설정
            make.height.equalTo(imageView.snp.width).multipliedBy(1.2) // 이미지 뷰의 높이를 너비의 1.2배로 설정 (5:6 비율)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16) // 제목 레이블의 상단을 이미지 뷰의 하단에서 16만큼 내림
            make.leading.trailing.equalToSuperview().inset(16) // 제목 레이블을 좌우 여백 16로 설정
        }
        
        voteLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8) // 평점 레이블의 상단을 제목 레이블의 하단에서 8만큼 내림
            make.leading.trailing.equalToSuperview().inset(16) // 평점 레이블을 좌우 여백 16로 설정
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(voteLabel.snp.bottom).offset(16) // 줄거리 레이블의 상단을 평점 레이블의 하단에서 16만큼 내림
            make.leading.trailing.equalToSuperview().inset(16) // 줄거리 레이블을 좌우 여백 16로 설정
            make.bottom.equalToSuperview().inset(16) // 줄거리 레이블의 하단을 콘텐츠 뷰의 하단에서 16만큼 떨어진 곳으로 설정
        }
    }
    
    // 뷰에 표시될 TV 정보를 설정하는 메서드
    private func configureView() {
        guard let tvShow = tvShow else { return } // tvShow가 nil이면 종료
        
        // 포스터 이미지 URL이 있으면 이미지 설정
        if let posterURL = tvShow.posterURL, let url = URL(string: posterURL) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(named: "placeholder") // 포스터 이미지 URL이 없으면 placeholder 이미지 설정
        }
        
        titleLabel.text = tvShow.name // 제목 설정
        // 평점 레이블 설정 부분 수정
        voteLabel.text = "⭐️ \(tvShow.vote) (\(tvShow.voteCount))" // 평점 설정
        overviewLabel.text = tvShow.overview // 줄거리 설정
    }
}
