//
//  MainViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

final class MainViewController: UIViewController {
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulseSync, color: .point)
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout())
    private let leftLogo = UIBarButtonItem(customView: MainNavigationView())
    private let category = MainCategoryView()
    private var categoryTopConstraint: Constraint?
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection,HomeItem>?
    
    private let viewModel = MainViewModel()
    private let inputTrigger = MainViewModel.Input(
        dataLoadTrigger: Observable((AnimateType.airing))
    )
    private lazy var outputResult = viewModel.transform(input: inputTrigger)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setBinding()
    }
    
    private func setBinding() {
        loadingIndicator.startAnimating()
        outputResult.dataLoadResult.lazyBind { [weak self] animateData in
            DispatchQueue.main.async {
                if let animateData = animateData {
                    self?.setSnapShot(self?.viewModel.setData(animateData))
                    self?.category.isUserInteractionEnabled = true
                } else {
                    self?.errorPresent(.notFount)
                }
            }
        }
    }
    
    deinit {
        print(#function, self)
    }
    
}

//MARK: - Configure UI
extension MainViewController {
    
    private func configureHierarchy() {
        [collectionView, category, loadingIndicator].forEach({
            self.view.addSubview($0)
        })
        configureLayout()
    }
    
    private func configureLayout() {
        category.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview()
            self.categoryTopConstraint = make.top.equalToSuperview().constraint
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(category.snp.bottom)
            make.horizontalEdges.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-(self.tabBarController?.tabBar.bounds.height ?? 0))
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        setDataSource()
    }
    
    private func configureView() {
        self.setNavigation()
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = leftLogo
        
        category.selectedItem = { [weak self] type  in
            self?.inputTrigger.dataLoadTrigger.value = type
            self?.category.isUserInteractionEnabled = false
            self?.loadingIndicator.startAnimating()
        }

        configureCollectionView()
        configureHierarchy()
    }
}

extension MainViewController {
    //TODO: - Rx
    private func setSnapShot(_ sectionItem: SectionItem?) {
        guard let sectionItem = sectionItem else { return }
        var snapShot = NSDiffableDataSourceSnapshot<HomeSection,HomeItem>()
       
        sectionItem.section.forEach({
            snapShot.appendSections([$0])
        })
        
        for (index, section) in sectionItem.section.enumerated() {
            snapShot.appendItems(sectionItem.item[index], toSection: section)
        }
        
        self.dataSource?.apply(snapShot) {
            //TODO: Row까지 초기화
            DispatchQueue.main.async {
                self.collectionView.setContentOffset(.zero, animated: true)
            }
        }
        loadingIndicator.stopAnimating()
    }
    
}

//MARK: - CollectionView
extension MainViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(MainHeaderCell.self, forCellWithReuseIdentifier: MainHeaderCell.id)
        collectionView.register(MainPosterCell.self, forCellWithReuseIdentifier: MainPosterCell.id)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.id)
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 4
        config.scrollDirection = .vertical
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
            let width = (UIScreen.main.bounds.width)
            if section == .header {
                return (self?.createLayout(width: 0.85, height: (width * 0.85), spacing: -44, .groupPagingCentered))
            } else if section == .semiHeader(title: HomeSection.semiHeader(title: "").title) {
                return (self?.createLayout(width: 0.4, height: (width * 0.4) * 1.7, .continuous))
            } else {
                return (self?.createLayout(width: 0.3, height: (width * 0.3) * 1.7, .continuous))
            }
        }, configuration: config)
    }
    
    private func createLayout(width: Double, height: CGFloat, spacing: CGFloat = 12,_ alignment: UICollectionLayoutSectionOrthogonalScrollingBehavior) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(width), heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
        section.interGroupSpacing = spacing
        section.orthogonalScrollingBehavior = alignment
        
        if alignment == .continuous {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
            section.boundarySupplementaryItems = [header]
        }
        
        return section
    }
    
    private func setCell(_ data: ItemModel,_ type: PosterType,_ indexPath: IndexPath) -> UICollectionViewCell {
        switch type {
        case .rank:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainHeaderCell.id, for: indexPath) as? MainHeaderCell else { return UICollectionViewCell() }
            cell.configure(data, indexPath.row + 1)
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainPosterCell.id, for: indexPath) as? MainPosterCell else { return UICollectionViewCell() }
            cell.configure(data, type)
            return cell
        }
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HomeSection,HomeItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .poster(let data):
                return self.setCell(data, .rank, indexPath)
            case .rank(let data):
                return self.setCell(data, .star, indexPath)
            case .recommand(let data),
                    .tvList(let data),
                    .onaList(let data):
                return self.setCell(data, .other, indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath)
            let section = self?.dataSource?.sectionIdentifier(for: indexPath.section)
            switch section {
            case .semiHeader(let title),
                    .middle(let title),
                    .semiFooter(let title),
                    .footer(let title):
                (header as? HeaderView)?.configure(title: title)
            default:
                return UICollectionReusableView()
            }
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        switch selectedItem {
        case .poster(let itemModel),
                .recommand(let itemModel),
                .rank(let itemModel),
                .tvList(let itemModel),
                .onaList(let itemModel):
            let vc = SearchDetailViewController()
            vc.id = itemModel.id
            self.push(vc)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y
        navigationController?.navigationBar.transform = .init(translationX: 0, y: -offset)
        let newTopOffset = max(defaultOffset - (offset), 60)
        categoryTopConstraint?.update(offset: newTopOffset)
    }
}
