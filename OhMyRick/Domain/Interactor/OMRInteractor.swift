//
//  OMRInteractor.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 24/4/24.
//

import Foundation
import UIKit
import Combine

class OMRInteractor: OMRInteractorProtocol {
    
    let networkManager: NetworkProtocol
    
    var cache: Cache<String, DomainContent>
    
    var imageCache: Cache<String, UIImage>
    
    init(networkManager: NetworkProtocol, cache: Cache<String, DomainContent>, imageCache: Cache<String, UIImage>) {
        self.networkManager = networkManager
        self.cache = cache
        self.imageCache = imageCache
    }
    
    func getCharacters(nextPage: String? = nil) -> AnyPublisher<DomainContent, Error> {
        var nextUrl: String = ""
        if let nextPageUrl = nextPage {
            nextUrl = nextPageUrl
        }
        
        if let cachedCharacters = cache.value(forKey: nextUrl) {
            print("[LOG] Cache \(nextUrl) returned")
            return Just(cachedCharacters)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return networkManager.getCharacters(nextPage: nextUrl)
            .encode(encoder: JSONEncoder())
            .decode(type: DomainContent.self, decoder: JSONDecoder())
            .map {
                self.cache.insert($0, forKey: nextUrl)
                return $0
            }
            .eraseToAnyPublisher()
    }
    
    func getFilteredCharacters(filterParameters: [String : String?], nextPage: String? = nil) -> AnyPublisher<DomainContent, Error> {
        var nextUrl: String = ""
        if let nextPageUrl = nextPage {
            nextUrl = nextPageUrl
        }
        
        return networkManager.getFilteredCharacters(filterParameters: filterParameters, nextPage: nextUrl)
            .encode(encoder: JSONEncoder())
            .decode(type: DomainContent.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchImage(url: URL) -> AnyPublisher<UIImage?, Error> {
        if let cachedImage = imageCache.value(forKey: url.absoluteString) {
            return Just(cachedImage)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { data, _ -> UIImage? in
                    return UIImage(data: data)
                }
                .map { image -> UIImage? in
                    if let image = image {
                        self.imageCache.insert(image, forKey: url.absoluteString)
                    }
                    return image
                }
                .eraseToAnyPublisher()
        }
    }
}
