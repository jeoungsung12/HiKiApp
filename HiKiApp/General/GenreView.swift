//
//  GenreItem.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/26/25.
//

import UIKit
import SnapKit

final class GenreView: BaseView {
    private let genreStackView = UIStackView()
    private let genreScrollView = UIScrollView()
    private var genreType: GenreLocation = .search
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configure(_ type: GenreLocation) {
        genreType = type
        configureView()
//        configureStackView(model)
    }
    
    override func configureHierarchy() {
        genreScrollView.addSubview(genreStackView)
        self.addSubview(genreScrollView)
    }
    
    override func configureLayout() {
        switch genreType {
        case .detail:
            genreStackView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.trailing.lessThanOrEqualToSuperview().inset(4)
            }
        case .search:
            genreStackView.snp.makeConstraints { make in
                make.verticalEdges.equalToSuperview()
                make.horizontalEdges.equalToSuperview().inset(4)
            }
        }
        
        genreScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        genreStackView.spacing = 8
        genreStackView.axis = .horizontal
        genreStackView.alignment = .center
        genreStackView.distribution = .fill
        genreScrollView.showsHorizontalScrollIndicator = false
    }
    
}

extension GenreView {
    
    private func configureStackView() {
//        
//        genreStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
//        for (model) in models {
//            switch genreType {
//            case .search:
//                break
//            case .detail:
//                let genreItem = DetailGenreItem()
//                genreItem.configure(model.image, model.text)
//                genreStackView.addArrangedSubview(genreItem)
//            }
//        }
//        for genre in genreString {
//            switch genreType {
//            case .search:
//                let genreItem = SearchGenreItem()
//                genreItem.configure(" \(genre) ")
//                genreStackView.addArrangedSubview(genreItem)
//            case .detail:
//                break
//            }
//        }
    }
}
