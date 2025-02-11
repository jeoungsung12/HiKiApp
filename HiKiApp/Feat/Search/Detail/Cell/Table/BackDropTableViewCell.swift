//
//  BackDropTableViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/26/25.
//

import UIKit
import SnapKit

final class BackDropTableViewCell: UITableViewCell {
    static let id: String = "BackDropTableViewCell"
    private let pageControl = UIPageControl()
    private let genreView = GenreView()
    private let imageResult = UILabel()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setcollectionViewLayout())

    var backdrops: [ImageDetailModel] = [] {
        didSet {
            updateResultLabel()
            collectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = false
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ model: SearchResult) {
        genreView.configure(model, .detail)
        pageControl.numberOfPages = (backdrops.count > 5) ? 5 : backdrops.count
    }
}

extension BackDropTableViewCell {
    
    private func configureHierarchy() {
        self.addSubview(collectionView)
        self.addSubview(imageResult)
        self.addSubview(genreView)
        self.addSubview(pageControl)
        configureLayout()
    }
    
    private func configureLayout() {
        
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 3)
        }
        
        imageResult.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 3)
        }
        
        pageControl.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(collectionView.snp.bottom).offset(-24)
        }
        
        genreView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(collectionView.snp.bottom).offset(4)
            make.bottom.horizontalEdges.equalToSuperview().inset(12)
        }
    }
    
    private func configureView() {
        self.backgroundColor = .customBlack
        updateResultLabel()
        imageResult.numberOfLines = 0
        imageResult.textColor = .white
        imageResult.textAlignment = .center
        imageResult.backgroundColor = .clear
        imageResult.font = .boldSystemFont(ofSize: 15)
        
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .customWhite
        pageControl.pageIndicatorTintColor = .customDarkGray
        
        configureCollectionView()
        configureHierarchy()
    }
    
    private func updateResultLabel() {
        imageResult.text = (!backdrops.isEmpty) ? nil : NetworkError.noImage
    }
    
}

extension BackDropTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .customBlack
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(BackDropCollectionViewCell.self, forCellWithReuseIdentifier: BackDropCollectionViewCell.id)
    }
    
    private func setcollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: width * 0.7)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (backdrops.count > 5) ? 5 : backdrops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackDropCollectionViewCell.id, for: indexPath) as? BackDropCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(backdrops[indexPath.item].file_path)
        return cell
    }
    
    //MARK: - 다른 방법?
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let page = Int(scrollView.contentOffset.x / pageWidth)
        pageControl.currentPage = page
    }
}
