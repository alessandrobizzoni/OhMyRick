//
//  File.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 24/4/24.
//

import Foundation

struct DataResponse: Decodable, Equatable, Encodable {
    let info: DataInfo
    let results: [DataCharacter]
}
