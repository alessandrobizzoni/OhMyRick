//
//  Coordinator.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 23/4/24.
//

import Foundation
import SwiftUI
import UIKit

enum Page: Hashable {
    case ohMyRickMainView
    case charactersList
}

enum AppEnvironment {
case live, sandbox
}

class Coordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    
    func push(page: Page) {
        path.append(page)
    }
    
    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .ohMyRickMainView:
            OhMyRickMainView()
        case .charactersList:
            CharactersView(
                viewModel: .init(
                    omrInteractor: Managers.getInteractor(for: .live)
                )
            )
        }
    }
}

class Managers {
    static func getInteractor(for environment: AppEnvironment)  -> OMRInteractorProtocol {
        switch environment {
        case .live:
            return OMRInteractor(networkManager: Network(), cache: Cache<String, DomainContent>(), imageCache: Cache<String, UIImage>())
        case .sandbox:
            return OMRInteractorMock()
        }
    }
}
