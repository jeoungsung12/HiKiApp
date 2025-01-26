//
//  BackDropTableViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/26/25.
//

import UIKit
import SnapKit

class BackDropTableViewCell: UITableViewCell {
    static let id: String = "BackDropTableViewCell"
    private let pageControl = UIPageControl()
    private let genreLabel = UILabel()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.setcollectionViewLayout())

    var backdrops: [ImageDetailModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.isUserInteractionEnabled = true
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ model: SearchResult) {
        //TODO: Label이 아니네
        genreLabel.text = model.release_date + model.vote_average.formatted()
    }
}

extension BackDropTableViewCell {
    
    private func configureHierarchy() {
        self.addSubview(collectionView)
        self.addSubview(pageControl)
        self.addSubview(genreLabel)
        configureLayout()
    }
    
    private func configureLayout() {
        
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 3)
        }
        
        pageControl.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(collectionView.snp.bottom).offset(-24)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(collectionView.snp.bottom).offset(4)
            make.bottom.horizontalEdges.equalToSuperview().inset(12)
        }
    }
    
    private func configureView() {
        self.backgroundColor = .black
        pageControl.currentPage = 0
        pageControl.numberOfPages = 5
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .customLightGray
        
        genreLabel.textColor = .lightGray
        genreLabel.textAlignment = .center
        genreLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        configureCollectionView()
        configureHierarchy()
    }
    
}

extension BackDropTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackDropCollectionViewCell.id, for: indexPath) as? BackDropCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(backdrops[indexPath.row].file_path)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
}
