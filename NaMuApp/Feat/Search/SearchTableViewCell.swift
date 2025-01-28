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
    let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let heartButton = UIButton()
    private let genreView = GenreView()
    private let db = Database.shared
    private var buttonTapped: Bool = false
    
    var isButton: (()->Void)?
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
    
    func configure(_ search: String,_ model: SearchResult) {
        if let poster_path = model.poster_path,
            let url = URL(string: APIEndpoint.trending.imagebaseURL + poster_path) {
            posterImageView.kf.setImage(with: url, placeholder: UIImage(systemName: ""))
            posterImageView.kf.indicatorType = .activity
        }
        highlightLabel(search, model.title)
        dateLabel.text = model.release_date
        genreView.configure(model, .search)
        buttonTapped = db.heartList.contains(model.title)
        heartButton.setImage(UIImage(systemName: (db.heartList.contains(model.title)) ? "heart.fill" : "heart"), for: .normal)
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
        self.contentView.backgroundColor = .customBlack
        
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 15
        posterImageView.contentMode = .scaleToFill
        posterImageView.backgroundColor = .darkGray
        
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .customWhite
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 15)
        
        dateLabel.textColor = .customDarkGray
        dateLabel.textAlignment = .left
        dateLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        heartButton.tintColor = .point
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        
        configureHierarchy()
    }
}

extension SearchTableViewCell {
    
    private func highlightLabel(_ search: String,_ text: String) {
        if let range = text.range(of: search, options: .caseInsensitive) {
            let nsRange = NSRange(range, in: text)
            let attributes = NSMutableAttributedString(string: text)
            attributes.addAttribute(.foregroundColor, value: UIColor.point, range: nsRange)
            titleLabel.attributedText = attributes
        } else {
            let attributes = NSMutableAttributedString(string: text)
            titleLabel.attributedText = attributes
        }
    }
    
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
