//
//  ReviewServices.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/24/25.
//

import Foundation
import Alamofire
import RxSwift

final class ReviewServices {
    private let repository: ReviewRepository
    
    init(repository: ReviewRepository = ReviewRepository()) {
        self.repository = repository
    }
    
    func getReview(_ reviewData: UserReview) -> Observable<ChatResponseDTO> {
        return repository.getAnswer(reviewData)
    }
}
