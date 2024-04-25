//
//  NetworkTests.swift
//  OhMyRickTests
//
//  Created by Alessandro Bizzoni on 25/4/24.
//

import XCTest
import Combine
@testable import OhMyRick

class NetworkTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    var network: Network!

    override func setUp() {
        super.setUp()
        network = Network()
    }

    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        super.tearDown()
    }

    func testGetCharacters() {
        let expectation = XCTestExpectation(description: "Fetch characters")
        
        network.getCharacters()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Failed to fetch characters with error: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { response in
                XCTAssertNotNil(response)
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetFilteredCharacters() {
        let expectation = XCTestExpectation(description: "Fetch filtered characters")

        let filterParameters: [String: String?] = [
            "name": "Rick",
            "gender": "Male"
        ]

        network.getFilteredCharacters(filterParameters: filterParameters)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Failed to fetch filtered characters with error: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { response in
                XCTAssertNotNil(response)
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }

}
