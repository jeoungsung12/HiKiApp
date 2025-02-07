//
//  HomeSection.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/6/25.
//

import Foundation

enum HomeSection: Hashable {
    case header
    case semiHeader(title: String)
    case middle(title: String)
    case semiFooter(title: String)
    case footer(title: String)
}
