//
//  MoviePosterCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import Kingfisher
import SnapKit

final class MoviePosterCell: UICollectionViewCell {
    static let id: String = "MoviePosterCell"
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let heartButton = UIButton()
    private let db = Database.shared
    private var buttonTapped: Bool = false
    
    var isButton: (()->Void)?
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
    
    func configure(_ model: SearchResult) {
        if let poster_path = model.poster_path,
            let url = URL(string: APIEndpoint.trending.imagebaseURL + poster_path) {
            //TODO: - image down smapling
            imageView.kf.setImage(with: url)
            imageView.kf.indicatorType = .activity
        }
        titleLabel.text = model.title
        descriptionLabel.text = model.overview
        buttonTapped = db.heartList.contains(model.title)
        heartButton.setImage(UIImage(systemName: (db.heartList.contains(model.title)) ? "heart.fill" : "heart"), for: .normal)
    }
    
}

extension MoviePosterCell {
    
    private func configureHierarchy() {
        self.addSubview(imageView)
        self.addSubview(heartButton)
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        configureLayout()
    }
    
    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().dividedBy(1.5)
        }
        
        heartButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.trailing.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.trailing.equalTo(heartButton.snp.leading).offset(-4)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(heartButton.snp.bottom).offset(4)
            make.bottom.lessThanOrEqualToSuperview().offset(-4)
        }
        
    }
    
    private func configureView() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .darkGray
        
        heartButton.tintColor = .point
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = .systemFont(ofSize: 15, weight: .regular)
        
        configureHierarchy()
    }
    
}

extension MoviePosterCell {
    
    @objc
    private func heartButtonTapped(_ sender: UIButton) {
        print(#function)
        if let text = titleLabel.text {
            buttonTapped.toggle()
            if buttonTapped {
                var list = db.heartList
                list.append(text)
                db.heartList = list
            } else {
                db.removeHeartButton(text)
            }
            isButton?()
        }
    }
}
