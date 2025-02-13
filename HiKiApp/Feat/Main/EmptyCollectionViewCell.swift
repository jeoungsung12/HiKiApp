//
//  EmptyCollectionViewCell.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/13/25.
//

import UIKit
import SnapKit

class EmptyCollectionViewCell: UICollectionViewCell {
    static let id: String = "EmptyCollectionViewCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        let view = UIView()
        view.backgroundColor = .white
        self.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
