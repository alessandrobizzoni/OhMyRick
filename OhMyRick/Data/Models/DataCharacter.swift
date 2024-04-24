//
//  DataCharacter.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 24/4/24.
//

import Foundation

struct DataCharacter: Decodable, Identifiable, Equatable, Encodable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let gender: CharacterGender
    let image: String
}
