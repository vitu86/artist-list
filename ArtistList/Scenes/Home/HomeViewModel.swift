//
//  HomeViewModel.swift
//  ArtistList
//
//  Created by Vitor Costa on 19/11/24.
//

import Foundation

@Observable
final class HomeViewModel {
    private let dataFetcher: DataFetcher
    
    private(set) var currentState: HomeState = .empty
    private(set) var homeViewTitle: String = "Artists List"
    
    init(dataFetcher: DataFetcher = DataFetcher()) {
        self.dataFetcher = dataFetcher
    }
    
    func getArtistList(_ search: String) {
        currentState = .loading
        Task {
            if let result = await dataFetcher.getArtistList(with: search) {
                currentState = .success(artistList: .init(result))
                homeViewTitle = "Artists with: \(search)"
            } else {
                currentState = .error(errorMessage: "Could not load info. Try again.")
                homeViewTitle = "Artists List"
            }
        }
    }
    
    func reset() {
        currentState = .empty
        homeViewTitle = "Artists List"
    }
}

enum HomeState {
    case empty
    case loading
    case error(errorMessage: String)
    case success(artistList: HomeView.ViewData)
}

fileprivate extension HomeView.ViewData {
    init(_ model: ArtistResult) {
        items = model.results.map {
            .init(id: $0.id, title: $0.title, resourceUrl: $0.resource_url)
        }
    }
}
