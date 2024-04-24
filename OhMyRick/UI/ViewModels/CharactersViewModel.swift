//
//  OhMyRickMainViewModel.swift
//  OhMyRick
//
//  Created by Alessandro Bizzoni on 17/4/24.
//

import Foundation
import Combine

class CharactersViewModel: ObservableObject {
    
    var omrInteractor: OMRInteractorProtocol
    
    var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @Published var networkError: Bool = false
    
    @Published var errorMessg: String = ""
    
    @Published var currentPage: Int = 1
    
    @Published var responseInfo: DomainPageInfo? = nil
    
    @Published var characters: [DomainCharacter] = []
    
    @Published var filterParameters: [String: String?] = [:] {
        didSet {
            updateCharactersList()
        }
    }
    
    @Published var selectedGender: CharacterGender? = nil
    
    init(omrInteractor: OMRInteractorProtocol) {
        self.omrInteractor = omrInteractor
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
        
        omrInteractor.getCharacters(nextPage: nextPage)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Request done")
                    
                case .failure(let error):
                    print("[DEBUG ERROR] \(error.localizedDescription)")
                    self.networkError = true
                    self.errorMessg = error.localizedDescription
                }
            } receiveValue: { newValue in
                self.responseInfo = newValue.pageInfo
                self.characters = newValue.characters
                self.networkError = false
            }
            .store(in: &cancellable)
    }
    
    func getFilteredCharacters(_ goToPage: CharacterPages? = nil) {
        var nextPage: String? = nil
        if let nextPageURL = goToPage?.getPageUrl(infoResponse: responseInfo) {
            nextPage = nextPageURL
        }
        
        omrInteractor.getFilteredCharacters(filterParameters: filterParameters, nextPage: nextPage)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Request done")
                    
                case .failure(let error):
                    print("[DEBUG ERROR] \(error.localizedDescription)")
                    self.networkError = true
                    self.errorMessg = error.localizedDescription
                }
            } receiveValue: { newValue in
                self.responseInfo = newValue.pageInfo
                self.characters = newValue.characters
                self.networkError = false
            }
            .store(in: &cancellable)
    }
}
