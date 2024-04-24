//
//  CharacterPagesTests.swift
//  OhMyRickTests
//
//  Created by Alessandro Bizzoni on 23/4/24.
//

import XCTest
@testable import OhMyRick

class CharacterPagesTests: XCTestCase {
    
    func testGetPageUrl_NextPage() {
        let infoResponse = BSInfo(count: 10, pages: 2, next: "https://example.com/page=2", prev: "https://example.com/page=1")
        
        let nextPageUrl = CharacterPages.next.getPageUrl(infoResponse: infoResponse)
        
        XCTAssertEqual(nextPageUrl, "https://example.com/page=2")
    }
    
    func testGetPageUrl_PrevPage() {
        let infoResponse = BSInfo(count: 10, pages: 2, next: "https://example.com/page=2", prev: "https://example.com/page=1")
        
        let prevPageUrl = CharacterPages.prev.getPageUrl(infoResponse: infoResponse)
        
        XCTAssertEqual(prevPageUrl, "https://example.com/page=1")
    }
    
    func testGetPageUrl_NoInfoResponse() {
        let infoResponse: BSInfo? = nil
        
        let nextPageUrl = CharacterPages.next.getPageUrl(infoResponse: infoResponse)
        let prevPageUrl = CharacterPages.prev.getPageUrl(infoResponse: infoResponse)
        
        XCTAssertNil(nextPageUrl)
        XCTAssertNil(prevPageUrl)
    }
    
    func testGetPageUrl_MissingPage() {
        let infoResponse = BSInfo(count: 10, pages: 2, next: nil, prev: nil)
        
        let nextPageUrl = CharacterPages.next.getPageUrl(infoResponse: infoResponse)
        let prevPageUrl = CharacterPages.prev.getPageUrl(infoResponse: infoResponse)
        
        XCTAssertNil(nextPageUrl)
        XCTAssertNil(prevPageUrl)
    }
}

