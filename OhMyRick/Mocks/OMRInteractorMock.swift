//
//  OMRInteractorMock.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 24/4/24.
//

import Foundation
import Combine

class OMRInteractorMock: OMRInteractorProtocol {
    
    var mockResponse: BSResponse = .init(
        info: .init(
            count: 5,
            pages: 1,
            next: nil,
            prev: nil
        ),
        results: [
            .init(
                id: 1,
                name: "Rick",
                status: .alive,
                species: "Human",
                gender: .male,
                image: ""
            ),
            .init(
                id: 2,
                name: "Morty",
                status: .alive,
                species: "Human",
                gender: .male,
                image: ""
            )
        ]
    )
    
    var shouldFailWithError = false
    
    func getCharacters(nextPage: String?) -> AnyPublisher<BSResponse, Error> {
        if shouldFailWithError {
            return Fail(error: NSError(domain: "TestErrorDomain", code: 123, userInfo: nil)).eraseToAnyPublisher()
        } else {
            return Just(mockResponse)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func getFilteredCharacters(filterParameters: [String : String?], nextPage: String?) -> AnyPublisher<BSResponse, Error> {
        if shouldFailWithError {
            return Fail(error: NSError(domain: "TestErrorDomain", code: 123, userInfo: nil)).eraseToAnyPublisher()
        } else {
            return Just(mockResponse)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}