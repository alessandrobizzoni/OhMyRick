//
//  CharacterDetailView.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 17/4/24.
//

import SwiftUI

struct CharacterDetailView: View {
    
    let character: BSCharacter
    
    @Binding var isShowingDetail: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            AsyncImage(url: URL(string: character.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 225)
            } placeholder: {
                Image(.portal)
            }
            Text(character.name)
                .multilineTextAlignment(.center)
                .font(.system(size: 45, design: .rounded))
                .foregroundStyle(.white)
            
            HStack(spacing: 25) {
                Text("Specie: \(character.species)")
                    .foregroundStyle(.white)
                Text("Status: \(character.status.icon)")
                    .foregroundStyle(.white)
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .frame(width: 300, height: 525)
        .background(Color.secondaryRick)
        .cornerRadius(12)
        .shadow(radius: 40)
        .overlay(
            Button {
                isShowingDetail = false
            } label: {
                ZStack {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .opacity(0.6)
                    
                    Image(systemName: "xmark")
                        .imageScale(.small)
                        .frame(width: 44, height: 44)
                        .foregroundColor(.black)
                }
            }, alignment: .topTrailing
        )
    }
}

#Preview {
    CharacterDetailView(character: .init(id: 1, name: "Rick", status: .alive, species: "Human", gender: .genderless, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"), isShowingDetail: .constant(true))
}
