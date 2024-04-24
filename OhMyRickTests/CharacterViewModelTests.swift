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
    var omrInteractor: OMRInteractorMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        omrInteractor = OMRInteractorMock()
        viewModel = CharactersViewModel(omrInteractor: omrInteractor)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        omrInteractor = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testUpdateCharactersList_NoFilters() {
        let expectedCharacters = [
            BSCharacter(id: 1, name: "Rick", status: .alive, species: "Human", gender: .male, image: ""),
            BSCharacter(id: 2, name: "Morty", status: .alive, species: "Human", gender: .male, image: "")
        ]
        omrInteractor = OMRInteractorMock()
        omrInteractor.mockResponse = BSResponse(info: BSInfo(count: 2, pages: 1, next: nil, prev: nil), results: expectedCharacters)
        viewModel = CharactersViewModel(omrInteractor: omrInteractor)
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
            BSCharacter(id: 1, name: "Rick", status: .alive, species: "Human", gender: .male, image: ""),
            BSCharacter(id: 2, name: "Morty", status: .alive, species: "Human", gender: .male, image: "")
        ]
        omrInteractor.mockResponse = BSResponse(info: BSInfo(count: 5, pages: 1, next: nil, prev: nil), results: expectedFilteredCharacters)
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
        omrInteractor.shouldFailWithError = true
        
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
