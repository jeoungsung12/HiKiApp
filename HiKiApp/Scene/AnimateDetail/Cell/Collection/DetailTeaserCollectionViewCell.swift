//
//  DetailTeaserCollectionViewCell.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/12/25.
//
import UIKit
import Kingfisher
import SnapKit
import YouTubePlayerKit
import RxSwift
import RxCocoa

final class DetailTeaserCollectionViewCell: BaseCollectionViewCell, ReusableIdentifier {
    private var player: YouTubePlayer?
    private var playerHostingView: YouTubePlayerHostingView
    private var videoURL: String?
    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        let initialPlayer = YouTubePlayer(urlString: "")
        self.playerHostingView = YouTubePlayerHostingView(player: initialPlayer)
        super.init(frame: frame)
        
        self.contentView.isUserInteractionEnabled = true
    }

    override func configureView() {
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 15
        self.contentView.backgroundColor = .black
        
    }

    override func configureHierarchy() {
        playerHostingView.clipsToBounds = true
        playerHostingView.layer.cornerRadius = 15
        self.contentView.addSubview(playerHostingView)
    }

    override func configureLayout() {
        playerHostingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(_ video: String?) {
        guard var url = video else { return }
        url += "&cc_load_policy=1"
        videoURL = url
        player = YouTubePlayer(urlString: url)
        playerHostingView.removeFromSuperview()
        playerHostingView = YouTubePlayerHostingView(player: player!)
        playerHostingView.isUserInteractionEnabled = true
        
        print(url)
        Task {
            try await playerHostingView.player.play()
        }
        configureHierarchy()
    }
}
