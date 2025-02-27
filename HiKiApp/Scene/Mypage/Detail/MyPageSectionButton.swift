//
//  MyPageCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

final class MyPageSectionButton: UIButton {
    private let buttonLabel = UILabel()
    private let spacingLayer = UIView()
    private let arrowButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ title: String) {
        buttonLabel.text = title
    }
    
}

extension MyPageSectionButton {
    
    private func configureHierarchy() {
        [buttonLabel, spacingLayer, arrowButton].forEach({
            self.addSubview($0)
        })
        configureLayout()
    }
    
    private func configureLayout() {
        
        buttonLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
        }
        
        spacingLayer.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(buttonLabel.snp.bottom).offset(24)
        }
        
        arrowButton.snp.makeConstraints { make in
            make.size.equalTo(15)
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(buttonLabel.snp.centerY)
        }
        
    }
    
    private func configureView() {
        buttonLabel.textColor = .black
        buttonLabel.textAlignment = .left
        buttonLabel.font = .systemFont(ofSize: 15, weight: .regular)
        
        arrowButton.isEnabled = false
        arrowButton.imageView?.contentMode = .scaleAspectFit
        arrowButton.setImage(UIImage(named: "rightArrow"), for: .normal)
        
        spacingLayer.backgroundColor = .systemGray5
        configureHierarchy()
    }
    
}
