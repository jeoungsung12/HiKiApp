//
//  MypageViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyPageViewController: BaseViewController {
    private let myProfileView = MyProfileView()
    private let buttonStackView = UIStackView()
    private let categoryStackView = UIStackView()
    private let countLabel = UILabel()
    private let aniBoxButton = UIButton()
    private let changeProfileButton = UIButton()
    
    private let viewModel = MyPageViewModel()
    let inputTrigger = MyPageViewModel.Input(
        profileTrigger: PublishSubject<Void>(),
        listBtnTrigger: PublishRelay<MyPageViewModel.MyPageButtonType>(),
        categoryBtnTrigger: PublishRelay<MyPageViewModel.MyPageCategoryType>()
    )
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputTrigger.profileTrigger.onNext(())
    }
    
    override func setBindView() {
        [aniBoxButton, changeProfileButton].forEach({ btn in
            btn.rx.tap
                .bind(with: self) { owner, _ in
                    let type = MyPageViewModel.MyPageCategoryType.allCases[btn.tag]
                    owner.inputTrigger.categoryBtnTrigger.accept(type)
                }.disposed(by: disposeBag)
        })
    }
    
    override func setBinding() {
        let output = viewModel.transform(inputTrigger)
        
        output.profileResult
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, userInfo in
                owner.myProfileView.configure(userInfo)
                owner.countLabel.text = owner.viewModel.getSaveAnime()
            }).disposed(by: disposeBag)
        
        output.listBtnResult
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, type in
                switch type {
                case .oftenQS:
                    owner.push(FAQViewController())
                case .feedback:
                    if let url = URL(string: AnimeRouter.detailAnime(id: 1).feedbackURL) {
                        UIApplication.shared.open(url)
                    }
                case .withdraw:
                    owner.customAlert(
                        "Unsubscribe",
                        "If you cancel your subscription, all data will be initialized. Do you want to unsubscribe?",
                        [.Ok, .Cancel]
                    ) {
                        owner.viewModel.removeUserInfo()
                        owner.setRootView(UINavigationController(rootViewController: OnboardingViewController()))
                    }
                }
            }.disposed(by: disposeBag)
        
        output.categoryBtnResult
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, type in
                switch type {
                case .aniBox:
                    owner.push(AnimeArchiveViewController())
                case .profile:
                    owner.push(SheetProfileViewController())
                }
            }).disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        [aniBoxButton, changeProfileButton].forEach({
            self.categoryStackView.addArrangedSubview($0)
        })
        [myProfileView, categoryStackView, buttonStackView, countLabel].forEach({
            self.view.addSubview($0)
        })
    }
    
    override func configureLayout() {
        
        myProfileView.snp.makeConstraints { make in
            make.height.equalTo(230)
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
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.centerX.equalTo(aniBoxButton.snp.centerX)
            make.top.equalTo(aniBoxButton.snp.top).offset(-20)
        }
        
    }
    
    override func configureView() {
        self.setNavigation("Profile")
        self.view.backgroundColor = .customWhite
        aniBoxButton.tag = 0
        aniBoxButton.configuration = self.buttonConfiguration(MyPageViewModel.MyPageCategoryType.aniBox.rawValue, MyPageViewModel.MyPageCategoryType.aniBox.image)
        
        changeProfileButton.tag = 1
        changeProfileButton.configuration = self.buttonConfiguration(MyPageViewModel.MyPageCategoryType.profile.rawValue, MyPageViewModel.MyPageCategoryType.profile.image)
        
        [aniBoxButton, changeProfileButton].forEach({
            $0.tintColor = .black
        })
        categoryStackView.axis = .horizontal
        categoryStackView.alignment = .center
        categoryStackView.distribution = .fillEqually
        
        countLabel.textColor = .white
        countLabel.clipsToBounds = true
        countLabel.layer.cornerRadius = 5
        countLabel.textAlignment = .center
        countLabel.backgroundColor = .point
        countLabel.font = .systemFont(ofSize: 12, weight: .heavy)
        
        configureButtonStack()
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension MyPageViewController {
    
    private func configureButtonStack() {
        buttonStackView.spacing = 30
        buttonStackView.axis = .vertical
        buttonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (type) in MyPageViewModel.MyPageButtonType.allCases {
            let button = MyPageSectionButton()
            button.rx.tap
                .bind(with: self) { owner, _ in
                    owner.inputTrigger.listBtnTrigger.accept(type)
                }.disposed(by: disposeBag)
            button.configure(type.rawValue)
            buttonStackView.addArrangedSubview(button)
        }
    }
    
    private func buttonConfiguration(_ title: String,_ image: String) -> UIButton.Configuration {
        let image = UIImage(systemName: image)
        var config = UIButton.Configuration.plain()
        config.image = image
        config.title = title
        config.titleAlignment = .center
        config.imagePlacement = .top
        config.imagePadding = CGFloat(12)
        config.baseForegroundColor = .black
        config.imageColorTransformer = .monochromeTint
        return config
    }
    
}
