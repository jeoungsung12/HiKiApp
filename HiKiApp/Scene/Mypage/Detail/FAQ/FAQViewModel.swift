//
//  FAQViewModel.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/23/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwift
import RxCocoa

struct FAQItem {
    let question: String
    let answer: String
}

final class FAQViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    private let faqData: [FAQItem] = [
        FAQItem(question: "What is HiKi? 🧐", answer: "HiKi is an app where you can explore and manage your favorite animations, watch trailers, read reviews, and write your own reviews! You can also save your favorite animations and manage them easily."),
        FAQItem(question: "How do I search for animations? 🔍", answer: "Simply use the search bar at the top of the screen to search for any animation by title, genre, or characters."),
        FAQItem(question: "Can I save my favorite animations? ❤️", answer: "Yes! You can tap the heart icon to like and save any animation. It will appear in your 'My Favorites' section."),
        FAQItem(question: "How do I write a review? ✍️", answer: "Go to the animation page and tap the 'Write Review' button. You can then share your thoughts and rate the animation."),
        FAQItem(question: "Is my data private? 🔒", answer: "Absolutely! Your reviews and personal preferences are only visible to you, unless you choose to share them with others."),
        FAQItem(question: "Can I get recommendations? 🤖", answer: "Yes! HiKi offers personalized recommendations based on your preferences and ratings."),
        FAQItem(question: "How can I contact support? 📞", answer: "You can contact our support team by going to Settings > Support. We are happy to assist you with any issues."),
        FAQItem(question: "Is HiKi free? 💸", answer: "Yes, HiKi is completely free to use, with an option for premium features in the future.")
    ]
    
    struct Input {}
    
    struct Output {
        let data: Driver<[FAQItem]>
    }
}

extension FAQViewModel {
    
    func transform(_ input: Input) -> Output {
        let faqDriver = Driver.just(faqData)
        return Output(data: faqDriver)
    }
}
