//
//  ReleasesViewModel.swift
//  ArtistList
//
//  Created by Vitor Costa on 19/11/24.
//

import Foundation

@Observable
final class ReleasesViewModel {
    private let dataFetcher: DataFetcher

    private(set) var currentState: ReleasesState = .loading
    
    var releasesTitle: String {
        switch currentState {
        case .loading: "Loading"
        case .error: "Error getting info"
        case .success: "Albums"
        }
    }
    
    init(dataFetcher: DataFetcher = DataFetcher()) {
        self.dataFetcher = dataFetcher
    }
    
    func loadReleases(_ releasesUrl: String) {
        currentState = .loading
        Task {
            if let result = await dataFetcher.getReleases(releasesUrl) {
                currentState = .success(.init(result))
            } else {
                currentState = .error
            }
        }
    }
}

enum ReleasesState {
    case loading
    case error
    case success(ReleasesView.ViewData)
}

fileprivate extension ReleasesView.ViewData {
    init(_ model: ReleaseResult) {
        items = model.releases.map {
            .init(
                id: $0.id,
                title: $0.title,
                year: String($0.year).replacingOccurrences(of: ".", with: ""),
                imageUrl: $0.thumb
            )
        }
        .sorted { $0.year > $1.year }
    }
}
