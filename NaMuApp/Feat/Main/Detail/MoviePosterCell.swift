//
//  MoviePosterCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import Kingfisher
import SnapKit

final class HeaderPosterCell: UICollectionViewCell {
    static let id: String = "MoviePosterCell"
    private let imageResult = UILabel()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let heartButton = UIButton()
    private let db = Database.shared
    private var buttonTapped: Bool = false
    
    var isButton: ((Bool)->Void)?
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
        imageResult.text = nil
    }
    
    func configure(_ model: SearchResult) {
        configureImage(model.poster_path)
        titleLabel.text = model.title
        descriptionLabel.text = model.overview
    }
    
    func configureImage(_ urlString: String?) {
        if let poster_path = urlString,
            let url = URL(string: poster_path) {
            imageView.kf.setImage(with: url)
        }
    }
    
}

extension HeaderPosterCell {
    
    private func configureHierarchy() {
        [imageView, titleLabel, descriptionLabel].forEach({
            self.addSubview($0)
        })
        configureLayout()
    }
    
    private func configureLayout() {
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureView() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .darkGray
        
        
        imageView.layer.shadowRadius = 4
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowColor = UIColor.lightGray.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
      
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        titleLabel.textColor = .customWhite
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = .customWhite
        descriptionLabel.font = .systemFont(ofSize: 15, weight: .regular)
        
        configureHierarchy()
    }
    
}
