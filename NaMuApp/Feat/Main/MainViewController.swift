//
//  MainViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private let leftLogo = UIBarButtonItem(title: "HiKi", style: .plain, target: nil, action: nil)
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout())
    private let category = MainCategoryView()
    private let loadingIndicator = UIActivityIndicatorView()
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection,HomeItem>?
    
    private let viewModel = MainViewModel()
    private let inputTrigger = MainViewModel.Input(
        dataLoadTrigger: Observable((AnimeType.airing))
    )
    
    private var lastContentOffset: CGFloat = 0
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
                    self?.setSnapShot(animateData)
                } else {
                    self?.errorPresent(.notFount)
                }
            }
        }
        
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
            make.bottom.equalToSuperview().offset(-24)
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
        self.navigationController?.hidesBarsOnSwipe = true
        
        loadingIndicator.style = .medium
        loadingIndicator.color = .lightGray

        configureCollectionView()
        configureHierarchy()
    }
}

extension MainViewController {
    
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
        
        let middleData = Set(totalData.filter({$0.type.uppercased() == "TV"})).compactMap {
            return HomeItem.tvList(ItemModel(id: $0.mal_id, title: $0.title, synopsis: $0.synopsis, image: $0.images.jpg.image_url)) }
        
        let semiFooterData = Set(totalData.filter({$0.type.uppercased() == "ONA"})).compactMap {
            return HomeItem.onaList(ItemModel(id: $0.mal_id, title: $0.title, synopsis: $0.synopsis, image: $0.images.jpg.image_url)) }
        
        let footerData = Set(totalData.filter({$0.type.uppercased() == "TV SPECIAL"})).compactMap {
            return HomeItem.special(ItemModel(id: $0.mal_id, title: $0.title, synopsis: $0.synopsis, image: $0.images.jpg.image_url)) }
        
        [headerSection, semiHeaderSection, middleSection, semiFooterSection, footerSection].forEach({
            snapShot.appendSections([$0])
        })
        
        snapShot.appendItems(headerData, toSection: headerSection)
        snapShot.appendItems(semiHeaderData, toSection: semiHeaderSection)
        snapShot.appendItems(middleData, toSection: middleSection)
        snapShot.appendItems(semiFooterData, toSection: semiFooterSection)
        snapShot.appendItems(footerData, toSection: footerSection)
        
        self.dataSource?.apply(snapShot)
        self.loadingIndicator.stopAnimating()
    }
    
}

//MARK: - CollectionView
extension MainViewController {
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(PosterCell.self, forCellWithReuseIdentifier: PosterCell.id)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.id)
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 24
        config.scrollDirection = .vertical
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
            if section == .header {
                return (self?.createLayout(width: 0.85, height: UIScreen.main.bounds.height / 2.0, .groupPagingCentered))
            } else if section == .semiHeader(title: HomeSection.semiHeader(title: "").title) {
                return (self?.createLayout(width: 0.45, height: 250, .continuous))
            } else {
                return (self?.createLayout(width: 0.3, height: 180, .continuous))
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
    
    private func setCell(_ data: ItemModel,_ valid: Bool, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.id, for: indexPath) as? PosterCell else { return UICollectionViewCell() }
        cell.configure(data, valid)
        return cell
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HomeSection,HomeItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .poster(let data):
                return self.setCell(data, false, indexPath: indexPath)
            case .recommand(let data):
                return self.setCell(data, true, indexPath: indexPath)
            case .tvList(let data):
                return self.setCell(data, true, indexPath: indexPath)
            case .onaList(let data):
                return self.setCell(data, true, indexPath: indexPath)
            case .special(let data):
                return self.setCell(data, true, indexPath: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath)
            let section = self?.dataSource?.sectionIdentifier(for: indexPath.section)
            switch section {
            case .header:
                print("header")
            case .semiHeader(let title):
                (header as? HeaderView)?.configure(title: title)
            case .middle(let title):
                (header as? HeaderView)?.configure(title: title)
            case .semiFooter(let title):
                (header as? HeaderView)?.configure(title: title)
            case .footer(let title):
                (header as? HeaderView)?.configure(title: title)
            default:
                print("default")
            }
            return header
        }
    }
    
}
