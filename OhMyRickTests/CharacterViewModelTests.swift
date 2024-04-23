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
    var networkManager: MockNetworkManager!
    var cancellables: Set<AnyCancellable> = []
    var cache: Cache<String, Response>!
    
    override func setUp() {
        super.setUp()
        networkManager = MockNetworkManager()
        cache = Cache<String, Response>()
        viewModel = CharactersViewModel()
        viewModel.networkManager = networkManager
    }
    
    override func tearDown() {
        viewModel = nil
        networkManager = nil
        cache = nil
        super.tearDown()
    }
    
    func testGetAllCharacters_SuccessfulResponse() {
        // Arrange
        let responseInfo = Info(count: 1, pages: 1, next: nil, prev: nil)
        let character = Character(id: 1, name: "Rick", status: .alive, species: "Human", gender: .male, image: "")
        let response = Response(info: responseInfo, results: [character])
        networkManager.response = response
        
        // Act
        viewModel.getAllCharacters()
        
        // Assert
        XCTAssertEqual(viewModel.characters.count, 1)
        XCTAssertEqual(viewModel.responseInfo?.count, 1)
        XCTAssertEqual(viewModel.responseInfo?.pages, 1)
        XCTAssertEqual(viewModel.characters.first?.name, "Rick")
        XCTAssertFalse(viewModel.networkError)
        XCTAssertNil(cache.value(forKey: "https://example.com/page2"))
    }
    
    func testGetAllCharacters_CachedResponse() {
        // Arrange
        let responseInfo = Info(count: 1, pages: 1, next: nil, prev: nil)
        let character = Character(id: 1, name: "Morty", status: .alive, species: "Human", gender: .male, image: "")
        let cachedResponse = Response(info: responseInfo, results: [character])
        let nextPageURL = "https://example.com/page2"
        cache.insert(cachedResponse, forKey: nextPageURL)
        
        // Act
        viewModel.getAllCharacters(.next)
        
        // Assert
        XCTAssertEqual(viewModel.characters.count, 1)
        XCTAssertEqual(viewModel.responseInfo?.count, 1)
        XCTAssertEqual(viewModel.responseInfo?.pages, 1)
        XCTAssertEqual(viewModel.characters.first?.name, "Morty")
        XCTAssertFalse(viewModel.networkError)
    }
    
    func testGetAllCharacters_FailureResponse() {
        // Arrange
        let error = NSError(domain: "TestErrorDomain", code: 123, userInfo: nil)
        networkManager.error = error
        
        // Act
        viewModel.getAllCharacters()
        
        // Assert
        XCTAssertNil(viewModel.responseInfo)
        XCTAssertEqual(viewModel.characters.count, 0)
        XCTAssertTrue(viewModel.networkError)
    }
    
    func testFilteredCharacters() {
        // Arrange
        let rick = Character(id: 1, name: "Rick", status: .alive, species: "Human", gender: .male, image: "")
        let morty = Character(id: 2, name: "Morty", status: .alive, species: "Human", gender: .male, image: "")
        let summer = Character(id: 3, name: "Summer", status: .alive, species: "Human", gender: .female, image: "")
        viewModel.characters = [rick, morty, summer]
        
        // Act
        viewModel.selectedGender = .male
        
        // Assert
        XCTAssertEqual(viewModel.filteredCharacters.count, 2)
        XCTAssertTrue(viewModel.filteredCharacters.contains(where: { $0.name == "Rick" }))
        XCTAssertTrue(viewModel.filteredCharacters.contains(where: { $0.name == "Morty" }))
        XCTAssertFalse(viewModel.filteredCharacters.contains(where: { $0.name == "Summer" }))
    }
}

class MockNetworkManager: NetworkManager {
    var response: Response?
    var error: Error?
    
    override func getCharacters(nextPage: String?) -> AnyPublisher<Response, Error> {
        if let response = response {
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else if let error = error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        } else {
            fatalError("No response or error provided in MockNetworkManager")
        }
    }
}
