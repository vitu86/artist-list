//
//  HomeView.swift
//  ArtistList
//
//  Created by Vitor Costa on 19/11/24.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel = HomeViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ViewThatFits {
                switch viewModel.currentState {
                case .empty: Text("Use search bar to look for your idol")
                case .error(let errorMessage): Text(errorMessage)
                case .loading: ProgressView()
                case .success(let artistList): buildSuccessView(viewData: artistList)
                }
            }
            .navigationTitle(viewModel.homeViewTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        viewModel.reset()
                    }, label: {
                        Image(systemName: "arrow.counterclockwise")
                    })
                }
            }
        }
        .searchable(
            text: $searchText,
            prompt: "Artist name"
        )
        .searchPresentationToolbarBehavior(.avoidHidingContent)
        .onSubmit(of: .search) {
            viewModel.getArtistList(searchText)
        }
    }
    
    private func buildSuccessView(viewData: ViewData) -> some View {
        List(viewData.items) { item in
            NavigationLink {
                ArtistDetailView(artistUrl: item.resourceUrl)
            } label: {
                Text(item.title)
            }
        }
    }
}

extension HomeView {
    struct ViewData {
        let items: [ViewDataItem]
    }
    
    struct ViewDataItem: Identifiable {
        let id: Int
        let title: String
        let resourceUrl: String
    }
}

#Preview {
    HomeView()
}
