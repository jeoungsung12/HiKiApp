//
//  SearchViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import Kingfisher
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showKeyboard()
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
        self.view.backgroundColor = .customBlack
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .customDarkGray
        if (searchData.searchText == "") {
            searchBar.searchTextField.text =  "영화를 검색해보세요."
        }
        
        resultLabel.textColor = .customDarkGray
        resultLabel.textAlignment = .center
        resultLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        tapGesture.cancelsTouchesInView = false
        
        setTableView()
        configureHierarchy()
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        guard let text = searchBar.text else { return true }
        searchBar.searchTextField.textColor = .customWhite
        searchBar.text = ((text == "영화를 검색해보세요.")) ? "" : text
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        guard let text = searchBar.text else { return true }
        searchBar.text = ((text.isEmpty)) ? "영화를 검색해보세요." : text
        searchBar.searchTextField.textColor = ((text.isEmpty)) ? .customDarkGray : .customWhite
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let text = searchBar.text else { return }
        searchBar.text = ((text.isEmpty)) ? "영화를 검색해보세요." : text
        searchBar.searchTextField.textColor = ((text.isEmpty)) ? .customDarkGray : .customWhite
        db.removeRecentSearch(text)
        db.recentSearch.append(text)
        
        initData(text)
        fetchData()
    }
    
    private func showKeyboard() {
        if let text = searchBar.text, text == "영화를 검색해보세요." {
            searchBar.becomeFirstResponder()
        }
    }
    
    private func initData(_ text: String) {
        searchData = SearchResponse(searchPage: 1, searchText: text, searchPhase: .notFound, searchResult: [])
    }
}

extension SearchViewController {
    
    func fetchData() {
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
                self.loadingIndicator.stopAnimating()
                print(error)
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
        tableView.prefetchDataSource = self
        tableView.backgroundColor = .customBlack
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
    
}
