//
//  OhMyRickMainViewModel.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 17/4/24.
//

import Foundation
import Combine

class CharactersViewModel: ObservableObject {
    
    var networkManager = NetworkManager()
    
    var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var networkError: Bool = false
    
    @Published var currentPage: Int = 1
    
    @Published var responseInfo: Info? = nil
    
    @Published var characters: [Character] = [] {
        didSet {
            updateFilteredCharacters()
        }
    }
    
    @Published var filteredCharacters: [Character] = []
    
    @Published var filterParameters: [String: String?] = [
        "name": nil,
        "gender": nil
    ] {
        didSet {
            getFilteredCharacters()
        }
    }
    
    @Published var selectedGender: CharacterGender? = nil {
        didSet {
            updateFilteredCharacters()
        }
    }
    
    func getAllCharacters(_ goToPage: CharacterPages? = nil) {
        var nextPage: String? = nil
        if let nextPageURL = goToPage?.getPageUrl(infoResponse: responseInfo) {
            nextPage = nextPageURL
        }
        
        if let cachedValue = UserDefaults.standard.value(forKey: nextPage ?? "") as? Response {
            self.responseInfo = cachedValue.info
            self.characters = cachedValue.results
        } else {
            networkManager.getCharacters(nextPage: nextPage)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Request done")
                        
                    case .failure(let error):
                        print("[DEBUG ERROR] \(error.localizedDescription)")
                        self.networkError = true
                    }
                } receiveValue: { newValue in
                    self.responseInfo = newValue.info
                    self.characters = newValue.results
                }
                .store(in: &cancellable)
        }
    }
    
    func getFilteredCharacters() {
        networkManager.getFilteredCharacters(filterParameters: filterParameters)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Request done")
                    
                case .failure(let error):
                    print("[DEBUG ERROR] \(error.localizedDescription)")
                    self.networkError = true
                }
            } receiveValue: { newValue in
                self.responseInfo = newValue.info
                self.filteredCharacters = newValue.results
            }
            .store(in: &cancellable)
    }
    
    private func updateFilteredCharacters() {
        if let selectedGender = selectedGender {
            filteredCharacters = characters.filter { $0.gender == selectedGender }
        } else {
            filteredCharacters = characters
        }
    }
}
