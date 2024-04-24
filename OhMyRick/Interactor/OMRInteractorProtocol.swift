//
//  OMRInteractorProtocol.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 24/4/24.
//

import Foundation
import Combine

protocol OMRInteractorProtocol {
    
    func getCharacters(nextPage: String?) -> AnyPublisher<BSResponse, Error>
    
    func getFilteredCharacters(filterParameters: [String: String?], nextPage: String?) -> AnyPublisher<BSResponse, Error>
}
