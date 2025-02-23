//
//  SheetProfileViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/27/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SheetProfileViewController: BaseViewController {
    private lazy var successButton = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil)
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
    private let profileButton = CustomProfileButton(120, true)
    private let nameTextField = UITextField()
    private let spacingView = UIView()
    private let descriptionLabel = UILabel()
    
    private let viewModel = ProfileViewModel()
    private var inputTrigger = ProfileViewModel.Input(
        configureViewTrigger: PublishSubject<Void>(),
        nameTextFieldTrigger: PublishSubject<String?>(),
        successButtonTrigger: PublishSubject<ProfileButton>(),
        buttonEnabledTrigger: PublishSubject<ProfileButton>()
    )
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    override func setBindView() {
        successButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.enableTrigger(false)
            }
            .disposed(by: disposeBag)
        
        profileButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = ProfileImageViewController()
                vc.profileImage = owner.profileButton.profileImage.image
                vc.profileDelegate = owner
                owner.push(vc)
            }
            .disposed(by: disposeBag)
        
        nameTextField.rx.text.changed
            .bind(with: self) { owner, value in
                owner.enableTrigger(true)
            }
            .disposed(by: disposeBag)
    }
    
    override func setBinding() {
        let output = viewModel.transform(inputTrigger)
        
        output.configureViewResult
            .drive(with: self, onNext: { owner, userInfo in
                if let userInfo = userInfo, let image = userInfo.profile {
                    owner.nameTextField.text = userInfo.nickname
                    owner.profileButton.profileImage.image = UIImage(named: image)
                }
            }).disposed(by: disposeBag)
        
        output.successButtonResult
            .drive(with: self, onNext: { owner, valid in
                if let valid = valid, valid {
                    self.pop()
                } else {
                    owner.customAlert("Setup failed!", "Please check your settings again!", [.Ok]) { }
                }
            }).disposed(by: disposeBag)
        
        output.nameTextFieldResult
            .drive(with: self, onNext: { owner, text in
                owner.descriptionLabel.text = ((text == "")) ? nil : text
                owner.descriptionLabel.textColor = (text == NickName.NickNameType.success.rawValue) ? .systemOrange : .systemRed
            }).disposed(by: disposeBag)
        
        inputTrigger.configureViewTrigger.onNext(())
    }
    
    override func configureHierarchy() {
        [profileButton, nameTextField, spacingView, descriptionLabel].forEach {
            self.view.addSubview($0)
        }
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func configureLayout() {
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
    }
    
    override func configureView() {
        self.setNavigation("PROFILE SETTING")
        self.view.backgroundColor = .customWhite
        self.navigationItem.rightBarButtonItem = successButton
        
        nameTextField.delegate = self
        nameTextField.textColor = .black
        nameTextField.textAlignment = .left
        nameTextField.placeholder = "Please set a nickname :)"
        nameTextField.font = .systemFont(ofSize: 15, weight: .semibold)
        
        spacingView.backgroundColor = .customDarkGray
        
        descriptionLabel.numberOfLines = 1
        descriptionLabel.textColor = .point
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .regular)
    }
    
    deinit {
        print(#function, self)
    }
    
}


extension SheetProfileViewController: UITextFieldDelegate, ProfileImageDelegate {
    
    func returnImage(_ image: UIImage?) {
        print(#function)
        self.profileButton.profileImage.image = image
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        inputTrigger.nameTextFieldTrigger.onNext(textField.text)
        enableTrigger(true)
    }
    
    private func checkTapped() {
        enableTrigger(true)
    }
    
    private func enableTrigger(_ enable: Bool) {
        let trigger = (enable) ? inputTrigger.buttonEnabledTrigger : inputTrigger.successButtonTrigger
        trigger.onNext(ProfileButton(profileImage: profileButton.profileImage.image, name: nameTextField.text, description:  descriptionLabel.text))
    }
    
}
