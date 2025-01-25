//
//  SearchDetailTableViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import UIKit

final class SearchDetailTableViewCell: UITableViewCell {
    static let id: String = "SearchDetailTableViewCell"
    private let collectionView = UICollectionView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SearchDetailTableViewCell {
    
    private func configureHierarchy() {
        self.addSubview(collectionView)
        configureLayout()
    }
    
    private func configureLayout() {
        
    }
    
    private func configureView() {
        
        configureHierarchy()
    }
    
}

extension SearchDetailTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BackDropCollectionViewCell.self, forCellWithReuseIdentifier: BackDropCollectionViewCell.id)
        collectionView.register(SynopsisCollectionViewCell.self, forCellWithReuseIdentifier: SynopsisCollectionViewCell.id)
        collectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.id)
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.id)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return UICollectionViewCell()
    }
}
