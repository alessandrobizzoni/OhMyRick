//
//  ContentView.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 17/4/24.
//

import SwiftUI

struct OhMyRickMainView: View {
    
    let kScreenTitle: String = "Oh My Rick"
    
    let kScreenSubtitle: String = "The Rick's extended documentation"
    
    @State private var portalAnimation = 0.0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 80) {
                Text(kScreenTitle)
                    .font(
                        .system(
                            size: 50,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .top)
                    .padding(.top)
                
                HStack(spacing: 10) {
                    NavigationLink(destination: CharactersView()) {
                        Text("Characters")
                            .font(
                                .system(
                                    size: 20,
                                    weight: .bold,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(.primaryRick)
                            .background {
                                Rectangle()
                                    .fill(Color.secondaryRick)
                                    .cornerRadius(6.0)
                                    .frame(width: 150, height: 50)
                            }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    portalImage
                        .frame(height: 320)
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
            .onAppear {
                withAnimation(.easeInOut(duration: 10)) {
                    portalAnimation += 360
                }
            }
        }
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
                .rotationEffect(.init(degrees: portalAnimation))
                .frame(width: size.width, height: size.width * 1.8)
                .frame(maxWidth: .infinity, alignment: .center)
                .offset(x: 70)
        }
    }
}

#Preview {
    OhMyRickMainView()
}
