//
//  NormalCollectionViewCell.swift
//  Ios
//
//  Created by cw on 2024/6/14.
//
import UIKit
import Kingfisher

class CollectionViewItem: UICollectionViewCell {
    static let id = "NormalCollectionViewCell"
    
    // 카드 형태
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    // image
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.black
        label.numberOfLines = 2
        return label
    }()
    
    // review
    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.darkGray
        label.numberOfLines = 1
        return label
    }()
    
    // detail
    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.gray
        label.numberOfLines = 3
        return label
    }()
    
    // 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI
    private func setupUI() {
        contentView.addSubview(cardView)
        cardView.addSubview(imageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(reviewLabel)
        cardView.addSubview(descLabel)
        
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(imageView.snp.width).multipliedBy(1.2) // 이미지 비율을 유지하면서 높이 조정
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4) // 이미지 아래에 제목 배치
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4) // 제목 아래에 리뷰 배치
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(4) // 리뷰 아래에 설명 배치
            make.leading.trailing.bottom.equalToSuperview().inset(12)
        }
        
        contentView.backgroundColor = .clear
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowRadius = 2
    }
    
    // UI를 업데이트
    func configure(title: String, review: String, desc: String, imageURL: String?) {
        titleLabel.text = title
        reviewLabel.text = "⭐️ \(review)" // 리뷰 앞에 별 이모지 추가
        
        descLabel.text = desc
        
        if let imageURL = imageURL, let url = URL(string: imageURL) {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder")) // 이미지 로딩 시 Placeholder 이미지 사용
        } else {
            imageView.image = UIImage(named: "placeholder") // URL이 nil이면 Placeholder 이미지 사용
        }
    }
    
    // 재사용
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil // 이미지 초기화
    }
}
