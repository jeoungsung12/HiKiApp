//
//  SearchViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    private let tableView = UITableView()
    private let resultLabel = UILabel()
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
    private let loadingIndicator = UIActivityIndicatorView()
    private let db = Database.shared
    var searchBar = UISearchBar()
    var searchData: SearchResponse = SearchResponse(searchPage: 1, searchText: "", searchPhase: .notRequest, searchResult: []) {
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
            make.top.equalTo(searchBar.snp.bottom).offset(12)
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
        if (searchData.searchText == "") {
            searchBar.searchTextField.text =  "영화를 검색해보세요."
        }
        
        resultLabel.textColor = .lightGray
        resultLabel.textAlignment = .center
        resultLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        tapGesture.cancelsTouchesInView = false
        
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
        //TODO: - 변경
        var recentSearch = db.recentSearch
        //TODO: - 검색내역 중복처리
        recentSearch.removeAll { $0 == text }
        recentSearch.append(text)
        db.recentSearch = recentSearch
        
        searchData.searchPage = 1
        searchData.searchResult = []
        searchData.searchPhase = .notFound
        fetchData()
    }
    
}

extension SearchViewController {
    
    func fetchData() {
        //TODO: - 공백 체크!
        guard let text = searchBar.text else { return }
        searchData.searchText = text
        loadingIndicator.startAnimating()
        SearchServices().getSearch(searchData) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case let .success(data):
                self.checkPhase(data)
                self.searchData.searchResult += data
                self.loadingIndicator.stopAnimating()
            case let .failure(error):
                self.searchData.searchPhase = .notFound
                self.resultLabel.text = self.searchData.searchPhase.message
                print(error)
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    private func checkPhase(_ data: [SearchResult]) {
        if (data.isEmpty) && (searchData.searchPage == 1) {
            searchData.searchPhase = .notFound
            resultLabel.text = searchData.searchPhase.message
        } else if (data.isEmpty) {
            searchData.searchPhase = .endPage
        } else {
            searchData.searchPhase = .success
            resultLabel.text = searchData.searchPhase.message
        }
    }
    
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.prefetchDataSource = self
        tableView.showsVerticalScrollIndicator = true
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id, for: indexPath) as? SearchTableViewCell,
              let text = searchBar.text else { return UITableViewCell() }
        cell.configure(text, searchData.searchResult[indexPath.row])
        cell.isButton = {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchTableViewCell,  let text = searchBar.text else { return }
        let vc = SearchDetailViewController()
        let movie = searchData.searchResult[indexPath.row]
        vc.searchData = movie
        vc.isButton = {
            cell.configure(text, movie)
        }
        self.push(vc)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if let indexPath = indexPaths.last,
           searchData.searchResult.count - 2 < indexPath.row {
            switch searchData.searchPhase {
            case .success:
                searchData.searchPage += 1
                fetchData()
            case .notRequest:
                return
            case .notFound:
                return
            case .endPage:
                self.customAlert("", searchData.searchPhase.message, [.ok]) {}
                self.searchData.searchPhase = .notRequest
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        //TODO: - Cancel
    }
}
