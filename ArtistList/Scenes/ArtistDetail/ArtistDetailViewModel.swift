//
//  ArtistDetailViewModel.swift
//  ArtistList
//
//  Created by Vitor Costa on 19/11/24.
//

import Foundation

@Observable
final class ArtistDetailViewModel {
    private let dataFetcher: DataFetcher

    private(set) var currentState: ArtistDetailState = .loading
    
    var artistDetailViewTitle: String {
        switch currentState {
        case .loading: "Loading"
        case .error: "Error getting info"
        case .success(let artistDetail): artistDetail.title
        }
    }
    
    init(dataFetcher: DataFetcher = DataFetcher()) {
        self.dataFetcher = dataFetcher
    }
    
    func loadArtistDetail(_ resourceUrl: String) {
        currentState = .loading
        Task {
            if let result = await dataFetcher.getArtistDetail(resourceUrl) {
                currentState = .success(.init(result))
            } else {
                currentState = .error
            }
        }
    }
}

enum ArtistDetailState {
    case loading
    case error
    case success(ArtistDetailView.ViewData)
}

fileprivate extension ArtistDetailView.ViewData {
    init(_ model: ArtistDetail) {
        info = model.profile
        releasesUrl = model.releases_url
        title = model.name
        members = model.members?.map {
            .init(
                id: $0.id, 
                title: $0.name,
                active: $0.active,
                resourcesUrl: $0.resource_url
            )
        } ?? []
    }
}
