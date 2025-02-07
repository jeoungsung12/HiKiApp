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
    private var db = Database.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
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
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(category.snp.bottom)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.center.equalToSuperview()
        }
        setDataSource()
        fetchData()
    }
    
    private func configureView() {
        self.setNavigation()
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = leftLogo
        
        loadingIndicator.style = .medium
        loadingIndicator.color = .lightGray
        
        configureCollectionView()
        configureHierarchy()
    }
}

//MARK: - Action
extension MainViewController {
    
    private func fetchData() {
        loadingIndicator.startAnimating()
        AnimateServices().getTopAnime(type: .airing) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case let .success(data):
                self.setBinding(data)
            case let .failure(error):
                self.errorPresent(error)
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    //TODO: - Rx
    private func setBinding(_ data: [AnimateData]) {
        var snapShot = NSDiffableDataSourceSnapshot<HomeSection,HomeItem>()

        let headerSection = HomeSection.header
        let headerData = Set(data).map {
            return HomeItem.poster(ItemModel(id: $0.mal_id, image: $0.images.jpg.image_url)) }
        snapShot.appendSections([headerSection])
        snapShot.appendItems(headerData, toSection: headerSection)
        
        let semiHeader = HomeSection.semiHeader(title: "")
        
        
        self.dataSource?.apply(snapShot)
        self.loadingIndicator.stopAnimating()
    }
    
}

//MARK: - CollectionView
extension MainViewController {
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(HeaderPosterCell.self, forCellWithReuseIdentifier: HeaderPosterCell.id)
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 24
        config.scrollDirection = .vertical
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
            
            switch section {
            case .header:
                return self?.createHeaderLayout()
            case .semiHeader(let title):
                return self?.createHeaderLayout()
            case .middle(let title):
                return self?.createHeaderLayout()
            case .semiFooter(let title):
                return self?.createHeaderLayout()
            case .footer(let title):
                return self?.createHeaderLayout()
            case nil:
                return self?.createHeaderLayout()
            }
        }, configuration: config)
        
    }
    
    private func createHeaderLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .fractionalHeight(0.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HomeSection,HomeItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .poster(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderPosterCell.id, for: indexPath) as? HeaderPosterCell else { return UICollectionViewCell() }
                cell.configureImage(data.image)
                return cell
            case .list:
                
                return UICollectionViewCell()
            case .recommand:
                
                return UICollectionViewCell()
            case .age:
                
                return UICollectionViewCell()
            }
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "", for: indexPath)
            let section = self?.dataSource?.sectionIdentifier(for: indexPath.section)
            
            switch section {
            case .header:
                print("header")
//                (header as? HeaderView)?.configure(title: title)
            case .semiHeader(title: ""):
                print("category")
            case .middle(title: ""):
                print("horizontinal")
            case .semiFooter(title: ""):
                print("vertical")
            case .footer(title: ""):
                print("vertical")
            default:
                print("Default")
            }
            return header
        }
    }
}
