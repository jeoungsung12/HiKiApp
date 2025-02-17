//
//  ReviewViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/9/25.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

final class ReviewViewController: UIViewController {
    private let tableView = UITableView()
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulseSync, color: .point)
    private let viewModel = ReviewViewModel()
    private let inputTrigger = ReviewViewModel.Input(reviewTrigger: CustomObservable((1)))
    private lazy var outputResult = viewModel.transform(input: inputTrigger)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setBinding()
    }
    
    private func setBinding() {
        //TODO: Toast - Phase
        
        outputResult.reviewPage.lazyBind { [weak self] page in
            self?.inputTrigger.reviewTrigger.value = page
        }
        
        outputResult.reviewResult.lazyBind { [weak self] data in
            self?.tableView.reloadData()
            self?.loadingIndicator.stopAnimating()
        }
    }

}

extension ReviewViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(tableView)
        [tableView, loadingIndicator].forEach({ self.view.addSubview($0) })
        configureLayout()
    }
    
    private func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        loadingIndicator.startAnimating()
    }
    
    private func configureView() {
        self.setNavigation("리뷰 모아보기")
        self.view.backgroundColor = .white
        
        configureTableView()
        configureHierarchy()
    }
}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: ReviewTableViewCell.id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outputResult.reviewResult.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.id, for: indexPath) as? ReviewTableViewCell else { return UITableViewCell() }
        cell.configure(outputResult.reviewResult.value[indexPath.row])
        cell.selectionStyle = .none
        cell.reloadCell = {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if let indexPath = indexPaths.last,
           outputResult.reviewResult.value.count - 2 < indexPath.row {
            viewModel.checkPaging(inputTrigger, outputResult)
        }
    }
    
}
