//
//  WatchCollectionViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/9/25.
//

import UIKit
import SnapKit
import YouTubePlayerKit

final class WatchCollectionViewCell: UICollectionViewCell {
    static let id: String = "WatchCollectionViewCell"

    private var player: YouTubePlayer?
    private var playerHostingView: YouTubePlayerHostingView
    private let loadingIndicator = LoadingView()

    private var isPreparedToPlay = false
    private var videoURL: String?

    override init(frame: CGRect) {
        let initialPlayer = YouTubePlayer(urlString: "")
        self.playerHostingView = YouTubePlayerHostingView(player: initialPlayer)
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ video: WatchVideo) {
        guard var url = video.url else { return }
        url += "&cc_load_policy=1"
        videoURL = url
        player = YouTubePlayer(urlString: url)
        playerHostingView.removeFromSuperview()
        playerHostingView = YouTubePlayerHostingView(player: player!)
        playerHostingView.isUserInteractionEnabled = false
        configureHierarchy()

        loadingIndicator.isStart()
        isPreparedToPlay = false
    }

    func playVideoIfNeeded() {
        guard let player = player, !isPreparedToPlay else { return }
        
        Task {
            do {
                try await player.play()
                DispatchQueue.main.async {
                    self.isPreparedToPlay = true
                    self.loadingIndicator.isStop()
                }
            } catch {
                print("Failed to play video: \(error)")
            }
        }
    }

    func stopVideo() {
        guard let player = player else { return }
        
        Task {
            try await player.stop()
            DispatchQueue.main.async {
                self.isPreparedToPlay = false
                self.loadingIndicator.isStop()
            }
        }
    }
}

extension WatchCollectionViewCell {
    private func configureView() {
        contentView.backgroundColor = .black
        
        configureHierarchy()
    }

    private func configureHierarchy() {
        [playerHostingView, loadingIndicator].forEach {
            contentView.addSubview($0)
        }
        configureLayout()
    }

    private func configureLayout() {
        playerHostingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadingIndicator.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.center.equalToSuperview()
        }
    }
}
