//
//  RecentView.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/27/25.
//

import UIKit
import SnapKit

final class RecentView: UIView {
    private let stackView = UIStackView()
    private let titleButton = UIButton()
    private let removeButton = UIButton()
    
    var titleTapped: ((String)->Void)?
    var removeTapped: ((String)->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ title: String) {
        titleButton.setTitle(title, for: .normal)
    }
}

extension RecentView {
    
    private func configureHierarchy() {
        self.stackView.addArrangedSubview(titleButton)
        self.stackView.addArrangedSubview(removeButton)
        self.addSubview(stackView)
        configureLayout()
    }
    
    private func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
    }
    
    private func configureView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.backgroundColor = .customLightGray
        
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        titleButton.setTitleColor(.black, for: .normal)
        titleButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        titleButton.addTarget(self, action: #selector(recentItemTapped), for: .touchUpInside)
        
        removeButton.tintColor = .black
        removeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        removeButton.addTarget(self, action: #selector(removeItemTapped), for: .touchUpInside)
        configureHierarchy()
    }
    
}

extension RecentView {
    
    @objc
    private func recentItemTapped(_ sender: UIButton) {
        print(#function)
        guard let title = sender.currentTitle else { return }
        titleTapped?(title)
    }
    
    @objc
    private func removeItemTapped(_ sender: UIButton) {
        print(#function)
        guard let title = titleButton.currentTitle else { return }
        removeTapped?(title)
    }
}
