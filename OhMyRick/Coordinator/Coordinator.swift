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
            CharactersView()
        }
    }
}
