//
//  CacheTests.swift
//  OhMyRickTests
//
//  Created by Alessandro Bizzoni on 23/4/24.
//

import XCTest
@testable import OhMyRick

class CacheTests: XCTestCase {
    
    func testInsertAndRetrieve() {
        let cache = Cache<String, Int>()
        
        cache.insert(10, forKey: "key1")
        cache.insert(20, forKey: "key2")
        
        XCTAssertEqual(cache.value(forKey: "key1"), 10)
        XCTAssertEqual(cache.value(forKey: "key2"), 20)
    }
    
    func testInsertSameKey() {
        let cache = Cache<String, Int>()
        
        cache.insert(10, forKey: "key")
        cache.insert(20, forKey: "key")
        
        XCTAssertEqual(cache.value(forKey: "key"), 20)
    }
    
    func testRetrieveNonExistentKey() {
        let cache = Cache<String, Int>()
        
        let value = cache.value(forKey: "nonexistent")
        
        XCTAssertNil(value)
    }
}
