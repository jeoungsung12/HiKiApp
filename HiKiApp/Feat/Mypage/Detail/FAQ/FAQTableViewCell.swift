//
//  FAQTableViewCell.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/23/25.
//

import UIKit
import SnapKit

final class FAQTableViewCell: BaseTableViewCell, ReusableIdentifier {
    private let questionLabel = UILabel()
    private let answerLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func configureView() {
        questionLabel.font = .boldSystemFont(ofSize: 18)
        questionLabel.numberOfLines = 0
        questionLabel.textColor = .point
        
        answerLabel.font = .systemFont(ofSize: 16)
        answerLabel.numberOfLines = 0
        answerLabel.textColor = .darkGray
        answerLabel.backgroundColor = .systemGray5
        answerLabel.layer.cornerRadius = 8
        answerLabel.layer.masksToBounds = true
    }
    
    override func configureLayout() {
        let stackView = UIStackView(arrangedSubviews: [questionLabel, answerLabel])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .leading
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView.snp.edges).inset(12)
        }
    }
    
    func configure(question: String, answer: String) {
        questionLabel.text = question
        answerLabel.text = answer
    }
}
