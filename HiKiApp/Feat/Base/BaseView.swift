//
//  BaseView.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/17/25.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {}
    func configureHierarchy() {}
    func configureLayout() {}
}
