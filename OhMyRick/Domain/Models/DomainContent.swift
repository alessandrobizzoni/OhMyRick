//
//  ResponseModel.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 17/4/24.
//

import Foundation

struct DomainContent: Decodable, Equatable {
    let pageInfo: DomainPageInfo
    let characters: [DomainCharacter]
    
    enum CodingKeys: String, CodingKey {
        case pageInfo = "info"
        case characters = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pageInfo = try container.decode(DomainPageInfo.self, forKey: .pageInfo)
        characters = try container.decode([DomainCharacter].self, forKey: .characters)
    }
    
    init(pageInfo: DomainPageInfo, characters: [DomainCharacter]) {
        self.pageInfo = pageInfo
        self.characters = characters
    }
}
