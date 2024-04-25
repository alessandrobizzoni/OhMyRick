//
//  OMRInteractorTests.swift
//  OhMyRickTests
//
//  Created by Alessandro Bizzoni on 24/4/24.
//

import XCTest
import Combine

@testable import OhMyRick

class OMRInteractorTests: XCTestCase {
    
    var interactor: OMRInteractor!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        interactor = OMRInteractor(networkManager: NetworkMock() as! NetworkProtocol, cache: Cache<String, DomainContent>(), imageCache: Cache<String, UIImage>())
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        interactor = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testGetCharacters() {
        let expectation = expectation(description: "Characters received")
        
        interactor.getCharacters()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Error occurred: \(error.localizedDescription)")
                }
                expectation.fulfill()
            }, receiveValue: { response in
                XCTAssertNotNil(response)
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetCharacters_withNextPage() {
        let expectation = expectation(description: "Characters received")
        
        interactor.getCharacters(nextPage: "https://rickandmortyapi.com/api/character/?page=2")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Error occurred: \(error.localizedDescription)")
                }
                expectation.fulfill()
            }, receiveValue: { response in
                XCTAssertNotNil(response)
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetFilteredCharacters() {
        let filterParameters: [String: String?] = ["key": "value"]
        let expectation = expectation(description: "Filtered characters received")
        
        interactor.getFilteredCharacters(filterParameters: filterParameters)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Error occurred: \(error.localizedDescription)")
                }
                expectation.fulfill()
            }, receiveValue: { response in
                XCTAssertNotNil(response)
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetFilteredCharacters_withNextPage() {
        let filterParameters: [String: String?] = ["key": "value"]
        let expectation = expectation(description: "Filtered characters received")
        
        interactor.getFilteredCharacters(filterParameters: filterParameters, nextPage: "https://rickandmortyapi.com/api/character/?page=2")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Error occurred: \(error.localizedDescription)")
                }
                expectation.fulfill()
            }, receiveValue: { response in
                XCTAssertNotNil(response)
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchImageWithValidURL() {
        let expectation = XCTestExpectation(description: "Fetch image with valid URL")
        let imageURL = URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!

        let cancellable = interactor.fetchImage(url: imageURL)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Failed to fetch image with valid URL and error: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { image in
                XCTAssertNotNil(image)
            })

        wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }

    func testFetchImageWithInvalidURL() {
        let expectation = XCTestExpectation(description: "Fetch image with invalid URL")
        let invalidURL = URL(string: "invalid-url")!

        let cancellable = interactor.fetchImage(url: invalidURL)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Fetch image with invalid URL should fail")
                case .failure(let error):
                    XCTAssertTrue(error is URLError)
                    expectation.fulfill()
                }
            }, receiveValue: { image in
                XCTFail("Should not receive image for invalid URL")
            })

        wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
}
