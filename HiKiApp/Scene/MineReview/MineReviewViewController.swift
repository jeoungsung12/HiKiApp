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
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setBinding() {
        
    }
    
    override func configureView() {
        setNavigation("My Review")
    }
    
    override func configureHierarchy() {
        
    }
    
    override func configureLayout() {
        
    }
    
}
