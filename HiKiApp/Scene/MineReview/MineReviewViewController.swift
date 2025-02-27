//
//  MineReviewViewController.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/21/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MineReviewViewController: BaseViewController {
    private let tableView = UITableView()
    private let viewModel = MineReviewViewModel()
    private let input = MineReviewViewModel.Input(
        loadTrigger: PublishRelay<Void>()
    )
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.loadTrigger.accept(())
    }
    
    override func setBinding() {
        let output = viewModel.transform(input)
        
        output.dataResult
            .drive(tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { row, element, cell in
                
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        setNavigation("My Review")
        self.view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func configureHierarchy() {
        
    }
    
    override func configureLayout() {
        
    }
    
}
