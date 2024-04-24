//
//  OMRInteractorProtocol.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 24/4/24.
//

import Foundation
import UIKit
import Combine

protocol OMRInteractorProtocol {
    
    func getCharacters(nextPage: String?) -> AnyPublisher<DomainContent, Error>
    
    func getFilteredCharacters(filterParameters: [String: String?], nextPage: String?) -> AnyPublisher<DomainContent, Error>
    
    func fetchImage(url: URL) -> AnyPublisher<UIImage?, Error>
}
