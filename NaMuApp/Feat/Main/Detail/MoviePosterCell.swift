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
        buttonTapped = db.heartList.contains(model.title)
        heartButton.setImage(UIImage(systemName: (db.heartList.contains(model.title)) ? "heart.fill" : "heart"), for: .normal)
    }
    
    private func configureImage(_ urlString: String?) {
        if let poster_path = urlString,
            let url = URL(string: APIEndpoint.trending.imagebaseURL + poster_path) {
            imageView.kf.setImage(with: url) { result in
                switch result {
                case .success:
                    self.imageView.image = self.imageView.image?.downSampling(scale: 0.5)
                case .failure:
                    self.imageView.kf.setImage(with: url)
                }
            }
        } else {
            imageResult.text = NetworkError.noImage
        }
    }
    
}

extension MoviePosterCell {
    
    private func configureHierarchy() {
        self.addSubview(imageView)
        self.addSubview(imageResult)
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
        
        imageResult.snp.makeConstraints { make in
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
        imageResult.numberOfLines = 0
        imageResult.textColor = .white
        imageResult.textAlignment = .center
        imageResult.backgroundColor = .clear
        imageResult.font = .boldSystemFont(ofSize: 15)
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .darkGray
        
        heartButton.tintColor = .point
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        
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
                isButton?(true)
            } else {
                db.removeHeartButton(text)
                isButton?(false)
            }
        }
    }
}
