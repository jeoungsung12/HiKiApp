//
//  BaseViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/8/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    func configureView() {}
    func configureHierarchy() {}
    func configureLayout() {}
}
