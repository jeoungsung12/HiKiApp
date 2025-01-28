//
//  PosterTableViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/26/25.
//

import UIKit
import SnapKit

class PosterTableViewCell: UITableViewCell {
    static let id: String = "PosterTableViewCell"
    private let titleLabel = UILabel()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setcollectionViewLayout())

    var posterData: [ImageDetailModel] = [] {
        didSet {
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
    

}

extension PosterTableViewCell {
    
    private func configureHierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(collectionView)
        configureLayout()
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }
    
    private func configureView() {
        self.backgroundColor = .customBlack
        
        titleLabel.text = "Poster"
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .customWhite
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
        configureCollectionView()
        configureHierarchy()
    }
    
}

extension PosterTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .customBlack
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.id)
    }
    
    private func setcollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 3.5
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: width * 1.5)
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posterData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.id, for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(posterData[indexPath.row])
        return cell
    }
}
