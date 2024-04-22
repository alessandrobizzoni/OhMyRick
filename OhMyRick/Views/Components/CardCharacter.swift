//
//  SwiftUIView.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 17/4/24.
//

import SwiftUI
import Combine

struct CardCharacter: View {
    
    let title: String
    
    let image: String
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.primaryRick, .secondaryRick],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(6.0)
                .frame(height: 160, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            VStack(alignment: .center, spacing: 10) {
                if let urlImage = URL(string: image) {
                    OMRAsyncImage(url: urlImage)
                }
                
                Text(title)
                    .foregroundStyle(.white)
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    CardCharacter(
        title: "Title",
        image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
}
