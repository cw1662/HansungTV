//
//  Header.swift
//  Ios
//
//  Created by cw on 2024/6/14.
//

import Foundation
import UIKit
import SnapKit

protocol HeaderViewDelegate: AnyObject {
    func didTapPopularButton()
    func didTapAllButton()
}
final class HeaderView: UICollectionReusableView {
    static let id = "HeaderView"
    weak var delegate: HeaderViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(50) // Adjusted height for the title label
        }
    }
    
    // HeaderView 클래스 내 configure(title:) 메서드 수정
    public func configure(title: String?) {
        if let title = title {
            titleLabel.text = title
            titleLabel.isHidden = false // 텍스트가 있는 경우에는 표시
        } else {
            titleLabel.text = ""
            titleLabel.isHidden = true // 텍스트가 없는 경우에는 숨김 처리
        }
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
