//
//  MainCategoryView.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/6/25.
//

import UIKit
import SnapKit

class MainCategoryView: UIView {
    private let categories = AnimateType.allCases
    private var selectedCategory: AnimateType = .airing {
        didSet {
            updateSelection()
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.axis = .horizontal
        stackView.alignment = .leading
        return stackView
    }()
    
    private var categoryButtons: [UIButton] = []
    var selectedItem: ((AnimateType)->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(36)
        }
        
        createCategoryButtons()
    }
    
    private func createCategoryButtons() {
        categories.forEach { category in
            let button = UIButton()
            button.backgroundColor = .white
            button.setTitleColor(.point, for: .selected)
            button.setTitleColor(.lightGray, for: .normal)
            button.setTitle(category.title, for: .normal)
            button.titleLabel?.font = .boldSystemFont(ofSize: 15)
            button.tag = categories.firstIndex(of: category) ?? 0
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
            button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
            
            categoryButtons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        updateSelection()
    }
    
    @objc private func categoryTapped(_ sender: UIButton) {
        let index = sender.tag
        selectedCategory = categories[index]
        selectedItem?(selectedCategory)
    }
    
    private func updateSelection() {
        for (index, button) in categoryButtons.enumerated() {
            let isSelected = categories[index] == selectedCategory
            button.isSelected = isSelected
        }
    }
}

