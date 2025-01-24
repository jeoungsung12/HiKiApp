//
//  ProfileImageCollectionViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

final class ProfileImageCollectionViewCell: UICollectionViewCell {
    static let id: String = "ProfileImageCollectionViewCell"
    let profileButton = CustomProfileButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ image: UIImage?) {
        profileButton.profileImage.image = image
    }
}

extension ProfileImageCollectionViewCell {
    
    private func configureHierarchy() {
        self.addSubview(profileButton)
        configureLayout()
    }
    
    private func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureView() {
        configureHierarchy()
    }
    
}
