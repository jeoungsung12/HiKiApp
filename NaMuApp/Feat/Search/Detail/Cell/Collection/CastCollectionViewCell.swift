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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(_ model: CreditCast) {
        if let url = URL(string: APIEndpoint.trending.imagebaseURL + (model.profile_path ?? "")) {
            imageView.kf.setImage(with: url)
            imageView.kf.indicatorType = .activity
        }
        
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
            make.size.equalTo(60)
            make.verticalEdges.leading.equalToSuperview().inset(12)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(24)
            make.leading.equalTo(imageView.snp.trailing).offset(8)
        }
        
        originalLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalTo(imageView.snp.trailing).offset(8)
        }
        
    }
    
    private func configureView() {
        self.backgroundColor = .black
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .darkGray
        
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 15)
        
        originalLabel.textColor = .customLightGray
        originalLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        configureHierarchy()
    }
    
}
