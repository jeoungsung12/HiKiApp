//
//  CastTableViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/26/25.
//

import UIKit
import SnapKit

class CharactersTableViewCell: UITableViewCell {
    static let id: String = "CharactersTableViewCell"
    private let titleLabel = UILabel()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setCollectionViewLayout())
    
    var charactersData: [CharacterData] = [] {
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

extension CharactersTableViewCell {
    
    private func configureHierarchy() {
        [titleLabel, collectionView].forEach({
            self.addSubview($0)
        })
        configureLayout()
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(250)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
    }
    
    private func configureView() {
        self.backgroundColor = .white
        titleLabel.text = "Characters"
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        configureCollectionView()
        configureHierarchy()
    }
    
}

extension CharactersTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CharactersCollectionViewCell.self, forCellWithReuseIdentifier: CharactersCollectionViewCell.id)
    }
    
    private func setCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.itemSize = CGSize(width: 100, height: 120)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return charactersData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharactersCollectionViewCell.id, for: indexPath) as? CharactersCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(charactersData[indexPath.row].character)
        return cell
    }
}
