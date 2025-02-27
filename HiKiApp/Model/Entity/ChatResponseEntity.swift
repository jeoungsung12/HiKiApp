//
//  ChatResponseEntity.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/24/25.
//

import Foundation

struct ChatResponseEntity {
    let content: String
}

extension ChatResponseDTO {
    func toEntity() -> ChatResponseEntity {
        return ChatResponseEntity(content: self.choices.first?.message.content ?? "")
    }
}
