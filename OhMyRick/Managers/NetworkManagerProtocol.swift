//
//  NetworkManagerProtocol.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 23/4/24.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    
    func getCharacters(nextPage: String?) -> AnyPublisher<Response, Error>
    
    func getFilteredCharacters(filterParameters: [String: String?], nextPage: String?) -> AnyPublisher<Response, Error>
}
