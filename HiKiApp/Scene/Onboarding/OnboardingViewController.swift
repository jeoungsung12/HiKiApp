//
//  OnboardingViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class OnboardingViewController: BaseViewController {
    private let imageView = LoadingView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let startButton = UIButton()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setBindView() {
        startButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = ProfileViewController()
                owner.push(vc)
            }
            .disposed(by: disposeBag)
    }
    
    deinit {
        print(self, #function)
    }
    
    
    override func configureHierarchy() {
        [imageView, titleLabel, descriptionLabel, startButton].forEach {
            self.view.addSubview($0)
        }
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.height.equalTo(250)
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview().offset(-120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(imageView.snp.bottom).offset(64)
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
    
    override func configureView() {
        self.setNavigation()
        self.view.backgroundColor = .customWhite
        
        titleLabel.text = "HiKi"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .systemOrange
        titleLabel.font = .boldItalicFont(50)
        
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .lightGray
        descriptionLabel.text = "Your own anime world 📺,\nStart HiKi"
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        startButton.setBorder()
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.point, for: .normal)
    }
    
}
