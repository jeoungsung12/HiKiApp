//
//  RecentView.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/27/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RecentView: BaseView {
    private let stackView = UIStackView()
    private let titleButton = UIButton()
    private let removeButton = UIButton()
    
    var titleTapped: ((String)->Void)?
    var removeTapped: ((String)->Void)?
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setBindView() {
        titleButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let title = owner.titleButton.currentTitle else { return }
                owner.titleTapped?(title)
            }.disposed(by: disposeBag)
        
        removeButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let title = owner.titleButton.currentTitle else { return }
                owner.removeTapped?(title)
            }.disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        [titleButton, removeButton].forEach({ self.addSubview($0) })
        self.addSubview(stackView)
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
    }
    
    override func configureView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.backgroundColor = .customLightGray
        
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        titleButton.setTitleColor(.customBlack, for: .normal)
        titleButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        
        removeButton.tintColor = .customBlack
        removeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
    }
    
    func configure(_ title: String) {
        titleButton.setTitle(title, for: .normal)
    }
}
