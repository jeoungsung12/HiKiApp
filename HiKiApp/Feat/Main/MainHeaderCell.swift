//
//  MainHeaderCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/10/25.
//

import UIKit
import Kingfisher
import SnapKit

final class MainHeaderCell: UICollectionViewCell {
    static let id: String = "MainHeaderCell"
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let genreLabel = UILabel()
    private let rankLabel = UILabel()
    private let ratingLabel = UILabel()
    
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
        [rankLabel, titleLabel, genreLabel].forEach({
            $0.text = nil
        })
    }
    
    func configure(_ data: ItemModel,_ rank: Int) {
        titleLabel.text = data.title
        
        if let genres = data.genre {
            var text: String = ""
            for genre in genres {
                text += "#\(genre.name) "
            }
            genreLabel.text = text
        }
        
        if let url = URL(string: data.image) {
            imageView.kf.setImage(with: url)
        }
        configureRank(rank)
    }
    
    private func configureRank(_ rank: Int) {
        rankLabel.text = "\(rank)"
    }
    
}

extension MainHeaderCell {
    
    private func configureHierarchy() {
        [rankLabel, imageView, titleLabel, genreLabel].forEach({
            self.addSubview($0)
        })
        configureLayout()
    }
    
    private func configureLayout() {
        rankLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(-24)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-52)
            make.trailing.lessThanOrEqualToSuperview().inset(12)
            make.width.equalToSuperview().dividedBy(1.5)
            make.leading.equalTo(rankLabel.snp.trailing).offset(-12)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).offset(-24)
            make.horizontalEdges.equalTo(imageView.snp.horizontalEdges).inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-12)
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    private func configureView() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .darkGray
        
        rankLabel.textColor = .point
        rankLabel.textAlignment = .left
        rankLabel.font = .boldItalicFont(230)
        
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        genreLabel.numberOfLines = 2
        genreLabel.textColor = .white
        genreLabel.textAlignment = .left
        genreLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        
        [rankLabel, imageView, genreLabel].forEach({
            $0.layer.shadowRadius = 4
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        })
        configureHierarchy()
    }
    
}
