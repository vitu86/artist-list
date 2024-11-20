//
//  DataFetcher.swift
//  ArtistList
//
//  Created by Vitor Costa on 19/11/24.
//

import Foundation

struct DataFetcher {
    func getArtistList(with searchText: String) async -> ArtistResult? {
        guard let request = Credentials.getArtistSearchUrlRequest(using: searchText) else { return nil }
        do {
            let result = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(ArtistResult.self, from: result.0)
            return decoded
        } catch {
            return nil
        }
    }
    
    func getArtistDetail(_ resourceUrl: String) async -> ArtistDetail? {
        guard let request = Credentials.getArtistDetailUrlRequest(with: resourceUrl) else { return nil }
        do {
            let result = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(ArtistDetail.self, from: result.0)
            return decoded
        } catch {
            return nil
        }
    }
    
    func getReleases(_ releasesUrl: String) async -> ReleaseResult? {
        guard let request = Credentials.getReleasesUrlRequest(with: releasesUrl) else { return nil }
        do {
            let result = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(ReleaseResult.self, from: result.0)
            return decoded
        } catch {
            return nil
        }
    }
}

fileprivate struct Credentials {
    private static let token = "cBeZFgtAwwmJrSsPqbLOQQMSrYVEpcXxJVaQBGKX"
    private static let searchBaseUrl = "https://api.discogs.com/database/search?"
    
    private static func getRequest(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("Discogs token=\(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    static func getArtistSearchUrlRequest(using search: String) -> URLRequest? {
        guard let url = URL(string: searchBaseUrl + "q=\(search)&type=artist") else {
            return nil
        }
        return getRequest(url)
    }
    
    static func getArtistDetailUrlRequest(with resourceUrl: String) -> URLRequest? {
        guard let url = URL(string: resourceUrl) else {
            return nil
        }
        return getRequest(url)
    }
    
    static func getReleasesUrlRequest(with releasesUrl: String) -> URLRequest? {
        guard let url = URL(string: releasesUrl) else {
            return nil
        }
        return getRequest(url)
    }
}
