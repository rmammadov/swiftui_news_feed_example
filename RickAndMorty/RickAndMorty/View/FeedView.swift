//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Rahman Mammadov on 29.09.23.
//

import SwiftUI

struct FeedView: View {
    
    @ObservedObject var viewModel: FeedViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.getItems()) { feedItem in
                    VStack {
                        AsyncImage(url: URL(string: feedItem.image ?? "")) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: .infinity)
                        .aspectRatio(contentMode: .fit)
                        
                        Spacer()
                        
                        Text(feedItem.name ?? "")
                            .font(.system(size: 16))
                    }
                    .onAppear() {
                        self.onItemAppear(id: feedItem.id)
                    }
                }
            }
        }
        .navigationTitle("title_feed")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .overlay() {
            if viewModel.getStatus() == .loading {
                LoadingView()
            }
        }
        .refreshable {
            refresh()
        }

    }
}

extension FeedView {
    
    func onItemAppear(id: Int) {
        viewModel.requestMoreItemsIfNeeded(itemId: id)
    }
    
    func refresh() {
        viewModel.requestItems()
    }
}

#Preview {
    FeedView(viewModel: FeedViewModel())
}

