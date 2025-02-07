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
    private let levelLabel = UILabel()
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
        saveButton.setTitle("\(userInfo.movie)개의 애니 보관중", for: .normal)
    }
    
}

extension MyProfileView {
    
    private func configureHierarchy() {
        [profileImage, nameLabel, dateLabel, levelLabel].forEach( {
            totalButton.addSubview($0)
        })
        
        [totalButton, saveButton].forEach({
            self.addSubview($0)
        })
        
        configureLayout()
    }
    
    private func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.leading.equalToSuperview().inset(12)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.trailing.equalTo(levelLabel.snp.leading).offset(-4)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.trailing.equalTo(levelLabel.snp.leading).offset(-4)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
        }
        
        levelLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(120)
            make.centerY.equalTo(profileImage)
            make.trailing.equalToSuperview().inset(24)
            make.leading.equalTo(dateLabel.snp.trailing).offset(24)
        }
        
        totalButton.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(saveButton.snp.top).offset(-16)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.bottom.horizontalEdges.equalToSuperview().inset(12)
            make.top.lessThanOrEqualTo(totalButton.snp.bottom).offset(16)
        }
        
    }
    
    private func configureView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.backgroundColor = .point.withAlphaComponent(0.2)
        
        profileImage.containerView.isHidden = true
        profileImage.isUserInteractionEnabled = false
        
        nameLabel.textColor = .black
        nameLabel.textAlignment = .left
        nameLabel.font = .boldSystemFont(ofSize: 18)
        
        dateLabel.textColor = .black
        dateLabel.textAlignment = .left
        dateLabel.font = .systemFont(ofSize: 11, weight: .regular)
        
        saveButton.isEnabled = false
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 10
        saveButton.backgroundColor = .white
        saveButton.setTitleColor(.orange, for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        
        //TODO: - 수정
//        levelLabel.textColor = .white
//        levelLabel.clipsToBounds = true
//        levelLabel.text = "👑방구석 오타쿠"
//        levelLabel.layer.cornerRadius = 5
//        levelLabel.textAlignment = .center
//        levelLabel.backgroundColor = .point
//        levelLabel.font = .systemFont(ofSize: 13, weight: .heavy)
        
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
