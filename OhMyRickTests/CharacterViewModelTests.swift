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
    var mockNetworkManager: NetworkManagerMock!
    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        mockNetworkManager = NetworkManagerMock()
        viewModel = CharactersViewModel(networkManager: mockNetworkManager)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockNetworkManager = nil
        cancellables.removeAll()
    }
    
    func testGetAllCharacters() {
        // Given
        let expectation = XCTestExpectation(description: "Characters fetched")
        
        // When
        viewModel.getAllCharacters()
        
        // Then
        viewModel.$characters
            .sink { characters in
                XCTAssertEqual(characters.count, 2)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetFilteredCharacters() {
        // Given
        let expectation = XCTestExpectation(description: "Filtered characters fetched")
        
        // When
        viewModel.filterParameters = ["gender": "Male"]
        viewModel.getFilteredCharacters()
        
        // Then
        viewModel.$characters
            .sink { characters in
                XCTAssertEqual(characters.count, 1)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
