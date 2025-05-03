//
//  ContentView.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 17/4/24.
//

import SwiftUI

struct OhMyRickMainView: View {
    
    let kButtonSectionWidth: CGFloat = 150
    
    let kButtonSectionHeight: CGFloat = 50
    
    let kButtonSectionRadius: CGFloat = 6.0
    
    let kButtonSectionTextSize: CGFloat = 20
    
    let kTitleHeight: CGFloat = 100
    
    let kTitleSize: CGFloat = 50
    
    let kPortalHeight: CGFloat = 320
    
    let kScreenTitle: String = "Oh My Rick"
    
    let kButtonCharactersTitle: String = "Characters"
    
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        VStack(spacing: 80) {
            Text(kScreenTitle)
                .font(
                    .system(
                        size: kTitleSize,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: kTitleHeight, alignment: .top)
                .padding(.top)
            
            HStack(spacing: 10) {
                Text(kButtonCharactersTitle)
                    .font(
                        .system(
                            size: kButtonSectionTextSize,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(.primaryRick)
                    .background {
                        Rectangle()
                            .fill(Color.secondaryRick)
                            .cornerRadius(kButtonSectionRadius)
                            .frame(width: kButtonSectionWidth, height: kButtonSectionHeight)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        coordinator.push(page: .charactersList)
                    }
                
                portalImage
                    .frame(height: kPortalHeight)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [.primaryRick, .secondaryRick],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

private extension OhMyRickMainView {
    var portalImage: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            Image(.portal)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: size.width, height: size.width * 1.8)
                .frame(maxWidth: .infinity, alignment: .center)
                .offset(x: 70)
        }
    }
}

#Preview {
    OhMyRickMainView()
}
