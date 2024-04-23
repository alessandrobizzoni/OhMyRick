//
//  Coordinator.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 23/4/24.
//

import Foundation
import SwiftUI

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
                    networkManager: Managers.getNetworkManager(for: .live)
                )
            )
        }
    }
}

class Managers {
    static func getNetworkManager(for environment: AppEnvironment)  -> NetworkManagerProtocol {
        switch environment {
        case .live:
            return NetworkManager()
        case .sandbox:
            return NetworkManagerMock()
        }
    }
}
