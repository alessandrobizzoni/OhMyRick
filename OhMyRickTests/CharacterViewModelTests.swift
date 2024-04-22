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
    
    override func setUp() {
        super.setUp()
        networkManager = MockNetworkManager()
        viewModel = CharactersViewModel()
        viewModel.networkManager = networkManager
    }
    
    override func tearDown() {
        viewModel = nil
        networkManager = nil
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
    
    func testSelectedGender() {
        viewModel.characters = [
            .init(id: 1, name: "Test1", status: .alive, species: "Human", gender: .male, image: ""),
            .init(id: 2, name: "Test2", status: .alive, species: "Human", gender: .female, image: "")
        ]
        
        viewModel.selectedGender = .male
        
        XCTAssertEqual(viewModel.characters.count, 1)
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
