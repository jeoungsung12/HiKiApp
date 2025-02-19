//
//  MainNavigationView.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/8/25.
//

import UIKit
import SnapKit
import Lottie

final class MainNavigationView: BaseView {
    private let logoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        self.addSubview(logoImageView)
        configureLayout()
    }
    
    override func configureLayout() {
        logoImageView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(80)
            make.leading.verticalEdges.equalToSuperview()
        }
    }
    
    override func configureView() {
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        configureHierarchy()
    }
}
