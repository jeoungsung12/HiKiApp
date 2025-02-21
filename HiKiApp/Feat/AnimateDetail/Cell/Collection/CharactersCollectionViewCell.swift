//
//  CastCollectionViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import UIKit
import Kingfisher
import SnapKit

final class CharactersCollectionViewCell: BaseCollectionViewCell, ReusableIdentifier {
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func configureHierarchy() {
        [imageView, nameLabel].forEach({
            self.contentView.addSubview($0)
        })
    }
    
    override func configureLayout() {
        
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
    
    override func configureView() {
        self.backgroundColor = .white
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .darkGray
        
        nameLabel.numberOfLines = 2
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.font = .boldSystemFont(ofSize: 15)
    }
    
    func configure(nameEntity: String, imageEntity: String?) {
        nameLabel.text = nameEntity
        if let image = imageEntity, let url = URL(string: image) {
            imageView.kf.setImage(with: url)
        }
    }
    
}
