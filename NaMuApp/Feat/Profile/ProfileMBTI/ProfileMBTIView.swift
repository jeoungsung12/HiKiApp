//
//  ProfileMBTIView.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/7/25.
//

import UIKit
import SnapKit

final class ProfileMBTIView: UIView {
    private let titleLabel = UILabel()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createCollectionViewLayout())
    
    let viewModel = ProfileMBTIViewModel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(#function, self)
    }
}

extension ProfileMBTIView {
    
    private func configureHierarchy() {
        [titleLabel, collectionView].forEach({
            self.addSubview($0)
        })
        configureLayout()
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(24)
        }
        
        collectionView.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.height.equalTo(110)
            make.trailing.top.equalToSuperview().inset(24)
        }
    }
    
    private func configureView() {
        titleLabel.text = "MBTI"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
        configureCollectionView()
        configureHierarchy()
    }
    
}

//MARK: - CollectionView
extension ProfileMBTIView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.register(ProfileMBTICell.self, forCellWithReuseIdentifier: ProfileMBTICell.id)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.itemSize = CGSize(width: 50, height: 110)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.mbti.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileMBTICell.id, for: indexPath) as? ProfileMBTICell else { return UICollectionViewCell() }
        cell.configure(viewModel.mbti[indexPath.row])
        cell.tapped = { [weak self] in
            self?.viewModel.tapped?()
        }
        return cell
    }
}

