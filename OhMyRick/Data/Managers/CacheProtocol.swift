//
//  CacheProtocol.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 24/4/24.
//

import UIKit

protocol CacheProtocol {
    associatedtype Key: Hashable
    associatedtype Value
    
    func insert(_ value: Value, forKey key: Key)
    func value(forKey key: Key) -> Value?
}

protocol ImageCacheProtocol: CacheProtocol where Key == String, Value == UIImage {}

protocol DataCacheProtocol: CacheProtocol where Key == String, Value == Codable {}
