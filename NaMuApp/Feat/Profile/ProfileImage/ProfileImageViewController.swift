//
//  ProfileImageViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

final class ProfileImageViewController: UIViewController {
    private let profileButton = CustomProfileButton()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
}

extension ProfileImageViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(profileButton)
        self.view.addSubview(collectionView)
        configureLayout()
    }
    
    private func configureLayout() {
        
        profileButton.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
        }
        
        collectionView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(profileButton.snp.bottom).offset(36)
        }
        
    }
    
    private func configureView() {
        self.view.backgroundColor = .black
        self.setNavigation("프로필 이미지 설정")
        profileButton.profileImage.setBorder(3, 60)
        profileButton.isUserInteractionEnabled = false
        
        setCollectionView()
        configureHierarchy()
    }
}

extension ProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.id)
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        //TODO: - 수정
        let layout = UICollectionViewFlowLayout()
        let spacing = 12
        let width = (Int(UIScreen.main.bounds.width) - (spacing * 5)) / 4
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileData.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.id, for: indexPath) as? ProfileImageCollectionViewCell else { return UICollectionViewCell() }
        
        let image = UIImage(named: ProfileData.allCases[indexPath.row].rawValue)
        cell.configure(image)
        
        cell.profileButton.containerView.isHidden = true
        cell.profileButton.profileImage.setBorder(3, 12 * 5 / 2)
        return cell
    }
    
}
