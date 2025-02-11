//
//  OnboardingViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit
import Lottie

final class OnboardingViewController: UIViewController {
    private let imageView = LottieAnimationView(name: "lottie")
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let startButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    deinit {
        print(self, #function)
    }

}

//MARK: - Configure UI
extension OnboardingViewController {
    
     private func configureHierarchy() {
        [imageView, titleLabel, descriptionLabel, startButton].forEach {
            self.view.addSubview($0)
        }
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
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        startButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.lessThanOrEqualToSuperview().offset(-24)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(36)
        }
    }
    
    private func configureView() {
        self.setNavigation()
        self.view.backgroundColor = .customWhite
        
        imageView.loopMode = .loop
        imageView.contentMode = .scaleAspectFit
        imageView.play()
        
        titleLabel.text = "HiKi"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .systemOrange
        titleLabel.font = .boldItalicFont(50)
        
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .lightGray
        descriptionLabel.text = "당신만의 애니 세상 📺,\n하이키를 시작해보세요"
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        startButton.setBorder()
        startButton.setTitle("시작하기", for: .normal)
        startButton.setTitleColor(.point, for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        configureHierarchy()
    }
    
}

//MARK: - Action
extension OnboardingViewController {
    
    @objc
    private func startButtonTapped(_ sender: UIButton) {
        print(#function)
        let vc = ProfileViewController()
        self.push(vc)
    }
    
}
