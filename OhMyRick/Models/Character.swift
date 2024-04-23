//
//  CharacterModel.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 17/4/24.
//

import Foundation

struct Character: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let gender: CharacterGender
    let image: String
}
