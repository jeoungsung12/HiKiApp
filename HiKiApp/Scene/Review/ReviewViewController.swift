//
//  ReviewViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/9/25.
//

import UIKit
import SnapKit
import NVActivityIndicatorView
import RxSwift
import RxCocoa

final class ReviewViewController: BaseViewController {
    private let tableView = UITableView()
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulseSync, color: .point)
    
    private let viewModel = ReviewViewModel()
    private let inputTrigger = ReviewViewModel.Input(reviewTrigger: PublishSubject())
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setBinding() {
        let outputResult = viewModel.transform(inputTrigger)
        outputResult.reviewPage
            .bind(with: self, onNext: { owner, page in
                owner.inputTrigger.reviewTrigger.onNext(page)
            })
            .disposed(by: disposeBag)

        outputResult.reviewResult
            .bind(to: tableView.rx.items(cellIdentifier: ReviewTableViewCell.id, cellType: ReviewTableViewCell.self)) { [weak self] row, element, cell in
                cell.configure(element)
                cell.heightDeleate = self
                self?.loadingIndicator.stopAnimating()
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(AnimateReviewEntity.self))
            .map { $0.1 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, value in
                let vm = AnimateDetailViewModel(id: value.animeId)
                let vc = AnimateDetailViewController(viewModel: vm)
                owner.push(vc)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.prefetchRows
            .subscribe(with: self) { owner, indexPaths in
                let lastIndex = indexPaths.map { $0.row }.max() ?? 1
                if outputResult.reviewResult.value.count - 2 < lastIndex {
                    owner.loadingIndicator.startAnimating()
                    owner.viewModel.checkPaging(owner.inputTrigger, outputResult)
                }
            } onError: { owner, error in
                //TODO: Error
                owner.loadingIndicator.stopAnimating()
            }
            .disposed(by: disposeBag)
    }

    override func configureHierarchy() {
        self.view.addSubview(tableView)
        [tableView, loadingIndicator].forEach({ self.view.addSubview($0) })
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        loadingIndicator.startAnimating()
    }
    
    override func configureView() {
        self.setNavigation("Everyone's review")
        self.view.backgroundColor = .white
        tableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: ReviewTableViewCell.id)
    }

}

extension ReviewViewController: ReviewHeightDelegate {
    
    func reloadCellHeight() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
