//
//  CharactersView.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 17/4/24.
//

import SwiftUI

struct CharactersView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    
    @StateObject var viewModel: CharactersViewModel
    
    @State private var searchName: String = ""
    
    @State private var showDetail: Bool = false
    
    @State private var selectedCharacter: DomainCharacter?
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    filterButtons
                }
                if viewModel.characters.isEmpty {
                    emptyState
                } else {
                    charactersList
                }
                navigationPagesButtons
            }
            .background(Color.primaryRick)
            .navigationTitle("🥒Characters")
            .navigationBarTitleDisplayMode(.automatic)
            .searchable(text: $searchName, prompt: "Search Name")
            .onSubmit(of: .search) {
                viewModel.filterParameters.updateValue(searchName, forKey: "name")
            }
            .onChange(of: searchName) { newValue in
                if newValue.isEmpty {
                    viewModel.filterParameters.removeValue(forKey: "name")
                }
            }
            .onAppear {
                viewModel.getAllCharacters()
            }
            .alert(isPresented: $viewModel.networkError) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessg),
                    dismissButton: .default(Text("OK"))
                )
            }
            .blur(radius: showDetail ? 10 : 0)
            .disabled(showDetail)
            
            if let selectedCharacter = selectedCharacter, showDetail {
                CharacterDetailView(
                    character: selectedCharacter,
                    isShowingDetail: $showDetail
                )
            }
        }
    }
}
// MARK: - Helper Views
private extension CharactersView {
    var charactersList: some View {
        VStack(alignment: .leading) {
            List(viewModel.characters) { character in
                CardCharacter(
                    title: character.name,
                    image: character.image
                )
                .listRowBackground(Color.primaryRick)
                .onTapGesture {
                    withAnimation {
                        showDetail = true
                    }
                    selectedCharacter = character
                }
            }
            .listStyle(.plain)
        }
    }
    
    var filterButtons: some View {
        HStack {
            ForEach(CharacterGender.allCases, id: \.self) { gender in
                Button {
                    if viewModel.selectedGender == gender {
                        viewModel.filterParameters.removeValue(forKey: "gender")
                        viewModel.selectedGender = nil
                    } else {
                        viewModel.filterParameters.updateValue(gender.rawValue, forKey: "gender")
                        viewModel.selectedGender = gender
                    }
                    viewModel.currentPage = 1
                } label: {
                    ZStack {
                        Rectangle()
                            .fill(Color.secondaryRick)
                            .frame(width: 110, height: 50)
                            .cornerRadius(6.0)
                        Text(gender.rawValue)
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(.primaryRick)
                        if viewModel.selectedGender == gender {
                            Group {
                                Circle()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.white)
                                
                                Image(systemName: "xmark")
                                    .imageScale(.small)
                                    .frame(width: 5, height: 5)
                                    .foregroundColor(.black)
                            }
                            .offset(x: 55, y: -25)
                        }
                        
                    }
                }
                .padding(.horizontal, 5)
            }
        }
    }
    
    var emptyState: some View {
        VStack {
            Text("Incredible!\nRick has no information on this")
                .font(
                    .system(
                        size: 18,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .multilineTextAlignment(.center)
        }
        .frame(maxHeight: .infinity)
    }
    
    var navigationPagesButtons: some View {
        HStack {
            if shouldShowPrevPageButton {
                Spacer()
                Button {
                    viewModel.currentPage -= 1
                    viewModel.updateCharactersList(.prev)
                } label: {
                    Text("Previous")
                        .font(
                            .system(
                                size: 20,
                                weight: .bold,
                                design: .rounded
                            )
                        )
                        .foregroundStyle(.secondaryRick)
                }
            }
            Spacer()
            if shouldShowNextPageButton {
                Button {
                    viewModel.currentPage += 1
                    viewModel.updateCharactersList(.next)
                } label: {
                    Text("Next")
                        .font(
                            .system(
                                size: 20,
                                weight: .bold,
                                design: .rounded
                            )
                        )
                        .foregroundStyle(.secondaryRick)
                }
                Spacer()
            }
        }
        .padding()
    }
}
// MARK: - Computed Properties
private extension CharactersView {
    
    var shouldShowNextPageButton: Bool {
        return viewModel.currentPage != viewModel.responseInfo?.pages
    }
    
    var shouldShowPrevPageButton: Bool {
        return viewModel.currentPage != 1
    }
}

#Preview {
    CharactersView(
        viewModel: .init(
            omrInteractor: Managers.getInteractor(for: .sandbox)
        )
    )
}
