//
//  CharactersViewUITests.swift
//  OhMyRickUITests
//
//  Created by Alessandro Bizzoni on 24/4/24.
//

import XCTest

final class CharactersViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
    }
    
    func testFistView() throws {
        let charactersBtn = app.staticTexts["Characters"]
        XCTAssertTrue(charactersBtn.exists)
        charactersBtn.tap()
        let charactersViewTitle = app.staticTexts["🥒Characters"]
        XCTAssertTrue(charactersViewTitle.waitForExistence(timeout: 5))
    }
    
    func testGenderFilterButtons() throws {
        let charactersBtn = app.staticTexts["Characters"]
        XCTAssertTrue(charactersBtn.exists)
        charactersBtn.tap()
        
        // Check Female button
        var btn = app.buttons["Female"]
        XCTAssertTrue(btn.exists)
        
        btn.tap()
        app.cells.element(boundBy: 0).tap()
        var genderText = app.staticTexts["Specie: Human"]
        XCTAssertTrue(genderText.exists)
        app.buttons["Close"].tap()
        
        // Check Male button
        btn = app.buttons["Male"]
        XCTAssertTrue(btn.exists)
        btn.tap()
        
        app.cells.element(boundBy: 0).tap()
        genderText = app.staticTexts["Specie: Human"]
        
        XCTAssertTrue(genderText.exists)
        app.buttons["Close"].tap()
        
        // Check Genderless button
        btn = app.buttons["Genderless"]
        XCTAssertTrue(btn.exists)
        btn.tap()
        sleep(1)
        app.cells.element(boundBy: 0).tap()
        genderText = app.staticTexts["Specie: Alien"]
        XCTAssertTrue(genderText.exists)
        app.buttons["Close"].tap()
        
        btn = app.buttons["Next"]
        XCTAssertFalse(btn.exists)
        btn = app.buttons["Previous"]
        XCTAssertFalse(btn.exists)
        btn = app.buttons["Genderless"]
        btn.tap()
        
        app.buttons["Next"].tap()
        XCTAssertGreaterThan(app.cells.count, 0)
        app.buttons["Next"].tap()
        XCTAssertGreaterThan(app.cells.count, 0)
        app.buttons["Previous"].tap()
        XCTAssertGreaterThan(app.cells.count, 0)
        
        app.searchFields["Search Name"].tap()
        app.searchFields["Search Name"].typeText("Smith")
        app.buttons["Search"].tap()
        XCTAssertGreaterThan(app.cells.count, 0)
        
        app.cells.element(boundBy: 0).tap()
        let characterName = app.staticTexts["Morty Smith"]
        XCTAssertTrue(characterName.exists)
        app.buttons["Close"].tap()
        btn = app.buttons["Cancel"]
        btn.tap()
        btn = app.buttons["Back"]
        XCTAssertTrue(btn.waitForExistence(timeout: 2))
        btn.tap()
        let title = app.staticTexts["Oh My Rick"]
        XCTAssertTrue(title.exists)
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
