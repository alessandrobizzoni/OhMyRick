//
//  Cache.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 21/4/24.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private var storage: [Key: Value] = [:]
    private let queue = DispatchQueue(label: "com.ohMyRick.cacheQueue")

    func insert(_ value: Value, forKey key: Key) {
        queue.async { [weak self] in
            guard let self = self else { return }
            self.storage[key] = value
        }
    }

    func value(forKey key: Key) -> Value? {
        return queue.sync {
            return storage[key]
        }
    }
}

