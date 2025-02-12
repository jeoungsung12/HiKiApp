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
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
    private let loadingIndicator = UIActivityIndicatorView()
    private let recentView = SearchRecentView()
    private let tableView = UITableView()
    private let resultLabel = UILabel()
    private let searchBar = UISearchBar()
    
    private let viewModel = SearchViewModel()
    private let inputTirgger = SearchViewModel.Input(
        phaseTrigger: Observable(.notRequest),
        searchTrigger: Observable((1))
    )
    private lazy var outputResult = viewModel.transform(input: inputTirgger)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    private func setBinding() {
        outputResult.searchPage.lazyBind { [weak self] page in
            if let text = self?.searchBar.text {
                self?.viewModel.setSearchText(text)
                self?.inputTirgger.searchTrigger.value = page
            }
        }
        
        outputResult.phaseResult.lazyBind { [weak self] phase in
            self?.resultLabel.text = phase.message
            self?.recentView.isHidden = (phase == .notRequest) ? false : true
        }
        
        outputResult.searchResult.lazyBind { [weak self] data in
            self?.tableView.reloadData()
            self?.loadingIndicator.stopAnimating()
        }
    }
    
}

extension SearchViewController {
    
    private func configureHierarchy() {
        [searchBar, tableView, recentView, resultLabel, loadingIndicator].forEach({
            self.view.addSubview($0)
        })
        self.view.addGestureRecognizer(tapGesture)
        configureLayout()
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        recentView.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        tableView.snp.makeConstraints { make in            make.top.equalTo(searchBar.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        resultLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.center.equalToSuperview()
        }
    }
    
    private func configureView() {
        self.setNavigation("애니검색")
        self.view.backgroundColor = .white
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.placeholder =  "애니를 검색해보세요."
        
        resultLabel.textColor = .black
        resultLabel.textAlignment = .center
        resultLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        //TODO: 최근검색어 - 전체 삭제 버튼 설정
//        recentView.configure(viewModel.)
        tapGesture.cancelsTouchesInView = false
        
        setTableView()
        configureHierarchy()
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        viewModel.setSearchText(text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let text = searchBar.text else { return }
        viewModel.initData(text, self.outputResult)
        loadingIndicator.startAnimating()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.prefetchDataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.showsVerticalScrollIndicator = true
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outputResult.searchResult.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id, for: indexPath) as? SearchTableViewCell,
              let text = searchBar.text else { return UITableViewCell() }
        cell.configure(text, outputResult.searchResult.value[indexPath.row])
        cell.isButton = { value in
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
        let movie = outputResult.searchResult.value[indexPath.row]
//        vc.searchData = outputResult.searchResult.value[indexPath.row]
        //TODO: - Delegate 패턴으로 바꿔보자!
        vc.isButton = {
            cell.configure(text, movie)
        }
        self.push(vc)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if let indexPath = indexPaths.last,
           outputResult.searchResult.value.count - 2 < indexPath.row {
            viewModel.checkPaging(inputTirgger, outputResult)
        }
    }
    
}
