//
//  SearchViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    private let searchBar = UISearchBar()
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
}

extension SearchViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        configureLayout()
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
    }
    
    private func configureView() {
        self.setNavigation("영화검색")
        self.view.backgroundColor = .black
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        
        setTableView()
        configureHierarchy()
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
    }
}
