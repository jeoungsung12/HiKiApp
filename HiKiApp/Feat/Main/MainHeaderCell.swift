//
//  MainHeaderCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/10/25.
//

import UIKit
import Kingfisher
import SnapKit

final class MainHeaderCell: BaseCollectionViewCell, ReusableIdentifier {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let genreLabel = UILabel()
    private let rankLabel = UILabel()
    private let ratingLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    override func configureHierarchy() {
        [imageView, rankLabel, titleLabel, genreLabel].forEach({
            self.addSubview($0)
        })
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-60)
            make.width.equalToSuperview().dividedBy(1.5)
        }
        
        rankLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.leading.equalToSuperview().offset(12)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-4)
            make.top.equalTo(genreLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    override func configureView() {
        imageView.clipsToBounds = false
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .darkGray
        
        rankLabel.textColor = .systemOrange.withAlphaComponent(0.8)
        rankLabel.textAlignment = .left
        rankLabel.font = .boldItalicFont(130)
        
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        genreLabel.numberOfLines = 1
        genreLabel.textAlignment = .center
        genreLabel.textColor = .customDarkGray
        genreLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        [rankLabel, imageView].forEach({
            $0.layer.shadowRadius = 4
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        })
    }
    
}
