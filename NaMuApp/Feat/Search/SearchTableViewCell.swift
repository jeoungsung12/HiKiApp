//
//  SearchTableViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import Kingfisher
import SnapKit

class SearchTableViewCell: UITableViewCell {
    static let id: String = "SearchTableViewCell"
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let heartButton = UIButton()
    private let genreView = GenreView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
    
    func configure(_ model: SearchResult) {
        if let poster_path = model.poster_path,
            let url = URL(string: APIEndpoint.trending.imagebaseURL + poster_path) {
            posterImageView.kf.setImage(with: url, placeholder: UIImage(systemName: ""))
            posterImageView.kf.indicatorType = .activity
        }
        titleLabel.text = model.title
        dateLabel.text = model.release_date
        genreView.configure(model, .search)
    }

}

extension SearchTableViewCell {
    
    private func configureHierarchy() {
        self.addSubview(posterImageView)
        self.addSubview(titleLabel)
        self.addSubview(dateLabel)
        self.addSubview(heartButton)
        self.addSubview(genreView)
        
        configureLayout()
    }
    
    private func configureLayout() {
        
        posterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.width.equalToSuperview().dividedBy(4)
            make.verticalEdges.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
        }
        
        heartButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.bottom.trailing.equalToSuperview().inset(12)
        }
        
        genreView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.bottom.equalToSuperview().inset(12)
            make.trailing.equalTo(heartButton.snp.leading).offset(-12)
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
        }
        
    }
    
    private func configureView() {
        self.contentView.backgroundColor = .black
        
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 15
        posterImageView.contentMode = .scaleToFill
        posterImageView.backgroundColor = .darkGray
        
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 15)
        
        dateLabel.textColor = .gray
        dateLabel.textAlignment = .left
        dateLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        heartButton.tintColor = .point
        heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        
        configureHierarchy()
    }
}
