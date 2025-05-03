//
//  CharacterPages.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 20/4/24.
//

import Foundation

enum CharacterPages {
    case next
    case prev
    
    func getPageUrl(infoResponse: DomainPageInfo?) -> String? {
        switch self {
        case .next:
            return infoResponse?.next
            
        case .prev:
            return infoResponse?.prev
        }
    }
}
