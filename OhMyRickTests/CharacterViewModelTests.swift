//
//  CharacterViewModelTests.swift
//  OhMyRickTests
//
//  Created by Alessandro Bizzoni on 21/4/24.
//

import XCTest
import Combine
@testable import OhMyRick

class CharactersViewModelTests: XCTestCase {
    
    var viewModel: CharactersViewModel!
    var networkManager: NetworkManagerMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkManagerMock()
        viewModel = CharactersViewModel(networkManager: networkManager)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        networkManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testUpdateCharactersList_NoFilters() {
        let expectedCharacters = [
            Character(id: 1, name: "Rick", status: .alive, species: "Human", gender: .male, image: ""),
            Character(id: 2, name: "Morty", status: .alive, species: "Human", gender: .male, image: "")
        ]
        networkManager = NetworkManagerMock()
        networkManager.mockResponse = Response(info: Info(count: 2, pages: 1, next: nil, prev: nil), results: expectedCharacters)
        viewModel = CharactersViewModel(networkManager: networkManager)
        viewModel.filterParameters.removeAll()
        
        let expectation = XCTestExpectation(description: "Characters loaded")
        
        viewModel.updateCharactersList()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.viewModel.characters, expectedCharacters)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

    
    func testUpdateCharactersList_WithFilters() {
        let expectedFilteredCharacters = [
            Character(id: 1, name: "Rick", status: .alive, species: "Human", gender: .male, image: ""),
            Character(id: 2, name: "Morty", status: .alive, species: "Human", gender: .male, image: "")
        ]
        networkManager.mockResponse = Response(info: Info(count: 5, pages: 1, next: nil, prev: nil), results: expectedFilteredCharacters)
        viewModel.filterParameters = ["gender": "Male"]
        
        let expectation = XCTestExpectation(description: "Characters loaded")
        
        viewModel.updateCharactersList()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.viewModel.characters, expectedFilteredCharacters)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testUpdateCharactersList_NetworkError() {
        let expectedErrorMessage = "The operation couldn’t be completed. (TestErrorDomain error 123.)"
        networkManager.shouldFailWithError = true
        
        let expectation = XCTestExpectation(description: "Characters loaded")
        
        viewModel.updateCharactersList()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.viewModel.networkError)
            XCTAssertEqual(self.viewModel.errorMessg, expectedErrorMessage)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
