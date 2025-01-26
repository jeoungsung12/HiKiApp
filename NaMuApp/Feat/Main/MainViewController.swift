//
//  MainViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private lazy var searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
    private let profileView = MyProfileView()
    //TODO: - 최근 검색어 기능구현
    private let recentSearchView = MainRecentView()
    private let loadingIndicator = UIActivityIndicatorView()
    
    private let titleLabel = UILabel()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout())
    
    var movieData: [SearchResult] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
}

//MARK: - Configure UI
extension MainViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(profileView)
        self.view.addSubview(recentSearchView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(collectionView)
        self.view.addSubview(loadingIndicator)
        configureLayout()
    }
    
    private func configureLayout() {
        
        profileView.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(6)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
        }
        
        recentSearchView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(profileView.snp.bottom).offset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(recentSearchView.snp.bottom).offset(12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.center.equalToSuperview()
        }
        fetchData()
    }
    
    private func configureView() {
        self.setNavigation("NaMu")
        self.view.backgroundColor = .black
        self.navigationItem.rightBarButtonItem = searchButton
        
        loadingIndicator.style = .medium
        loadingIndicator.color = .customLightGray
        
        titleLabel.text = "오늘의 영화"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        configureCollectionView()
        configureHierarchy()
    }
}

extension MainViewController {
    
    @objc
    private func searchButtonTapped(_ sender: UIBarButtonItem) {
        print(#function)
        let vc = SearchViewController()
        self.push(vc)
    }
    
}

extension MainViewController {
    
    private func fetchData() {
        loadingIndicator.startAnimating()
        TrendingServices().getTrending { [weak self] response in
            guard let self = self else { return }
            switch response {
            case let .success(data):
                self.movieData = data
                self.loadingIndicator.stopAnimating()
            case let .failure(error):
                print(error)
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
}

//MARK: - CollectionView
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func configureCollectionView() {
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
        vc.searchData = movieData[indexPath.row]
        self.push(vc)
    }
    
}
