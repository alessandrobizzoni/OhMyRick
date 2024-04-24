//
//  CacheProtocol.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 24/4/24.
//

protocol CacheProtocol {
    associatedtype Key: Hashable
    associatedtype Value
    
    func insert(_ value: Value, forKey key: Key)
    func value(forKey key: Key) -> Value?
}
