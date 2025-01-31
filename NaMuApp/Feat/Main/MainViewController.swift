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
    private var profileView = MyProfileView()
    private let recentSearchView = MainRecentView()
    private let loadingIndicator = UIActivityIndicatorView()
    private let titleLabel = UILabel()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout())
    private var db = Database.shared
    
    var movieData: [SearchResult] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProfileAndRecentSearch()
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
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
        }
        
        recentSearchView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(profileView.snp.bottom).offset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
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
        recentTapped()
    }
    
    private func configureView() {
        self.setNavigation("NaMu")
        self.view.backgroundColor = .customBlack
        self.navigationItem.rightBarButtonItem = searchButton
        
        loadingIndicator.style = .medium
        loadingIndicator.color = .customLightGray
        
        titleLabel.text = "오늘의 영화"
        titleLabel.textAlignment = .left
        titleLabel.textColor = .customWhite
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
        profileTapped()
        configureCollectionView()
        configureHierarchy()
    }
}

//MARK: - Action
extension MainViewController {
    
    @objc
    private func searchButtonTapped(_ sender: UIBarButtonItem) {
        print(#function)
        let vc = SearchViewController()
        self.push(vc)
    }
    
    private func profileTapped() {
        print(#function)
        profileView.profileTapped = { [weak self] in
            let vc = SheetProfileViewController()
            vc.dismissClosure = { [weak self] in
                guard let self = self else { return }
                self.profileView.configure(self.db.getUser())
            }
            self?.sheet(vc)
        }
    }
    
    private func recentTapped() {
        recentSearchView.removeAll = { [weak self] in
            guard let self = self else { return }
            self.db.removeAll("recentSearch")
            self.recentSearchView.configure(self.db.recentSearch.reversed())
        }
        recentSearchView.removeTapped = { [weak self] recent in
            guard let self = self else { return }
            self.db.removeRecentSearch(recent)
            self.recentSearchView.configure(self.db.recentSearch.reversed())
        }
        recentSearchView.recentTapped = { [weak self] recent in
            guard let self = self else { return }
            let vc = SearchViewController()
            vc.searchBar.searchTextField.text = recent
            vc.searchData.searchText = recent
            vc.fetchData()
            self.push(vc)
        }
    }
    
    private func updateProfileAndRecentSearch() {
        profileView.configure(db.getUser())
        recentSearchView.configure(db.recentSearch.reversed())
    }
    
    private func fetchData() {
        loadingIndicator.startAnimating()
        TrendingServices().getTrending { [weak self] response in
            guard let self = self else { return }
            switch response {
            case let .success(data):
                self.movieData = data
                self.loadingIndicator.stopAnimating()
            case let .failure(error):
                self.errorPresent(error)
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
        layout.itemSize = CGSize(width: width, height: ((UIScreen.main.bounds.height / 2)))
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.id, for: indexPath) as? MoviePosterCell else { return UICollectionViewCell() }
        cell.configure(movieData[indexPath.row])
        cell.isButton = { [weak self] value in
            guard let self = self else { return }
            self.customAlert((value) ? "보관 성공!" : "삭제 성공!") { }
            self.profileView.configure(self.db.getUser())
            collectionView.reloadItems(at: [indexPath])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MoviePosterCell else { return }
        let vc = SearchDetailViewController()
        let movie = movieData[indexPath.row]
        vc.searchData = movie
        vc.isButton = {
            cell.configure(movie)
        }
        self.push(vc)
    }
    
}
