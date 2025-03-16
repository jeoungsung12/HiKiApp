//
//  MineReviewTableViewCell.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/24/25.
//

import UIKit
import SnapKit
import Cosmos
import Kingfisher
import RxSwift
import RxCocoa

final class MineReviewTableViewCell: BaseTableViewCell, ReusableIdentifier {
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    
    private let posterImageView = UIImageView()
    private let cosmosView = CosmosView()
    
    private let reviewTitle = UILabel()
    private let reviewLabel = UILabel()
    private let answerTitle = UILabel()
    private let answerLabel = UILabel()
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
    }
    
    override func configureHierarchy() {
        [posterImageView, titleLabel, dateLabel, cosmosView, reviewTitle, reviewLabel, answerTitle, answerLabel].forEach({
            self.contentView.addSubview($0)
        })
    }
    
    override func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.width.equalTo(130)
            make.height.equalTo(170)
            make.top.leading.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(24)
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
        }
        
        dateLabel.snp.makeConstraints { make in make.trailing.equalToSuperview().inset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(24)
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
        }
        
        cosmosView.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
        }
        
        reviewTitle.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(posterImageView.snp.bottom).offset(12)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(reviewTitle.snp.bottom).offset(8)
        }
        
        answerTitle.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(reviewLabel.snp.bottom).offset(12)
        }
        
        answerLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(answerTitle.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    override func configureView() {
        self.backgroundColor = .white
        
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 3
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
        dateLabel.textColor = .gray
        dateLabel.textAlignment = .left
        dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
        [reviewLabel, answerLabel].forEach {
            $0.textColor = .darkGray
            $0.textAlignment = .left
            $0.numberOfLines = (0)
            $0.font = .systemFont(ofSize: 15, weight: .regular)
        }
        
        [reviewTitle, answerTitle].forEach {
            $0.textColor = .black.withAlphaComponent(0.8)
            $0.textAlignment = .left
            $0.numberOfLines = (1)
            $0.font = .systemFont(ofSize: 17, weight: .semibold)
        }
        
        reviewTitle.text = "My Review"
        answerTitle.text = "↪️ Answer"
        
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 20
        posterImageView.contentMode = .scaleToFill
        
        cosmosView.settings.starSize = 15
        cosmosView.settings.totalStars = 5
        cosmosView.isUserInteractionEnabled = false
        cosmosView.settings.emptyColor = .white
        cosmosView.settings.filledColor = .systemYellow
    }
    
    func configure(_ model: UserReview) {
        titleLabel.text = model.title
        dateLabel.text = model.date
        cosmosView.rating = model.reviewValue
        reviewLabel.text = model.review
        answerLabel.text = model.answer
        
        if let url = URL(string: model.image) {
            posterImageView.kf.setImage(with: url)
        }
    }
    
}
