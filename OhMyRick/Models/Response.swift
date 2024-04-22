//
//  ResponseModel.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 17/4/24.
//

import Foundation

struct Response: Decodable {
    let info: Info
    let results: [Character]
}
