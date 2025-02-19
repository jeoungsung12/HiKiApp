//
//  CastCollectionViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import UIKit
import Kingfisher
import SnapKit

class CharactersCollectionViewCell: UICollectionViewCell {
    static let id: String = "CharactersCollectionViewCell"
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    
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
    
    func configure(_ model: CharacterEntry) {
        nameLabel.text = model.name
        if let images = model.images, let url = URL(string: images.jpg.image_url) {
            imageView.kf.setImage(with: url)
        }
    }
    
}

extension CharactersCollectionViewCell {
    
    private func configureHierarchy() {
        [imageView, nameLabel].forEach({
            self.contentView.addSubview($0)
        })
        configureLayout()
    }
    
    private func configureLayout() {
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
    }
    
    private func configureView() {
        self.backgroundColor = .white
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .darkGray
        
        nameLabel.numberOfLines = 2
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.font = .boldSystemFont(ofSize: 15)
        
        configureHierarchy()
    }
    
}
