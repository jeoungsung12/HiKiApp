//
//  MainProfileView.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

final class MyProfileView: UIButton {
    private let profileImage = CustomProfileButton(60, true)
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    private let arrow = UIButton()
    private let saveButton = UIButton()
    private let userInfo = Database.shared.getUser()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        profileImage.containerView.isHidden = true
        profileImage.isUserInteractionEnabled = false
        profileImage.profileImage.image = userInfo.profile
        
        nameLabel.text = userInfo.nickname
        nameLabel.textColor = .white
        nameLabel.textAlignment = .left
        nameLabel.font = .boldSystemFont(ofSize: 18)
        
        dateLabel.textColor = .customDarkGray
        dateLabel.textAlignment = .left
        dateLabel.text = userInfo.date
        dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 10
        saveButton.backgroundColor = .point
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.setTitle("\(userInfo.movie) 개의 무비박스 보관중", for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        
        //TODO: - 이미지 수정
        arrow.isEnabled = false
        arrow.tintColor = .customDarkGray
        arrow.setImage(UIImage(systemName: "greaterthan"), for: .normal)
        
        configureHierarchy()
    }
}
