//
//  ProfileMBTICell.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/7/25.
//

import UIKit
import SnapKit

final class ProfileMBTICell: UICollectionViewCell {
    static let id: String = "ProfileMBTICell"
    private let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override var isSelected: Bool {
        didSet {
            
        }
    }
    
    func configure(_ title: String) {
        button.setTitle(title, for: .normal)
    }
    
}

extension ProfileMBTICell {
    
    private func configureHierarchy() {
        self.addSubview(button)
        configureLayout()
    }
    
    private func configureLayout() {
        button.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.edges.equalToSuperview()
        }
    }
    
    private func configureView() {
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 30
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.gray.cgColor
        configureHierarchy()
    }
    
}
