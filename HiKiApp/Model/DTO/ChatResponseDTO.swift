//
//  ChatServiceModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/04/08.
//

import Foundation

struct ChatResponseDTO: Decodable {
    let choices: [ChatChoiceDTO]
    
    struct ChatChoiceDTO: Decodable {
        let message: ChatMessageDTO
    }
    struct ChatMessageDTO: Decodable {
        let content: String
    }
}
