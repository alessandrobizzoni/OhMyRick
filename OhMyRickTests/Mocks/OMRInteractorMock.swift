//
//  OMRInteractoMock.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 22/4/24.
//

import Foundation
import UIKit
import Combine
@testable import OhMyRick

class OMRInteractorMock: OMRInteractorProtocol {
    
    var mockResponse: DomainContent = DomainContent(
        pageInfo: .init(pages: 1, next: "nextPage", prev: "prevPage"),
        characters: [
            .init(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", gender: .male, image: "https://example.com/rick.jpg"),
            .init(id: 2, name: "Morty Smith", status: .alive, species: "Human", gender: .female, image: "https://example.com/morty.jpg")
        ]
    )
    
    var shouldFailWithError = false
    
    func getCharacters(nextPage: String?) -> AnyPublisher<DomainContent, Error> {
        if shouldFailWithError {
            return Fail(error: NSError(domain: "TestErrorDomain", code: 123, userInfo: nil)).eraseToAnyPublisher()
        } else {
            return Just(mockResponse)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func getFilteredCharacters(filterParameters: [String : String?], nextPage: String?) -> AnyPublisher<DomainContent, Error> {
        if shouldFailWithError {
            return Fail(error: NSError(domain: "TestErrorDomain", code: 123, userInfo: nil)).eraseToAnyPublisher()
        } else {
            return Just(mockResponse)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    var mockImage: UIImage?
    
    func fetchImage(url: URL) -> AnyPublisher<UIImage?, Error> {
        return Just(mockImage)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
    }
}

