//
//  ProfileViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let profileButton = UIButton()
    private let nameTextField = UITextField()
    private let spacingView = UIView()
    private let descriptionLabel = UILabel()
    private let successButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

}

extension ProfileViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(profileButton)
        self.view.addSubview(nameTextField)
        self.view.addSubview(spacingView)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(successButton)
        
        configureLayout()
    }
    
    private func configureLayout() {
        
    }
    
    private func configureView() {
        
        configureHierarchy()
    }
    
}
