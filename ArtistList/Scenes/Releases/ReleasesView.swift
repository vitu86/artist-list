//
//  ReleasesView.swift
//  ArtistList
//
//  Created by Vitor Costa on 19/11/24.
//

import SwiftUI

struct ReleasesView: View {
    @State private var viewModel: ReleasesViewModel = ReleasesViewModel()
    
    let releasesUrl: String
    
    var body: some View {
        NavigationStack {
            ViewThatFits {
                switch viewModel.currentState {
                case .loading: ProgressView()
                case .success(let releaseData): buildSuccessView(viewData: releaseData)
                case .error:
                    VStack {
                        Image(systemName: "xmark")
                        Spacer().frame(maxHeight: 20)
                        Text("Could not load info")
                    }
                }
            }
            .navigationTitle(viewModel.releasesTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.editor)
        }
        .onAppear {
            viewModel.loadReleases(releasesUrl)
        }
    }
    
    private func buildSuccessView(viewData: ViewData) -> some View {
        List(viewData.items) { item in
            HStack {
                AsyncImage(url: URL(string: item.imageUrl)) { result in
                    if let image = result.image {
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 100, maxHeight: 100)
                    } else if result.error != nil {
                        EmptyView()
                    } else {
                        ProgressView()
                    }
                }
                VStack {
                    Text(item.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(String(item.year).replacingOccurrences(of: ".", with: ""))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

extension ReleasesView {
    struct ViewData {
        let items: [ViewDataItem]
    }
    
    struct ViewDataItem: Identifiable {
        let id: Int
        let title: String
        let year: String
        let imageUrl: String
    }
}

#Preview {
    ReleasesView(releasesUrl: "")
}
