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
        self.addSubview(buttonLabel)
        self.addSubview(spacingLayer)
        configureLayout()
    }
    
    private func configureLayout() {
        
        buttonLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        spacingLayer.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(buttonLabel.snp.bottom).offset(12)
        }
        
    }
    
    private func configureView() {
        buttonLabel.textColor = .white
        buttonLabel.textAlignment = .left
        buttonLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        spacingLayer.backgroundColor = .white
        configureHierarchy()
    }
    
}
