//
//  SearchGenreItem.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/27/25.
//

import UIKit
import SnapKit

final class SearchGenreItem: UIStackView {
    private let genreLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ genre: String) {
        genreLabel.text = genre
    }
}

extension SearchGenreItem {
    
    private func configureHierarchy() {
        self.addArrangedSubview(genreLabel)
        configureLayout()
    }
    
    private func configureLayout() {
        
        genreLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.edges.equalToSuperview()
        }
        
    }
    
    private func configureView() {
        self.spacing = 4
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .fill
        
        genreLabel.textAlignment = .left
        genreLabel.textColor = .customWhite
        genreLabel.clipsToBounds = true
        genreLabel.layer.cornerRadius = 5
        genreLabel.backgroundColor = .darkGray
        genreLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        
        configureHierarchy()
    }
}
