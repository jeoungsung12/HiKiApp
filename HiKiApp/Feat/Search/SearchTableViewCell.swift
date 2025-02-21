//
//  SearchTableViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import Kingfisher
import SnapKit

class SearchTableViewCell: BaseTableViewCell, ReusableIdentifier {
    private let posterImageView = UIImageView()
    private let imageResult = UILabel()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let heartButton = UIButton()
    private let db = DataBase.shared
    private var buttonTapped: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        imageResult.text = NetworkError.noImage
    }
    
    override func configureHierarchy() {
        [posterImageView, imageResult, titleLabel, dateLabel, heartButton].forEach({
            self.contentView.addSubview($0)
        })
    }
    
    override func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.width.equalToSuperview().dividedBy(4)
            make.verticalEdges.equalToSuperview().inset(12)
        }
        
        imageResult.snp.makeConstraints { make in
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
        
    }
    
    override func configureView() {
        self.contentView.backgroundColor = .white
        imageResult.numberOfLines = 0
        imageResult.textColor = .black
        imageResult.textAlignment = .center
        imageResult.backgroundColor = .clear
        imageResult.font = .boldSystemFont(ofSize: 15)
        
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 15
        posterImageView.contentMode = .scaleToFill
        posterImageView.backgroundColor = .darkGray
        
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 15)
        
        dateLabel.textAlignment = .left
        dateLabel.textColor = .customDarkGray
        dateLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        heartButton.tintColor = .point
        //TODO: ViewModel
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
    }
    
    func configure(_ search: String,_ model: AnimateDataEntity) {
        highlightLabel(search, model.title)
        dateLabel.text = model.enTitle
        buttonTapped = db.heartList.contains(model.title)
        heartButton.setImage(UIImage(systemName: (db.heartList.contains(model.title)) ? "heart.fill" : "heart"), for: .normal)
        if let url = URL(string: model.imageURL) {
            imageResult.text = nil
            posterImageView.kf.setImage(with: url)
        }
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
    
    //TODO: ViewModel
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
        }
    }
    
}
