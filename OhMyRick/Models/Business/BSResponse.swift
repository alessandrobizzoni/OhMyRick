//
//  ResponseModel.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 17/4/24.
//

import Foundation

struct BSResponse: Decodable, Equatable {
    let info: BSInfo
    let results: [BSCharacter]
}
