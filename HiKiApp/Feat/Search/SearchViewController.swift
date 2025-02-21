//
//  SearchViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import Kingfisher
import SnapKit
import NVActivityIndicatorView
import RxSwift
import RxCocoa

class SearchViewController: BaseViewController {
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulseSync, color: .point)
    private let recentView = SearchRecentView()
    private let tableView = UITableView()
    private let resultLabel = UILabel()
    private let searchBar = UISearchBar()
    
    private let viewModel = SearchViewModel()
    private let inputTirgger = SearchViewModel.Input(searchTrigger: PublishSubject<Int>())
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()

    }
    
    override func setBindView() {
        searchBar.rx.text.orEmpty
            .bind(with: self) { owner, text in
                owner.viewModel.setSearchText(text)
            }
            .disposed(by: disposeBag)
    }
    
    override func setBinding() {
        let outputResult = viewModel.transform(inputTirgger)
        outputResult.searchPage
            .bind(with: self, onNext: { owner, page in
                if let text = owner.searchBar.text {
                    owner.viewModel.setSearchText(text)
                    owner.inputTirgger.searchTrigger.onNext(page)
                }
            })
            .disposed(by: disposeBag)
        
        outputResult.phaseResult
            .bind(with: self, onNext: { owner, phase in
                owner.resultLabel.text = phase.message
            })
            .disposed(by: disposeBag)
        
        outputResult.searchResult
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.id, cellType: SearchTableViewCell.self)) { row, element, cell in
                self.loadingIndicator.stopAnimating()
                guard let text = self.searchBar.text else { return }
                cell.configure(text, element)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.prefetchRows
            .bind(with: self) { owner, indexPath in
                let lastIndex = indexPath.map { $0.row }.max() ?? 1
                if outputResult.searchResult.value.count - 2 < lastIndex {
                    owner.viewModel.checkPaging(owner.inputTirgger, outputResult)
                }
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .bind(with: self) { owner, text in
                owner.viewModel.setSearchText(text)
            }.disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .bind(with: self) { owner, text in
                owner.viewModel.initData(outputResult)
                owner.loadingIndicator.startAnimating()
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(AnimateDataEntity.self))
            .bind(with: self) { owner, value in
                let vc = SearchDetailViewController(viewModel: SearchDetailViewModel(id: value.1.id))
                owner.push(vc)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        [searchBar, tableView, recentView, resultLabel, loadingIndicator].forEach({
            self.view.addSubview($0)
        })
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        recentView.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        tableView.snp.makeConstraints { make in            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(recentView.snp.bottom).offset(8)
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
    
    override func configureView() {
        self.setNavigation("애니검색")
        self.view.backgroundColor = .white
        
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.placeholder =  "애니를 검색해보세요."
        
        resultLabel.textColor = .black
        resultLabel.textAlignment = .center
        resultLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        recentView.configure(viewModel.db.recentSearch)
        tapGesture.cancelsTouchesInView = false
        
        setTableView()
    }
    
    private func setTableView() {
        tableView.rowHeight = 150
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.showsVerticalScrollIndicator = true
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
    }
    
    deinit {
        print(#function, self)
    }
}
