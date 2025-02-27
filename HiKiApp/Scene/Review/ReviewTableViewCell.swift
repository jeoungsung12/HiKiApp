//
//  ReviewTableViewCell.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/12/25.
//

import UIKit
import Kingfisher
import SnapKit
import Cosmos
import RxSwift
import RxCocoa

protocol ReviewHeightDelegate: AnyObject {
    func reloadCellHeight()
}

class ReviewTableViewCell: BaseTableViewCell, ReusableIdentifier {
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let cosmosView = CosmosView()
    private let spoilerLabel = UILabel()
    
    private let reviewLabel = UILabel()
    private let moreButton = UIButton()
    
    private var disposeBag = DisposeBag()
    weak var heightDeleate: ReviewHeightDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
        setBinding()
    }
    
    override var isSelected: Bool {
        didSet {
            configureView()
        }
    }
    
    private func setBinding() {
        moreButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.isSelected.toggle()
                owner.heightDeleate?.reloadCellHeight()
            }.disposed(by: disposeBag)
        
    }
    
    override func configureHierarchy() {
        [profileImageView, nameLabel, dateLabel, titleLabel, cosmosView, spoilerLabel, posterImageView, reviewLabel, moreButton].forEach({
            self.contentView.addSubview($0)
        })
    }
    
    override func configureLayout() {
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.top.leading.equalToSuperview().inset(12)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in make.trailing.equalToSuperview().inset(12)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.bottom.lessThanOrEqualTo(profileImageView.snp.bottom)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
        }
        
        cosmosView.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
        }
        
        spoilerLabel.snp.makeConstraints { make in
            make.top.equalTo(cosmosView.snp.bottom)
            make.trailing.equalToSuperview().inset(24)
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.width.equalTo(130)
            make.height.equalTo(170)
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(posterImageView.snp.bottom).offset(8)
        }
        
        moreButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.bottom.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(24)
            make.top.equalTo(reviewLabel.snp.bottom).offset(8)
        }
        
    }
    
    override func configureView() {
        self.backgroundColor = .white
        [nameLabel, titleLabel].forEach({
            $0.numberOfLines = 3
            $0.textAlignment = .left
            $0.font = .boldSystemFont(ofSize: 16)
        })
        
        nameLabel.textColor = .darkGray
        titleLabel.textColor = .black
        
        dateLabel.textColor = .gray
        dateLabel.textAlignment = .left
        dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
        moreButton.setTitleColor(.point, for: .normal)
        moreButton.setTitle(isSelected ? "Hide" : "More", for: .normal)
        moreButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        
        reviewLabel.textColor = .darkGray
        reviewLabel.textAlignment = .left
        reviewLabel.numberOfLines = (isSelected ? 0 : 3)
        reviewLabel.font = .systemFont(ofSize: 15, weight: .regular)
        
        [profileImageView, posterImageView].forEach({
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 20
            $0.contentMode = .scaleToFill
        })
        
        profileImageView.tintColor = .lightGray
        profileImageView.image = UIImage(systemName: "person.circle")
        
        cosmosView.settings.starSize = 15
        cosmosView.settings.totalStars = 5
        cosmosView.isUserInteractionEnabled = false
        cosmosView.settings.emptyColor = .white
        cosmosView.settings.filledColor = .systemYellow
        
        spoilerLabel.font = .boldSystemFont(ofSize: 13)
    }
    
    func configure(_ data: AnimateReviewEntity) {
        reviewLabel.text = data.review
        titleLabel.text = data.animeTitle
        nameLabel.text = data.username
        dateLabel.text = .stringToDate(data.date)
        spoilerLabel.text = (data.isSpoiler) ? "Beware of Spoilers!" : nil
        spoilerLabel.textColor = (data.isSpoiler) ? .systemRed.withAlphaComponent(0.7) : .white
        cosmosView.rating = Double(data.score) / 2.0
        
        if let url = URL(string: data.imageUrl) {
            posterImageView.kf.setImage(with: url)
        }
    }
    
}
