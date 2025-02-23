//
//  DialogViewController.swift
//  UIKit_Week9_HA
//
//  Created by 정성윤 on 2/20/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PopupViewController: BaseViewController {
    private let containerView = UIView()
    private let descriptionLabel = UILabel()
    private let textView = UITextView()
    private let stackView = UIStackView()
    private let cancelBtn = UIButton()
    private let startBtn = UIButton()
    
    private let viewModel = PopupViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func setBinding() {
        let input = PopupViewModel.Input(
            startBtnTrigger:
                startBtn.rx.tap
        )
        let output = viewModel.transform(input)
        
        output.startBtnResult
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        cancelBtn.rx.tap
            .asDriver()
            .drive(with: self) { owner, value in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        self.view.backgroundColor = .black.withAlphaComponent(0.2)
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .white
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        descriptionLabel.textColor = .black
        descriptionLabel.textAlignment = .center
        
        cancelBtn.setTitle("취소", for: .normal)
        startBtn.setTitle("시작하기", for: .normal)
        [cancelBtn, startBtn].forEach({
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor.point.withAlphaComponent(0.5).cgColor
            $0.setTitleColor(.point, for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
        })
        
    }
    
    override func configureHierarchy() {
        [cancelBtn, startBtn].forEach({
            self.stackView.addArrangedSubview($0)
        })
        [descriptionLabel, stackView].forEach({
            self.containerView.addSubview($0)
        })
        self.view.addSubview(containerView)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        stackView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.lessThanOrEqualTo(descriptionLabel.snp.bottom).offset(12)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(2)
            make.leading.equalToSuperview().offset(-2)
        }
        
        startBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.trailing.equalToSuperview().offset(2)
        }
    }
    
    deinit {
        print(#function, self)
    }
    
}
