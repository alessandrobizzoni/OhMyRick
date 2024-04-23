//
//  CardCharacterTests.swift
//  OhMyRickTests
//
//  Created by Alessandro Bizzoni on 23/4/24.
//

@testable import OhMyRick
import XCTest
import SwiftUI

class CardCharacterTests: XCTestCase {
    
    func testCardCharacterView() {
        // Given
        let title = "Rick Sanchez"
        let image = "https://example.com/rick.jpg"
        
        // When
        let cardCharacterView = CardCharacter(title: title, image: image)
        
        // Then
        XCTAssertNotNil(cardCharacterView)
    }
}

