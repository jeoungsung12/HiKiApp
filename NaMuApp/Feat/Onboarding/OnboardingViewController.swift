//
//  OnboardingViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit
import SwiftUI

final class OnboardingViewController: UIViewController {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let startButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

}

extension OnboardingViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(imageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(startButton)
        
        configureLayout()
    }
    
    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(imageView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        startButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.lessThanOrEqualToSuperview().offset(-24)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
        }
        
    }
    
    private func configureView() {
        self.setNavigation()
        self.view.backgroundColor = .customBlack
        
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "onboarding")
        
        titleLabel.textColor = .white
        titleLabel.text = "Onboarding"
        titleLabel.textAlignment = .center
        titleLabel.font = .italicSystemFont(ofSize: 30)
        
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = "당신만의 영화 세상,\nNaMu를 시작해보세요."
        descriptionLabel.font = .systemFont(ofSize: 15, weight: .regular)
        
        startButton.setBorder()
        startButton.setTitle("시작하기", for: .normal)
        startButton.setTitleColor(.point, for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        
        configureHierarchy()
    }
    
}


extension OnboardingViewController {
    
    @objc
    private func startButtonTapped(_ sender: UIButton) {
        print(#function)
        let vc = ProfileViewController()
        self.push(vc)
    }
}
