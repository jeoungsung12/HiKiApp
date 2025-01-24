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
    private let profileView = MainProfileView()
    private let recentSearchView = MainRecentView()
    private let movieView = MainMovieView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
}

extension MainViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(profileView)
        self.view.addSubview(recentSearchView)
        self.view.addSubview(movieView)
        configureLayout()
    }
    
    private func configureLayout() {
        
        profileView.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(6)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
        }
        
        recentSearchView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().dividedBy(6)
            make.top.equalTo(profileView.snp.bottom).offset(12)
        }
        
        movieView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
            make.top.equalTo(recentSearchView.snp.bottom).offset(12)
        }
        
    }
    
    private func configureView() {
        self.setNavigation("NaMu")
        self.view.backgroundColor = .black
        self.navigationItem.rightBarButtonItem = searchButton
        
        
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
    
    
}
