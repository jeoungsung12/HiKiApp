//
//  WatchViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/9/25.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

final class TeaserViewController: UIViewController {
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulseSync, color: .point)
    
    private let viewModel = TeaserViewModel()
    private let inputTrigger = TeaserViewModel.Input(dataTrigger: CustomObservable(1))
    private lazy var outputResult = viewModel.transform(input: inputTrigger)
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.backgroundColor = .black
        
//        self.inputTrigger.dataTrigger.value = Int.random(in: 1...3)
    }
    
    private func setBinding() {
        outputResult.dataResult.bind { [weak self] data in
            DispatchQueue.main.async {
                if data != nil {
                    self?.collectionView.reloadData()
                } else {
//                    self?.inputTrigger.dataTrigger.value += 1
                }
                self?.loadingIndicator.stopAnimating()
            }
        }
    }
}

extension TeaserViewController {
    
    private func configureHierarchy() {
        [collectionView, loadingIndicator].forEach({
            self.view.addSubview($0)
        })
        configureLayout()
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.center.equalToSuperview()
        }
        loadingIndicator.startAnimating()
    }
    
    private func configureView() {
        self.view.backgroundColor = .black
       
        configureCollectionView()
        configureHierarchy()
    }
}

extension TeaserViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .black
        collectionView.prefetchDataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TeaserCollectionViewCell.self, forCellWithReuseIdentifier: TeaserCollectionViewCell.id)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = outputResult.dataResult.value {
            return data.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeaserCollectionViewCell.id, for: indexPath) as? TeaserCollectionViewCell else { return UICollectionViewCell() }
        if let data = outputResult.dataResult.value {
            let videoData = data.filter({ ($0.trailer.embed_url != nil) })
            cell.configure(videoData[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? TeaserCollectionViewCell)?.playVideoIfNeeded()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? TeaserCollectionViewCell)?.stopVideo()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        //TODO: - 페이징 처리
        if let data = outputResult.dataResult.value, let last = indexPaths.last, last.row <= data.count - 2 {
            print(#function, indexPaths)
//            inputTrigger.dataTrigger.value += 1
        }
    }
    
}
