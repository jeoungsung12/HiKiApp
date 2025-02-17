//
//  MypageViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

final class MyPageViewController: UIViewController {
    private let myProfileView = MyProfileView()
    private let buttonStackView = UIStackView()
    private let categoryStackView = UIStackView()
    private let countLabel = UILabel()
    private let aniBoxButton = UIButton()
    private let teaserBoxButton = UIButton()
    private let changeProfileButton = UIButton()
    
    private let viewModel = MyPageViewModel()
    private let inputTrigger = MyPageViewModel.Input(
        profileTrigger: CustomObservable(()),
        categoryBtnTrigger: CustomObservable(nil)
    )
    private lazy var output = viewModel.transform(input: inputTrigger)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputTrigger.profileTrigger.value = ()
    }
    
    private func setBinding() {
        output.profileResult.bind { [weak self] userInfo in
            if let userInfo = userInfo {
                self?.myProfileView.configure(userInfo)
            }
        }
        
        output.categoryBtnResult.lazyBind { [weak self] type in
            guard let type = type else { return }
            //TODO: 추가
            switch type {
            case .aniBox:
                self?.push(SheetProfileViewController())
            case .watchBox:
                self?.push(SheetProfileViewController())
            case .profile:
                self?.push(SheetProfileViewController())
            }
        }
    }
    
}

extension MyPageViewController {
    
    private func configureHierarchy() {
        [aniBoxButton, teaserBoxButton, changeProfileButton].forEach({
            self.categoryStackView.addArrangedSubview($0)
        })
        [myProfileView, categoryStackView, buttonStackView, countLabel].forEach({
            self.view.addSubview($0)
        })
        configureLayout()
    }
    
    private func configureLayout() {
        
        myProfileView.snp.makeConstraints { make in            make.height.equalTo(230)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        categoryStackView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(myProfileView.snp.bottom).offset(12)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.lessThanOrEqualToSuperview().offset(-24)
            make.top.equalTo(categoryStackView.snp.bottom).offset(24)
        }
        
        countLabel.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(20)
            make.centerX.equalTo(aniBoxButton.snp.centerX)
            make.top.equalTo(aniBoxButton.snp.top).offset(-20)
        }
        
    }
    
    private func configureView() {
        self.setNavigation("프로필")
        self.view.backgroundColor = .customWhite
        
        //TODO: - 간소화
        aniBoxButton.tag = 0
        aniBoxButton.configuration = self.buttonConfiguration(MyPageViewModel.MyPageCategoryType.aniBox.rawValue, MyPageViewModel.MyPageCategoryType.aniBox.image)
        
        aniBoxButton.tag = 1
        teaserBoxButton.configuration = self.buttonConfiguration(MyPageViewModel.MyPageCategoryType.watchBox.rawValue, MyPageViewModel.MyPageCategoryType.watchBox.image)
        
        aniBoxButton.tag = 2
        changeProfileButton.configuration = self.buttonConfiguration(MyPageViewModel.MyPageCategoryType.profile.rawValue, MyPageViewModel.MyPageCategoryType.profile.image)
        
        [aniBoxButton, teaserBoxButton, changeProfileButton].forEach({
            $0.tintColor = .black
            $0.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        })
        categoryStackView.axis = .horizontal
        categoryStackView.alignment = .center
        categoryStackView.distribution = .fillEqually
        
        countLabel.textColor = .white
        countLabel.clipsToBounds = true
        countLabel.layer.cornerRadius = 5
        countLabel.textAlignment = .center
        countLabel.backgroundColor = .point
        //TODO: 갯수 대응
        countLabel.text = viewModel.getUserInfo() + "개 보관중"
        countLabel.font = .systemFont(ofSize: 12, weight: .heavy)
        
        configureButtonStack()
        configureHierarchy()
    }
    
    private func configureButtonStack() {
        buttonStackView.spacing = 30
        buttonStackView.axis = .vertical
        buttonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (type) in MyPageViewModel.MyPageButtonType.allCases {
            let button = MyPageSectionButton()
            if type == .withdraw {
                button.addTarget(self, action: #selector(withdrawTapped), for: .touchUpInside)
            }
            button.configure(type.rawValue)
            buttonStackView.addArrangedSubview(button)
        }
    }
    
    private func buttonConfiguration(_ title: String,_ image: String) -> UIButton.Configuration {
        let image = UIImage(systemName: image)
        var config = UIButton.Configuration.plain()
        config.image = image
        config.title = title
        config.imagePlacement = .top
        config.imagePadding = CGFloat(12)
        config.baseForegroundColor = .black
        config.imageColorTransformer = .monochromeTint
        return config
    }
    
}


extension MyPageViewController {
    
    @objc
    private func profileButtonTapped(_ sender: UIButton) {
        //TODO: ViewModel
        let vc = SheetProfileViewController()
        //TODO: - 델리겟으로 써보기
        vc.dismissClosure = { [weak self] in
            self?.inputTrigger.profileTrigger.value = ()
        }
        self.sheet(vc)
    }
    
    @objc
    private func categoryButtonTapped(_ sender: UIButton) {
        inputTrigger.categoryBtnTrigger.value = MyPageViewModel.MyPageCategoryType.allCases[sender.tag]
    }
    
    @objc
    private func withdrawTapped(_ sender: UIButton) {
        //TODO: ViewModel
        self.customAlert(
            "탈퇴하기",
            "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?",
            [.ok, .cancel]
        ) {
            self.viewModel.removeUserInfo()
            let rootVC = UINavigationController(rootViewController: OnboardingViewController())
            self.setRootView(rootVC)
        }
    }
}
