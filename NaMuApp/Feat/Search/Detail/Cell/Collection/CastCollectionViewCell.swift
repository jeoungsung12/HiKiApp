//
//  CastCollectionViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import UIKit
import Kingfisher
import SnapKit

class CastCollectionViewCell: UICollectionViewCell {
    static let id: String = "CastCollectionViewCell"
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let originalLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: CreditCast) {
        if let url = URL(string: model.profile_path) {
            imageView.kf.setImage(with: url)
            imageView.kf.indicatorType = .activity
        } else { imageView.image = nil }
        
        nameLabel.text = model.name
        originalLabel.text = model.original_name
    }
    
}

extension CastCollectionViewCell {
    
    private func configureHierarchy() {
        self.addSubview(imageView)
        self.addSubview(nameLabel)
        self.addSubview(originalLabel)
        configureLayout()
    }
    
    private func configureLayout() {
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(70)
            make.horizontalEdges.leading.equalToSuperview().inset(12)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
            make.leading.equalTo(imageView.snp.bottom).offset(4)
        }
        
        originalLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.leading.equalTo(imageView.snp.bottom).offset(4)
        }
        
    }
    
    private func configureView() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleToFill
        
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 15)
        
        originalLabel.textColor = .white
        originalLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        configureHierarchy()
    }
    
}
