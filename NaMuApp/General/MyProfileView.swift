//
//  MainProfileView.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

final class MyProfileView: UIView {
    private let totalButton = UIButton()
    private let profileImage = CustomProfileButton(60, true)
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    private let arrow = UIImageView()
    private let saveButton = UIButton()
    
    var profileTapped: (()->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ userInfo: UserInfo) {
        dateLabel.text = userInfo.date
        nameLabel.text = userInfo.nickname
        profileImage.profileImage.image = userInfo.profile
        saveButton.setTitle("\(userInfo.movie) 개의 무비박스 보관중", for: .normal)
    }
    
}

extension MyProfileView {
    
    private func configureHierarchy() {
        totalButton.addSubview(profileImage)
        totalButton.addSubview(arrow)
        totalButton.addSubview(nameLabel)
        totalButton.addSubview(dateLabel)
        self.addSubview(totalButton)
        self.addSubview(saveButton)
        
        configureLayout()
    }
    
    private func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.leading.equalToSuperview().inset(12)
        }
        
        arrow.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalTo(profileImage)
            make.trailing.equalToSuperview().inset(12)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.trailing.equalTo(arrow.snp.leading).offset(-4)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.trailing.equalTo(arrow.snp.leading).offset(-4)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
        }
        
        totalButton.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(saveButton.snp.top).offset(-16)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(totalButton.snp.bottom).offset(16)
            make.bottom.horizontalEdges.equalToSuperview().inset(12)
        }
        
    }
    
    private func configureView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.backgroundColor = .darkGray
        
        profileImage.containerView.isHidden = true
        profileImage.isUserInteractionEnabled = false
        
        nameLabel.textColor = .customWhite
        nameLabel.textAlignment = .left
        nameLabel.font = .boldSystemFont(ofSize: 16)
        
        dateLabel.textColor = .customDarkGray
        dateLabel.textAlignment = .left
        dateLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        
        saveButton.isEnabled = false
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 10
        saveButton.backgroundColor = .point
        saveButton.setTitleColor(.customWhite, for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        
        arrow.tintColor = .customLightGray
        arrow.contentMode = .scaleAspectFit
        arrow.image = UIImage(named: "carat")
        
        totalButton.backgroundColor = .clear
        totalButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        
        configureHierarchy()
    }
}

//MARK: - Action
extension MyProfileView {
    
    @objc
    private func profileButtonTapped(_ sender: UIButton) {
        profileTapped?()
    }
    
}
