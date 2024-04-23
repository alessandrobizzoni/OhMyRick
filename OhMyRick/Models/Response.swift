//
//  ResponseModel.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 17/4/24.
//

import Foundation

struct Response: Decodable, Equatable {
    let info: Info
    let results: [Character]
}
