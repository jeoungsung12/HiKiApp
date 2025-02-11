//
//  Observable.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/7/25.
//

import Foundation

final class Observable<T> {
    
    var closure: ((T)->Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(closure: @escaping (T) -> Void) {
        closure(value)
        self.closure = closure
    }
    
    func lazyBind(closure: @escaping (T) -> Void) {
        self.closure = closure
    }
}

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
