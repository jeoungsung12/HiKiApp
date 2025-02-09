//
//  MoviePosterCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import Kingfisher
import SnapKit

enum PosterType {
    case rank
    case star
    case other
    case gnere
}

final class PosterCell: UICollectionViewCell {
    static let id: String = "MoviePosterCell"
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let rankLabel = UILabel()
    private let starLabel = UILabel()
    
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
        starLabel.isHidden = true
        [rankLabel, titleLabel, subtitleLabel, starLabel].forEach({
            $0.text = nil
        })
    }
    
    func configure(_ data: ItemModel,_ rank: Int,_ type : PosterType) {
        switch type {
        case .rank:
            configureRank(rank)
            titleLabel.text = data.title
        case .star:
            starLabel.isHidden = false
            subtitleLabel.text = data.title
            starLabel.text = String(format: "%.2f 🌟", data.star)
        case .other:
            subtitleLabel.text = data.title
        case .gnere:
            //TODO: 장르
            print("")
        }
        if let url = URL(string: data.image) {
            imageView.kf.setImage(with: url)
        }
    }
    
    private func configureRank(_ rank: Int) {
        print(#function)
        rankLabel.text = rank.formatted()
    }
    
}

extension PosterCell {
    
    private func configureHierarchy() {
        [imageView, rankLabel, starLabel, titleLabel, subtitleLabel].forEach({
            self.addSubview($0)
        })
        configureLayout()
    }
    
    private func configureLayout() {
        
        imageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-52)
            make.top.horizontalEdges.equalToSuperview()
        }
        
        rankLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().offset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(imageView.snp.bottom).offset(-24)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
            make.top.equalTo(imageView.snp.bottom).offset(4)
        }
        
        starLabel.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(20)
            make.top.equalTo(imageView.snp.top)
            make.leading.equalTo(imageView.snp.leading).offset(-1)
        }
    }
    
    private func configureView() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .darkGray
        
        rankLabel.textColor = .point
        rankLabel.textAlignment = .left
        rankLabel.font = .boldItalicFont(100)
        
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .customWhite
        titleLabel.font = .systemFont(ofSize: 40, weight: .heavy)
        
        starLabel.isHidden = true
        starLabel.clipsToBounds = true
        starLabel.layer.cornerRadius = 15
        starLabel.textAlignment = .center
        starLabel.backgroundColor = .point
        starLabel.textColor = .customWhite
        starLabel.font = .systemFont(ofSize: 12, weight: .bold)
        starLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        
        subtitleLabel.textColor = .gray
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        [rankLabel, imageView, titleLabel, starLabel].forEach({
            $0.layer.shadowRadius = 4
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowColor = UIColor.darkGray.cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        })
        configureHierarchy()
    }
    
}
