//
//  CharacterStatusTests.swift
//  OhMyRickTests
//
//  Created by Alessandro Bizzoni on 23/4/24.
//

import XCTest
@testable import OhMyRick

class CharacterStatusTests: XCTestCase {

    func testIconForAlive() {
        let status: CharacterStatus = .alive
        
        let icon = status.icon
        
        XCTAssertEqual(icon, "😁")
    }
    
    func testIconForDead() {
        let status: CharacterStatus = .dead
        
        let icon = status.icon
        
        XCTAssertEqual(icon, "💀")
    }
    
    func testIconForUnknown() {
        let status: CharacterStatus = .unknown
        
        let icon = status.icon
        
        XCTAssertEqual(icon, "🫥")
    }
}
