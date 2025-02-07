//
//  HomeItem.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/6/25.
//

import Foundation

enum HomeItem: Hashable {
    case poster(ItemModel)
    case list
    case recommand
    case age
}

struct ItemModel: Hashable {
    let id: Int
    var image: String
}
