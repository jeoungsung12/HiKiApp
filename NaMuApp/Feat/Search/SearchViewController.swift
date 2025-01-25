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
    private let resultLabel = UILabel()
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
    private let loadingIndicator = UIActivityIndicatorView()

    private var searchData: [SearchResult] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
}

extension SearchViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        self.view.addSubview(resultLabel)
        self.view.addSubview(loadingIndicator)
        self.view.addGestureRecognizer(tapGesture)
        configureLayout()
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(24)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.center.equalToSuperview().offset(20)
        }
        
    }
    
    private func configureView() {
        self.setNavigation("영화검색")
        self.view.backgroundColor = .black
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .lightGray
        searchBar.searchTextField.text = "영화를 검색해보세요."
        
        resultLabel.textColor = .lightGray
        resultLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        
        setTableView()
        configureHierarchy()
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    //TODO: 간소화
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        guard let text = searchBar.text else { return true }
        searchBar.searchTextField.textColor = .white
        searchBar.text = ((text == "영화를 검색해보세요.")) ? "" : text
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        guard let text = searchBar.text else { return true }
        searchBar.text = ((text.isEmpty)) ? "영화를 검색해보세요." : text
        searchBar.searchTextField.textColor = ((text.isEmpty)) ? .lightGray : .white
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let text = searchBar.text else { return }
        searchBar.text = ((text.isEmpty)) ? "영화를 검색해보세요." : text
        searchBar.searchTextField.textColor = ((text.isEmpty)) ? .lightGray : .white
        fetchData()
    }
    
}

extension SearchViewController {
    
    private func fetchData() {
        guard let text = searchBar.text else { return }
        loadingIndicator.startAnimating()
        SearchServices().getSearch(SearchResponse(searchPage: 1, searchText: text)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case let .success(data):
                self.searchData = data
                self.loadingIndicator.stopAnimating()
            case let .failure(error):
                print(error)
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.prefetchDataSource = self
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        cell.configure(searchData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
    }
}
