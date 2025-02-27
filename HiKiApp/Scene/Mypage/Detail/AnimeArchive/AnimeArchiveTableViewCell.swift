//
//  AnimeArchiveTableViewCell.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/23/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AnimeArchiveTableViewCell: BaseTableViewCell, ReusableIdentifier {
    private let posterImageView = UIImageView()
    private let imageResult = UILabel()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let heartButton = UIButton()
    private var buttonTapped: Bool = false
    
    private let viewModel = SearchTableViewModel()
    private lazy var inputTigger = SearchTableViewModel.Input(
        heartBtnTrigger: self.heartButton.rx.tap,
        heartLoadTrigger: PublishRelay<Int>()
    )
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setBinding()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        imageResult.text = NetworkError.noImage
    }
    
    private func setBinding() {
        let output = viewModel.transform(inputTigger)
        
        output.heartBtnResult
            .drive(with: self) { owner, valid in
                let image = (valid) ? UIImage(systemName: "heart.circle.fill") : UIImage(systemName: "heart.circle")
                owner.heartButton.setImage(image, for: .normal)
            }
            .disposed(by: disposeBag)
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
        dateLabel.numberOfLines = 3
        dateLabel.textColor = .customDarkGray
        dateLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        heartButton.tintColor = .point
    }
    
    func configure(_ model: AnimateDetailEntity) {
        viewModel.id = model.id
        titleLabel.text = model.title
        dateLabel.text = model.synopsis
        inputTigger.heartLoadTrigger.accept(model.id)
        if let url = URL(string: model.imageURL) {
            imageResult.text = nil
            posterImageView.kf.setImage(with: url)
        }
    }
    
}
