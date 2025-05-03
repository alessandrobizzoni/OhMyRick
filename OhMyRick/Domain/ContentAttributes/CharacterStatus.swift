//
//  CharacterStatus.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 17/4/24.
//

import Foundation

enum CharacterStatus: String, Decodable, Encodable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown
    
    var icon: String {
        switch self {
        case .alive:
            return "😁"
            
        case .dead:
            return "💀"
            
        case .unknown:
            return "🫥"
        }
    }
}
