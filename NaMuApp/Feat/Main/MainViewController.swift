//
//  MainViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private let leftLogo = UIBarButtonItem(customView: MainNavigationView())
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout())
    private let category = MainCategoryView()
    private let loadingIndicator = UIActivityIndicatorView()
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection,HomeItem>?
    
    private let viewModel = MainViewModel()
    private let inputTrigger = MainViewModel.Input(
        dataLoadTrigger: Observable((AnimateType.airing))
    )
    
    private var lastContentOffset: CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setBinding()
    }
    
    private func setBinding() {
        let output = viewModel.transform(input: inputTrigger)
        
        loadingIndicator.startAnimating()
        output.dataLoadResult.lazyBind { [weak self] animateData in
            DispatchQueue.main.async {
                if let animateData = animateData {
                    if self?.inputTrigger.dataLoadTrigger.value == .upcoming {
                        self?.setUpcomming(animateData)
                    } else {
                        self?.setSnapShot(animateData)
                    }
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
        [category, collectionView, loadingIndicator].forEach({
            self.view.addSubview($0)
        })
        configureLayout()
    }
    
    private func configureLayout() {
        category.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(4)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(category.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(self.tabBarController?.tabBar.bounds.height ?? 0))
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.center.equalToSuperview()
        }
        setDataSource()
    }
    
    private func configureView() {
        self.setNavigation()
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = leftLogo
        
        loadingIndicator.style = .medium
        loadingIndicator.color = .lightGray
        
        category.selectedItem = { [weak self] type  in
            self?.inputTrigger.dataLoadTrigger.value = type
            self?.loadingIndicator.startAnimating()
        }

        configureCollectionView()
        configureHierarchy()
    }
}

extension MainViewController {
    
    private func setUpcomming(_ data: [[AnimateData]]) {
        //TODO: Optimize
        var snapShot = NSDiffableDataSourceSnapshot<HomeSection,HomeItem>()
        
        let headerSection = HomeSection.header
        let headerData = Set(data[0]).compactMap {
            return HomeItem.poster(ItemModel(id: $0.mal_id, title: $0.title, synopsis: $0.synopsis, image: $0.images.jpg.image_url)) }
        snapShot.appendSections([headerSection])
        snapShot.appendItems(headerData, toSection: headerSection)
        
        self.dataSource?.apply(snapShot)
        self.loadingIndicator.stopAnimating()
    }
    
    //TODO: - Rx
    private func setSnapShot(_ data: [[AnimateData]]) {
        var snapShot = NSDiffableDataSourceSnapshot<HomeSection,HomeItem>()
        let totalData = data.flatMap({$0})
        
        let headerSection = HomeSection.header
        let semiHeaderSection = HomeSection.semiHeader(title: HomeSection.semiHeader(title: "").title)
        let middleSection = HomeSection.middle(title: HomeSection.middle(title: "").title)
        let semiFooterSection = HomeSection.middle(title: HomeSection.semiFooter(title: "").title)
        let footerSection = HomeSection.middle(title: HomeSection.footer(title: "").title)
        
        let headerData = Set(data[0]).compactMap {
            return HomeItem.poster(ItemModel(id: $0.mal_id, title: $0.title, synopsis: $0.synopsis, image: $0.images.jpg.image_url)) }
        
        let semiHeaderData = Set(data[1]).compactMap {
            return HomeItem.recommand(ItemModel(id: $0.mal_id, title: $0.title, synopsis: $0.synopsis, image: $0.images.jpg.image_url)) }
        
        let middleData = Set(totalData.filter({$0.score ?? 0 > 8.0})).compactMap {
            return HomeItem.tvList(ItemModel(id: $0.mal_id, title: $0.title, synopsis: $0.synopsis, image: $0.images.jpg.image_url)) }
        
        let semiFooterData = Set(totalData.filter({$0.type?.uppercased() == "TV"})).compactMap {
            return HomeItem.onaList(ItemModel(id: $0.mal_id, title: $0.title, synopsis: $0.synopsis, image: $0.images.jpg.image_url)) }
        
        let footerData = Set(totalData.filter({$0.type?.uppercased() == "ONA"})).compactMap {
            return HomeItem.special(ItemModel(id: $0.mal_id, title: $0.title, synopsis: $0.synopsis, image: $0.images.jpg.image_url)) }
        
        [headerSection, semiHeaderSection, middleSection, semiFooterSection, footerSection].forEach({
            snapShot.appendSections([$0])
        })
        
        snapShot.appendItems(headerData, toSection: headerSection)
        snapShot.appendItems(semiHeaderData, toSection: semiHeaderSection)
        snapShot.appendItems(middleData, toSection: middleSection)
        snapShot.appendItems(semiFooterData, toSection: semiFooterSection)
        snapShot.appendItems(footerData, toSection: footerSection)
        
        self.dataSource?.apply(snapShot) {
            DispatchQueue.main.async {
                self.collectionView.setContentOffset(.zero, animated: true)
            }
        }
        
        self.loadingIndicator.stopAnimating()
    }
    
}

//MARK: - CollectionView
extension MainViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(PosterCell.self, forCellWithReuseIdentifier: PosterCell.id)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.id)
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 12
        config.scrollDirection = .vertical
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
            let width = (UIScreen.main.bounds.width)
            if section == .header {
                return (self?.createLayout(width: 0.85, height: (width * 0.85) * 1.2, .groupPagingCentered))
            } else if section == .semiHeader(title: HomeSection.semiHeader(title: "").title) {
                return (self?.createLayout(width: 0.45, height: (width * 0.45) * 1.2, .continuous))
            } else {
                return (self?.createLayout(width: 0.3, height: (width * 0.3) * 1.2, .continuous))
            }
        }, configuration: config)
    }
    
    func createLayout(width: Double, height: CGFloat,_ alignment: UICollectionLayoutSectionOrthogonalScrollingBehavior) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(width), heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
        section.interGroupSpacing = 12
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
    
    private func setCell(_ data: ItemModel,_ title: Bool,_ subTitle: Bool, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.id, for: indexPath) as? PosterCell else { return UICollectionViewCell() }
        cell.configure(data, title, subTitle)
        return cell
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HomeSection,HomeItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .poster(let data):
                return self.setCell(data, false, true, indexPath: indexPath)
            case .recommand(let data),
                    .tvList(let data),
                    .onaList(let data),
                    .special(let data):
                return self.setCell(data, true, false, indexPath: indexPath)
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
        guard let cell = collectionView.cellForItem(at: indexPath) as? PosterCell else { return }
        //TODO: - 이동
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.bounds.height
        
        if currentOffset >= maxOffset {
            return
        }
        
        if (lastContentOffset <= 0) || (lastContentOffset > currentOffset) {
            self.navigationController?.navigationBar.isHidden = false
            self.additionalSafeAreaInsets.top = 0
        } else if (lastContentOffset < currentOffset) {
            self.navigationController?.navigationBar.isHidden = true
            self.additionalSafeAreaInsets.top = -44
        }
        lastContentOffset = currentOffset
    }
    
}
