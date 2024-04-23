//
//  OhMyRickMainViewModel.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 17/4/24.
//

import Foundation
import Combine

class CharactersViewModel: ObservableObject {
    
    var networkManager: NetworkManagerProtocol
    
    var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var networkError: Bool = false
    
    @Published var currentPage: Int = 1
    
    @Published var responseInfo: Info? = nil
    
    @Published var characters: [Character] = []
    
    @Published var filterParameters: [String: String?] = [:] {
        didSet {
            updateCharactersList()
        }
    }
    
    @Published var selectedGender: CharacterGender? = nil
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func updateCharactersList(_ goToPage: CharacterPages? = nil) {
        print("Filters \(filterParameters)")
        if filterParameters["gender"] == nil, filterParameters["name"] == nil {
            getAllCharacters(goToPage)
        } else {
            getFilteredCharacters(goToPage)
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
    
    func getFilteredCharacters(_ goToPage: CharacterPages? = nil) {
        var nextPage: String? = nil
        if let nextPageURL = goToPage?.getPageUrl(infoResponse: responseInfo) {
            nextPage = nextPageURL
        }
        
        networkManager.getFilteredCharacters(filterParameters: filterParameters, nextPage: nextPage)
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
