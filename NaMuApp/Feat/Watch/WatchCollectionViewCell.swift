//
//  WatchCollectionViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/9/25.
//

import UIKit

final class WatchCollectionViewCell: UICollectionViewCell {
    static let id: String = "WatchCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
    }
    
}

extension WatchCollectionViewCell {
    private func configureHierarchy() {
        
        configureLayout()
    }
    
    private func configureLayout() {
        
    }
    
    private func configureView() {
        
        configureHierarchy()
    }
    
}
