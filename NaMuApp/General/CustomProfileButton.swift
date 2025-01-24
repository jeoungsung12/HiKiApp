//
//  CustomProfileButton.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

final class CustomProfileButton: UIButton {
    private let overlayImage = UIImageView()
    let containerView = UIView()
    let profileImage = UIImageView()
    
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

extension CustomProfileButton {
    
    private func configureHierarchy() {
        self.addSubview(profileImage)
        self.containerView.addSubview(overlayImage)
        self.addSubview(containerView)
        configureLayout()
    }
    
    private func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        containerView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.trailing.bottom.equalToSuperview().inset(16)
        }
        
        overlayImage.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }
    }
    
    private func configureView() {
        profileImage.contentMode = .scaleAspectFit
        profileImage.image = UIImage(named: "profile_0")
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 15
        containerView.backgroundColor = .point
        
        overlayImage.tintColor = .white
        overlayImage.image = UIImage(systemName: "camera.fill")
        
        configureHierarchy()
    }
}
