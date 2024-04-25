//
//  NetworkManager.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 17/4/24.
//

import Foundation
import UIKit
import Combine

class Network: NetworkProtocol {
    
    static let baseURL = "https://rickandmortyapi.com/api/"
    
    private let charactersURL = baseURL + "character"
    
    func getCharacters(nextPage: String = "") -> AnyPublisher<DataResponse, Error> {
        let nextUrl: String = !nextPage.isEmpty ? nextPage : charactersURL
        
        guard let url = URL(string: nextUrl) else {
            return Fail(error: OMRErrors.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: DataResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getFilteredCharacters(filterParameters: [String: String?], nextPage: String = "") -> AnyPublisher<DataResponse, Error> {
        var nextParametersURL = URLComponents(string: charactersURL)
        nextParametersURL?.queryItems = filterParameters.map {
            URLQueryItem(
                name: $0.key,
                value: $0.value
            )
        }
        let nextURL: URLComponents? = !nextPage.isEmpty ? URLComponents(string: nextPage) : nextParametersURL
        
        guard let url = nextURL?.url else {
            return Fail(error: OMRErrors.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: DataResponse.self, decoder: JSONDecoder())
            .map {
                print("[DEBUG] \($0)")
                return $0
            }
            .eraseToAnyPublisher()
    }
}
