//
//  HeaderView.swift
//  Ios
//
//  Created by cw on 2024/6/17.
//

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
    
    public func configure(title: String) {
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
