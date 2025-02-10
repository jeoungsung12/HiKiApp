//
//  MainNavigationView.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/8/25.
//

import UIKit
import SnapKit
import Lottie

final class MainNavigationView: UIView {
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainNavigationView {
    
    private func configureHierarchy() {
        self.addSubview(titleLabel)
        configureLayout()
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
        }
    }
    
    private func configureView() {
        titleLabel.text = "HiKi"
        titleLabel.textAlignment = .left
        titleLabel.textColor = .point
        titleLabel.font = .boldItalicFont(30)
        configureHierarchy()
    }
    
}
