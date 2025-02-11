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
    private let logoImageView = UIImageView()
    
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
        self.addSubview(logoImageView)
        configureLayout()
    }
    
    private func configureLayout() {
        logoImageView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(80)
            make.leading.verticalEdges.equalToSuperview()
        }
    }
    
    private func configureView() {
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        configureHierarchy()
    }
    
}
