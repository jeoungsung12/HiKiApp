//
//  MoviePosterCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import Kingfisher
import SnapKit

final class PosterCell: UICollectionViewCell {
    static let id: String = "MoviePosterCell"
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    
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
    
    func configure(_ data: ItemModel,_ titleHide: Bool,_ subTitleHide: Bool) {
        titleLabel.text = !titleHide ? data.title : ""
        subtitleLabel.text = !subTitleHide ? data.title : ""
        if let url = URL(string: data.image) {
            imageView.kf.setImage(with: url)
        }
    }
    
}

extension PosterCell {
    
    private func configureHierarchy() {
        [imageView, titleLabel, subtitleLabel].forEach({
            self.addSubview($0)
        })
        configureLayout()
    }
    
    private func configureLayout() {
        
        imageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-52)
            make.top.horizontalEdges.equalToSuperview()
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
    }
    
    private func configureView() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .darkGray
        
        titleLabel.textColor = .customWhite
        titleLabel.font = .systemFont(ofSize: 40, weight: .heavy)
        
        subtitleLabel.textColor = .gray
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        [imageView, titleLabel].forEach({
            $0.layer.shadowRadius = 4
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowColor = UIColor.darkGray.cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        })
        configureHierarchy()
    }
    
}
