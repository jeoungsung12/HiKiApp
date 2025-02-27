//
//  ErrorViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/28/25.
//

import UIKit
import SnapKit

class ErrorViewController: BaseViewController {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    init(_ errorDescription: String?) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = errorDescription
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        [titleLabel, descriptionLabel].forEach({
            self.view.addSubview($0)
        })
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-80)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
    }
    
    override func configureView() {
        self.view.backgroundColor = .white
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .lightGray
        descriptionLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        descriptionLabel.text = "We apologize for any inconvenience caused in using our service.\nPlease try again later.😢"
    }
}
