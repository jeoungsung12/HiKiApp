//
//  BaseViewModel.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/17/25.
//

import Foundation
protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
