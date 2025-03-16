//
//  ReviewRepository.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/24/25.
//

import UIKit
import RxSwift
import RxCocoa

protocol ReviewRepositoryType {
    func getAnswer(_ reviewData: UserReview) -> Observable<ChatResponseDTO>
}

final class ReviewRepository: ReviewRepositoryType {
    private let networkManager: NetworkManagerType = NetworkManager.shared
    
    func getAnswer(_ reviewData: UserReview) -> Observable<ChatResponseDTO> {
        return networkManager.getData(ReviewRouter.ai(review: reviewData))
    }
}
