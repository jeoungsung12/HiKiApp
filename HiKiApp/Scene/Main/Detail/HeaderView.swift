//
//  HeaderView.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/8/25.
//

import UIKit
import SnapKit

final class HeaderView: UICollectionReusableView {
    static let id: String = "HeaderView"
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title : String) {
        self.titleLabel.text = title
    }
}

extension HeaderView {
    private func setLayout() {
        self.addSubview(titleLabel)
    }
    
    private func configureHierarchy() {
        self.addSubview(titleLabel)
        configureLayout()
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
        }
    }
    
    private func configureView() {
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        configureHierarchy()
    }
}
