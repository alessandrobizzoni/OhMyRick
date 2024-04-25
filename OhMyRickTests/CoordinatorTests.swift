//
//  CoordinatorTests.swift
//  OhMyRickTests
//
//  Created by Alessandro Bizzoni on 25/4/24.
//

import XCTest
@testable import OhMyRick

class ManagersTests: XCTestCase {
    
    func testGetInteractorForLiveEnvironment() {
        let interactor = Managers.getInteractor(for: .live)
        XCTAssertTrue(interactor is OMRInteractor)
    }

    func testGetInteractorForSandboxEnvironment() {
        let interactor = Managers.getInteractor(for: .sandbox)
        XCTAssertTrue(interactor is OMRInteractorMock)
    }
}

