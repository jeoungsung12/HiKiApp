//
//  WatchViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/9/25.
//

import UIKit
import SnapKit
import NVActivityIndicatorView
import RxSwift
import RxCocoa

final class TeaserViewController: BaseViewController {
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulseSync, color: .point)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    
    private let viewModel = TeaserViewModel()
    private let inputTrigger = TeaserViewModel.Input(dataTrigger: BehaviorRelay(value: 1))
    private var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func setBindView() {
        collectionView.rx.willDisplayCell
            .bind(with: self) { owner, value in
                guard let cell = value.cell as? TeaserCollectionViewCell else { return }
                cell.playVideoIfNeeded()
            }.disposed(by: disposeBag)
        
        collectionView.rx.didEndDisplayingCell
            .bind(with: self) { owner, value in
                guard let cell = value.cell as? TeaserCollectionViewCell else { return }
                cell.stopVideo()
            }.disposed(by: disposeBag)
    }
    
    override func setBinding() {
        let outputResult = viewModel.transform(inputTrigger)
        outputResult.dataResult
            .bind(to: collectionView.rx.items(cellIdentifier: TeaserCollectionViewCell.id, cellType: TeaserCollectionViewCell.self)) { row, element, cell in
                cell.configure(element)
                self.loadingIndicator.stopAnimating()
            }.disposed(by: disposeBag)
        
        //TODO: Paging
    }
    
    override func configureHierarchy() {
        setNavigation("티저 모아보기")
        [collectionView, loadingIndicator].forEach({
            self.view.addSubview($0)
        })
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.center.equalToSuperview()
        }
        loadingIndicator.startAnimating()
    }
    
    override func configureView() {
        self.view.backgroundColor = .black
        configureCollectionView()
    }
    
    deinit {
        print(#function, self)
    }
    
}


extension TeaserViewController {
    
    private func configureCollectionView() {
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TeaserCollectionViewCell.self, forCellWithReuseIdentifier: TeaserCollectionViewCell.id)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let width = UIScreen.main.bounds.width - 48
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(width),
            heightDimension: .absolute(width * 1.5)
        )
        let group = NSCollectionLayoutGroup.horizontal (
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 4
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 24,
            bottom: 0,
            trailing: 24
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}
