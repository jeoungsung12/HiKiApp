//
//  BackDropTableViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/26/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TeaserTableViewCell: BaseTableViewCell, ReusableIdentifier {
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setcollectionViewLayout())
    private let titleLabel = UILabel()
    private let resultLabel = UILabel()

    private let viewModel = TeaserTableViewModel()
    let input = TeaserTableViewModel.Input(inputTrigger: PublishSubject())
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
        setBinding()
    }
    
    private func setBinding() {
        let output = viewModel.transform(input)
        
        output.teaserResult
            .bind(with: self) { owner, data in
                owner.resultLabel.text = (data.isEmpty) ? NetworkError.noImage : nil
            }
            .disposed(by: disposeBag)
        
        output.teaserResult
            .bind(to: collectionView.rx.items(cellIdentifier: DetailTeaserCollectionViewCell.id, cellType: DetailTeaserCollectionViewCell.self)) { items, element, cell in
                cell.configure(element.trailerURL)
            }.disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        [titleLabel, collectionView, resultLabel].forEach({
            self.contentView.addSubview($0)
        })
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().inset(12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(320)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        resultLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    override func configureView() {
        self.backgroundColor = .white
        
        titleLabel.text = "Teaser"
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        resultLabel.textColor = .gray
        resultLabel.textAlignment = .center
        resultLabel.font = .boldSystemFont(ofSize: 15)
        
        configureCollectionView()
    }
    
}

extension TeaserTableViewCell {
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DetailTeaserCollectionViewCell.self, forCellWithReuseIdentifier: DetailTeaserCollectionViewCell.id)
    }
    
    private func setcollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let width = UIScreen.main.bounds.width - 48
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(width),
            heightDimension: .absolute(width * 0.9)
        )
        let group = NSCollectionLayoutGroup.horizontal (
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 24,
            bottom: 0,
            trailing: 24
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}
