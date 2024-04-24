//
//  DataInfo.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 24/4/24.
//

import Foundation

struct DataInfo: Decodable, Equatable, Encodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
