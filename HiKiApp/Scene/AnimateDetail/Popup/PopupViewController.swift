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
import Cosmos
import Toast
import NVActivityIndicatorView

final class PopupViewController: BaseViewController {
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulseSync, color: .point)
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
    private let containerView = UIView()
    private let descriptionLabel = UILabel()
    private let cosmosView = CosmosView()
    private let textView = UITextView()
    private let stackView = UIStackView()
    private let cancelBtn = UIButton()
    private let saveBtn = UIButton()
    
    private let viewModel: PopupViewModel
    private var disposeBag = DisposeBag()
    
    init(viewModel: PopupViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func setBinding() {
        let input = PopupViewModel.Input(
            startBtnTrigger: PublishRelay<PopModel>()
        )
        let output = viewModel.transform(input)
        
        saveBtn.rx.tap
            .withUnretained(self)
            .map { _ in
                return PopModel(review: self.textView.text, reviewValue: self.cosmosView.rating )
            }
            .bind(with: self) { owner, value in
                input.startBtnTrigger.accept(value)
                owner.loadingIndicator.startAnimating()
            }
            .disposed(by: disposeBag)
        
        output.startBtnResult
            .map { return $0 != nil }
            .drive(with: self) { owner, valid in
                owner.loadingIndicator.stopAnimating()
                owner.view.makeToast((valid) ? "Review registration successful!" : "Review registration failed!", duration: 1.0, position: .center)
                if valid {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        owner.dismiss(animated: true)
                    }
                } else {
                    
                }
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
        
        descriptionLabel.numberOfLines = 1
        descriptionLabel.textColor = .black
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = "Please write a review! 🌟"
        descriptionLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        textView.textColor = .darkGray
        textView.textAlignment = .left
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 10
        textView.backgroundColor = .systemGray5
        textView.font = .systemFont(ofSize: 15, weight: .semibold)
        
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        cosmosView.settings.starSize = 30
        cosmosView.settings.totalStars = 5
        cosmosView.settings.emptyColor = .white
        cosmosView.isUserInteractionEnabled = true
        cosmosView.settings.filledColor = .systemYellow
        
        cancelBtn.setTitle("Cancel", for: .normal)
        saveBtn.setTitle("Save", for: .normal)
        [cancelBtn, saveBtn].forEach({
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.setTitleColor(.point, for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
        })
        
    }
    
    override func configureHierarchy() {
        [cancelBtn, saveBtn].forEach({
            self.stackView.addArrangedSubview($0)
        })
        [descriptionLabel, cosmosView, textView, stackView].forEach({
            self.containerView.addSubview($0)
        })
        self.view.addSubview(containerView)
        self.view.addSubview(loadingIndicator)
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.top.lessThanOrEqualToSuperview().offset(100)
            make.height.equalToSuperview().dividedBy(2)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.bottom.lessThanOrEqualTo(self.view.keyboardLayoutGuide.snp.top).inset(100)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        cosmosView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
        }
        
        textView.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(2)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(cosmosView.snp.bottom).offset(12)
        }
        
        stackView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.greaterThanOrEqualTo(textView.snp.bottom).offset(12)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(2)
            make.leading.equalToSuperview().offset(-2)
        }
        
        saveBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.trailing.equalToSuperview().offset(2)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    deinit {
        print(#function, self)
    }
    
}
