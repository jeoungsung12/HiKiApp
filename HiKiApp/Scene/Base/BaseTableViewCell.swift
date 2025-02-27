//
//  BaseTableViewCell.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/18/25.
//

import UIKit

protocol ReusableIdentifier { }

extension ReusableIdentifier {
    static var id: String {
        String(describing: self)
    }
}

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() { }
    func configureHierarchy() { }
    func configureLayout() { }
}
