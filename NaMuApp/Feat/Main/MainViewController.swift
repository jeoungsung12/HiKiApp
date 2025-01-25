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
    private let movieView = MainMovieView()
    private let loadingIndicator = UIActivityIndicatorView()
    
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
        self.view.addSubview(movieView)
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
        
        movieView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 2)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
            make.top.equalTo(recentSearchView.snp.bottom).offset(12)
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
                self.movieView.movieData = data
                self.loadingIndicator.stopAnimating()
            case let .failure(error):
                print(error)
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
}
