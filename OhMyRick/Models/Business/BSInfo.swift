//
//  Info.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 20/4/24.
//

import Foundation

struct BSInfo: Decodable, Equatable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
