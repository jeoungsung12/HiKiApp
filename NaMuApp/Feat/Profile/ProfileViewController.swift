//
//  ProfileViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    //MARK: - Components
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
    private let profileButton = CustomProfileButton(120, true)
    private let nameTextField = UITextField()
    private let spacingView = UIView()
    private let descriptionLabel = UILabel()
    private let successButton = UIButton()
    private let mbtiView = ProfileMBTIView()
    
    private let viewModel = ProfileViewModel()
    private let inputTrigger = ProfileViewModel.Input(
        configureViewTrigger: Observable(()),
        successButtonTrigger: Observable(ProfileViewModel.ProfileSuccessButton(textFields: [], mbtiBools: [])),
        profileButtonTrigger: Observable(()),
        nameTextFieldTrigger: Observable(nil),
        buttonEnabledTrigger: Observable(ProfileViewModel.ProfileSuccessButton(textFields: [], mbtiBools: []))
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setBinding()
    }
    
    private func setBinding() {
        let output = viewModel.transform(input: inputTrigger)
        
        output.configureViewResult.bind { [weak self] userInfo in
            if !userInfo.isEmpty {
                self?.nameTextField.text = userInfo[0]
                self?.profileButton.profileImage.image = UIImage(named: userInfo[1])
            } else {
                guard let image = ProfileData.allCases.randomElement()?.rawValue else { return }
                self?.profileButton.profileImage.image = UIImage(named: image)
            }
        }
        
        output.profileButtonResult.lazyBind { [weak self] _ in
            let vc = ProfileImageViewController()
            vc.profileImage = self?.profileButton.profileImage.image
            vc.returnImage = { [weak self] value in
                self?.profileButton.profileImage.image = value
            }
            self?.push(vc)
        }
        
        output.successButtonResult.lazyBind { [weak self] valid in
            if let valid = valid, valid {
                let rootVC = TabBarController()
                self?.setRootView(rootVC)
            } else {
                self?.customAlert("설정 실패!", "설정 사항을 다시 확인해 주세요!", [.ok]) { }
            }
        }
        
        output.nameTextFieldResult.lazyBind { [weak self] text in
            self?.descriptionLabel.text = text
        }
        
        output.buttonEnabledResult.lazyBind { [weak self] valid in
            guard let valid = valid else {
                self?.successButton.isEnabled = false
                return
            }
            self?.successButton.isEnabled = (valid) ? true : false
        }
    }
    
    deinit {
        print(#function, self)
    }
    
}

//MARK: - Configure UI
extension ProfileViewController {
    
    private func configureHierarchy() {
        [profileButton, nameTextField, spacingView, descriptionLabel, mbtiView, successButton].forEach {
            self.view.addSubview($0)
        }
        self.view.addGestureRecognizer(tapGesture)
        configureLayout()
    }
    
    private func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.centerX.equalToSuperview().offset(10)
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
        
        mbtiView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
        }
        
        successButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-44)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    private func configureView() {
        self.setNavigation("PROFILE SETTING")
        self.view.backgroundColor = .customWhite
        
        nameTextField.delegate = self
        nameTextField.textColor = .black
        nameTextField.textAlignment = .left
        nameTextField.placeholder = "닉네임을 설정해 주세요 :)"
        nameTextField.font = .systemFont(ofSize: 15, weight: .semibold)
        
        spacingView.backgroundColor = .customDarkGray
        
        descriptionLabel.numberOfLines = 1
        descriptionLabel.textColor = .point
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
        successButton.setBorder()
        successButton.isEnabled = false
        successButton.setTitle("완료", for: .normal)
        successButton.setTitleColor(.point, for: .normal)
        successButton.addTarget(self, action: #selector(successButtonTapped), for: .touchUpInside)
        
        profileButton.addTarget(self, action: #selector(profilebuttonTapped), for: .touchUpInside)
        
        configureProfileView()
        configureHierarchy()
    }
    
    private func configureProfileView() {
        inputTrigger.configureViewTrigger.value = ()
    }
    
}

//MARK: - Action
extension ProfileViewController {
    
    @objc
    private func profilebuttonTapped(_ sender: UIButton) {
        print(#function)
        inputTrigger.profileButtonTrigger.value = ()
    }
    
    @objc
    private func successButtonTapped(_ sender: UIButton) {
        print(#function)
        //TODO: ViewModel
        let indexPaths = Array(0...3).map({ return IndexPath(row: $0, section: 0) })
        let bools = indexPaths
            .map {
                if let cell = mbtiView.collectionView.cellForItem(at: $0) as? ProfileMBTICell {
                    cell.tapped = checkTapped
                    return cell.isClicked
                }
                return nil
            }
        inputTrigger.successButtonTrigger.value = ProfileViewModel.ProfileSuccessButton(profileImage: profileButton.profileImage.image, textFields: [nameTextField.text, descriptionLabel.text], mbtiBools: bools)
    }
}

//MARK: - TextField
extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        inputTrigger.nameTextFieldTrigger.value = textField.text
        let indexPaths = Array(0...3).map({ return IndexPath(row: $0, section: 0) })
        let bools = indexPaths
            .map {
                if let cell = mbtiView.collectionView.cellForItem(at: $0) as? ProfileMBTICell {
                    cell.tapped = checkTapped
                    return cell.isClicked
                }
                return nil
            }
        inputTrigger.buttonEnabledTrigger.value = ProfileViewModel.ProfileSuccessButton(profileImage: profileButton.profileImage.image, textFields: [nameTextField.text, descriptionLabel.text], mbtiBools: bools)
    }
    
    private func checkTapped() {
        let indexPaths = Array(0...3).map({ return IndexPath(row: $0, section: 0) })
        let bools = indexPaths
            .map {
                if let cell = mbtiView.collectionView.cellForItem(at: $0) as? ProfileMBTICell {
                    cell.tapped = checkTapped
                    return cell.isClicked
                }
                return nil
            }
        inputTrigger.buttonEnabledTrigger.value = ProfileViewModel.ProfileSuccessButton(profileImage: profileButton.profileImage.image, textFields: [nameTextField.text, descriptionLabel.text], mbtiBools: bools)
    }
    
}
