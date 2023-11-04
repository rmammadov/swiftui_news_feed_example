//
//  FeedViewModel.swift
//  RickAndMorty
//
//  Created by Rahman Mammadov on 29.09.23.
//

import Foundation
import Combine

enum RequestStatus {
    case success, fail, loading
}

protocol FeedViewModelDataRequestProtocol {
    func requestItems()
    func requestMoreItemsIfNeeded(itemId: Int)
}

protocol FeedViewModelAccessDataProtocol {
    func getData() -> CharactersDataModel?
    func getItems() -> [CharacterItem]
    func getStatus() -> RequestStatus
}

class FeedViewModel: ObservableObject {
    @Published private var requestStatus: RequestStatus = .success
    @Published private var feedItems: [CharacterItem]? = []
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: Data
    private var data: CharactersDataModel?
    
    // MARK: Api service
    private let apiService: RickAndMortyApiCallsProtocol

    init(apiService: RickAndMortyApiCallsProtocol = RickAndMortyApiCalls()) {
        self.apiService = apiService
        self.requestItems()
    }
    
    private func requestCharacters(url: String) {
        self.setStatus(requestStatus: .loading)
        
        self.apiService.getCharacters(url: url).sink(receiveCompletion: { response in
            switch response {
            case .finished: break
            case .failure(_):
                self.setStatus(requestStatus: .fail)
            }
        }, receiveValue: { response in
            self.setData(data: response.value)
        }).store(in: &cancellables)
    }
    
    private func setData(data: CharactersDataModel) {
        self.data = data
        
        self.addItems(characters: data.results!)
        self.setStatus(requestStatus: .success)
    }
    
    private func addItems(characters: [CharacterItem]) {
        self.feedItems?.append(contentsOf: characters)
    }
    
    private func setStatus(requestStatus: RequestStatus) {
        self.requestStatus = requestStatus
    }
    
    /// Determines whether we have meet the threshold for requesting more items.
    private func lastItemAppeared(id: Int) -> Bool {
        return  id == feedItems?.last?.id
    }
    
    /// Determines whether there is more data to load.
    private func morePagesRemaining() -> Bool {
        return !(data?.info?.next ?? "").isEmpty
    }
}

extension FeedViewModel: FeedViewModelDataRequestProtocol {
    /// Request inital items
    func requestItems() {
        self.requestCharacters(url: Constants.URL_BASE_RICKANDMORTY_CHARACTERS_API)
    }
    
    /// Used for infinite scrolling. Only requests more items if pagination criteria is met.
    func requestMoreItemsIfNeeded(itemId: Int) {
        if lastItemAppeared(id: itemId) &&
            morePagesRemaining() {
            // Request next page
            guard let url = data?.info?.next else { return }
            requestCharacters(url: url)
        }
    }
}

extension FeedViewModel: FeedViewModelAccessDataProtocol {
    func getData() -> CharactersDataModel? {
        return data
    }
    
    func getItems() -> [CharacterItem] {
        return self.feedItems ?? []
    }
    
    func getStatus() -> RequestStatus {
        return self.requestStatus
    }
}
