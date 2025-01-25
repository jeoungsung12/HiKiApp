//
//  MainProfileView.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

final class MyProfileView: UIView {
    private let profileImage = CustomProfileButton(100, true)
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    private let arrow = UIButton()
    private let saveButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
    }
    
}

extension MyProfileView {
    
    private func configureHierarchy() {
        self.addSubview(profileImage)
        self.addSubview(nameLabel)
        self.addSubview(dateLabel)
        self.addSubview(arrow)
        self.addSubview(saveButton)
        
        configureLayout()
    }
    
    private func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.leading.equalToSuperview().inset(12)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
            //TODO: - Trailing
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
            //TODO: - Trailing
        }
        
        arrow.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.centerY.equalTo(profileImage)
            make.trailing.equalToSuperview().inset(12)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
            make.top.equalTo(profileImage.snp.bottom).offset(12)
        }
        
    }
    
    private func configureView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.backgroundColor = .darkGray
        
        profileImage.profileImage.setBorder(true, 20)
        profileImage.containerView.isHidden = true
        profileImage.isUserInteractionEnabled = false
        
        //TODO: - 변경
        nameLabel.text = "옹골찬 고래밥"
        nameLabel.textColor = .white
        nameLabel.textAlignment = .left
        nameLabel.font = .boldSystemFont(ofSize: 18)
        
        dateLabel.textColor = .customDarkGray
        dateLabel.textAlignment = .left
        dateLabel.text = "25.01.24 가입"
        dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 10
        saveButton.backgroundColor = .point
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.setTitle("18 개의 무비박스 보관중", for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        
        arrow.tintColor = .customDarkGray
        arrow.setImage(UIImage(systemName: "greaterthan"), for: .normal)
        
        configureHierarchy()
    }
}
