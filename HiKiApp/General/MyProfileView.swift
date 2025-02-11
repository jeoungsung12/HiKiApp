//
//  MainProfileView.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

final class MyProfileView: UIView {
    private let profileImage = CustomProfileButton(120, true)
    
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    
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
    }
    
}

extension MyProfileView {
    
    private func configureHierarchy() {
        [profileImage, nameLabel, dateLabel].forEach({
            self.addSubview($0)
        })
        configureLayout()
    }
    
    private func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
        }
        
        nameLabel.snp.makeConstraints { make in            make.top.equalTo(profileImage.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.lessThanOrEqualToSuperview().inset(4)
        }
    }
    
    private func configureView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.backgroundColor = .white
        
        profileImage.containerView.isHidden = true
        profileImage.isUserInteractionEnabled = false
        
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.font = .boldSystemFont(ofSize: 25)
        
        dateLabel.textColor = .gray
        dateLabel.textAlignment = .center
        dateLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        configureHierarchy()
    }
}
