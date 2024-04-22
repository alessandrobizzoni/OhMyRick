//
//  NetworkManager.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 17/4/24.
//

import Foundation
import UIKit
import Combine

class NetworkManager {
    
    private var cache = Cache<String, Response>()
    private var imageCache = Cache<String, UIImage>()
    
    static let baseURL = "https://rickandmortyapi.com/api/"
    
    private let charactersURL = baseURL + "character"
    
    func getCharacters(nextPage: String? = nil) -> AnyPublisher<Response, Error> {
        var nextUrl: String = ""
        if let nextPageUrl = nextPage {
            nextUrl = nextPageUrl
        } else {
            nextUrl = charactersURL
        }
        
        if let cachedCharacters = cache.value(forKey: nextUrl) {
            print("[LOG] Cache \(nextUrl) returned")
            return Just(cachedCharacters)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        guard let url = URL(string: nextUrl) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Response.self, decoder: JSONDecoder())
            .map {
                print("[DEBUG] \($0)")
                self.cache.insert($0, forKey: nextUrl)
                return $0
            }
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