//
//  ArtistResult.swift
//  ArtistList
//
//  Created by Vitor Costa on 19/11/24.
//

import Foundation

struct ArtistResult: Decodable {
    let results: [Artist]
}

struct Artist: Decodable {
    let id: Int
    let title: String
    let resource_url: String
}

struct ArtistDetail: Decodable {
    let name: String
    let profile: String
    let releases_url: String
    let members: [GroupMember]?
}

struct GroupMember: Decodable {
    let id: Int
    let name: String
    let resource_url: String
    let active: Bool
}

struct ReleaseResult: Decodable {
    let releases: [Release]
}

struct Release: Decodable {
    let id: Int
    let title: String
    let year: Int
    let thumb: String
}
