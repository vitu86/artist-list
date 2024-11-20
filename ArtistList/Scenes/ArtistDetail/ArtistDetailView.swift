//
//  ArtistDetailView.swift
//  ArtistList
//
//  Created by Vitor Costa on 19/11/24.
//

import SwiftUI

struct ArtistDetailView: View {
    @State private var viewModel: ArtistDetailViewModel = ArtistDetailViewModel()
    
    let artistUrl: String
    
    var body: some View {
        NavigationStack {
            ViewThatFits {
                switch viewModel.currentState {
                case .loading: ProgressView()
                case .success(let artistDetail): buildSuccessView(artistDetail)
                case .error:
                    VStack {
                        Image(systemName: "xmark")
                        Spacer().frame(maxHeight: 20)
                        Text("Could not load info")
                    }
                }
            }
            .navigationTitle(viewModel.artistDetailViewTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.editor)
            .onAppear {
                viewModel.loadArtistDetail(artistUrl)
            }
        }
    }
    
    private func buildSuccessView(_ item: ViewData) -> some View {
        ScrollView {
            VStack {
                Text("Profile:")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(item.info)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if !item.members.isEmpty {
                    Spacer(minLength: 20)
                    Divider().frame(height: 10)
                    Spacer(minLength: 20)
                    Text("Members:")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer(minLength: 20)
                    ForEach(item.members) { member in
                        NavigationLink {
                            ArtistDetailView(artistUrl: member.resourcesUrl)
                        } label: {
                            VStack {
                                HStack {
                                    Text(member.title)
                                        .font(.body)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Image(systemName: member.active ? "checkmark.circle" : "xmark.circle")
                                    Image(systemName: "chevron.right")
                                }
                                Divider().frame(height: 10)
                                Spacer()
                            }
                            .foregroundStyle(.black)
                        }
                    }
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink(destination: ReleasesView(releasesUrl: item.releasesUrl)) {
                    Text("Albums")
                }
            }
        }
    }
}

extension ArtistDetailView {
    struct ViewData {
        let info: String
        let title: String
        let releasesUrl: String
        let members: [ViewMembersItem]
    }
    
    struct ViewMembersItem: Identifiable {
        let id: Int
        let title: String
        let active: Bool
        let resourcesUrl: String
    }
}

#Preview {
    ArtistDetailView(
        artistUrl: ""
    )
}
