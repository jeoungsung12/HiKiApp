//
//  ProfileViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    private let profileButton = CustomProfileButton()
    private let nameTextField = UITextField()
    private let spacingView = UIView()
    private let descriptionLabel = UILabel()
    private let successButton = UIButton()
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureClicked))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
}

extension ProfileViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(profileButton)
        self.view.addSubview(nameTextField)
        self.view.addSubview(spacingView)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(successButton)
        self.view.addGestureRecognizer(tapGesture)
        
        configureLayout()
    }
    
    private func configureLayout() {
        
        profileButton.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(profileButton.snp.bottom).offset(24)
        }
        
        spacingView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(nameTextField.snp.bottom).offset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(spacingView.snp.bottom).offset(16)
        }
        
        successButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.lessThanOrEqualToSuperview().offset(-24)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(32)
        }
    }
    
    private func configureView() {
        self.setNavigation("프로필 설정")
        self.view.backgroundColor = .black
        //TODO: - 수정
        profileButton.profileImage.setBorder(3, 60)
        profileButton.addTarget(self, action: #selector(profilebuttonTapped), for: .touchUpInside)
        
        
        nameTextField.text = "고래밥99개"
        nameTextField.textColor = .white
        nameTextField.textAlignment = .left
        nameTextField.font = .systemFont(ofSize: 15, weight: .semibold)
//        nameTextField.placeholder 수정
        
        spacingView.backgroundColor = .white
        
        descriptionLabel.numberOfLines = 1
        descriptionLabel.textColor = .point
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .regular)
        descriptionLabel.text = "닉네임에 숫자는 포함할 수 없어요"
        
        successButton.setBorder()
        successButton.setTitle("완료", for: .normal)
        successButton.setTitleColor(.point, for: .normal)
        successButton.addTarget(self, action: #selector(successButtonTapped), for: .touchUpInside)
        //TODO: - 키보드 처리
        
        configureHierarchy()
    }
    
}


extension ProfileViewController {
    
    @objc
    private func tapGestureClicked(_ sender: UITapGestureRecognizer) {
        print(#function)
        self.view.endEditing(true)
    }
    
    @objc
    private func profilebuttonTapped(_ sender: UIButton) {
        print(#function)
        let vc = ProfileImageViewController()
        self.push(vc)
    }
    
    @objc
    private func successButtonTapped(_ sender: UIButton) {
        print(#function)
        //TODO: - 수정
        let vc = MainViewController()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }
        window.rootViewController = UINavigationController(rootViewController: vc)
    }
}
