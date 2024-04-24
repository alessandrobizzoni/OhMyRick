//
//  OMRInteractor.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 24/4/24.
//

import Foundation
import Combine

class OMRInteractor: OMRInteractorProtocol {
    
    let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func getCharacters(nextPage: String? = nil) -> AnyPublisher<BSResponse, Error> {
        var nextUrl: String = ""
        if let nextPageUrl = nextPage {
            nextUrl = nextPageUrl
        }
        
        return networkManager.getCharacters(nextPage: nextUrl)
            .encode(encoder: JSONEncoder())
            .decode(type: BSResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getFilteredCharacters(filterParameters: [String : String?], nextPage: String? = nil) -> AnyPublisher<BSResponse, Error> {
        var nextUrl: String = ""
        if let nextPageUrl = nextPage {
            nextUrl = nextPageUrl
        }
        
        return networkManager.getFilteredCharacters(filterParameters: filterParameters, nextPage: nextUrl)
            .encode(encoder: JSONEncoder())
            .decode(type: BSResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
