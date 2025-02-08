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
    private let imageView = LottieAnimationView(name: "lottie")
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
        [titleLabel, imageView].forEach({
            self.addSubview($0)
        })
        configureLayout()
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(4)
        }
    }
    
    private func configureView() {
        titleLabel.text = "HiKi"
        titleLabel.textAlignment = .left
        titleLabel.textColor = .point
        titleLabel.font = .boldItalicFont(20)
        
        imageView.loopMode = .loop
        imageView.contentMode = .scaleAspectFit
        imageView.play()
        
        configureHierarchy()
    }
    
}
