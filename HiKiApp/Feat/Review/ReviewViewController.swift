//
//  ReviewViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/9/25.
//

import UIKit

final class ReviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

}

extension ReviewViewController {
    
    private func configureHierarchy() {
        
        configureLayout()
    }
    
    private func configureLayout() {
        
    }
    
    private func configureView() {
        self.setNavigation()
        self.view.backgroundColor = .white
        
        configureHierarchy()
    }
}
