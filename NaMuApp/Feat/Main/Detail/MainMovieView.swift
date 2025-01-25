//
//  MainMovieView.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

final class MainMovieView: UIView {
    private let titleLabel = UILabel()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout())
    
    var movieData: [SearchResult] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Configure UI
extension MainMovieView {
    
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
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
    }
    
    private func configureView() {
        titleLabel.text = "오늘의 영화"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        setCollectionView()
        configureHierarchy()
    }
    
}

//MARK: - CollectionView
extension MainMovieView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(MoviePosterCell.self, forCellWithReuseIdentifier: MoviePosterCell.id)
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let width = ((UIScreen.main.bounds.width) / 2)
        layout.itemSize = CGSize(width: width, height: ((UIScreen.main.bounds.height / 2) - 100))
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.id, for: indexPath) as? MoviePosterCell else { return UICollectionViewCell() }
        cell.configure(movieData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SearchDetailViewController()
        vc.searchData = movieData[indexPath.item]
        //TODO: - 수정
        MainViewController().navigationController?.pushViewController(vc, animated: true)
    }
    
}
