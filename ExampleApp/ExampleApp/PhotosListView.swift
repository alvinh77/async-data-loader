//
//  PhotosListView.swift
//  ExampleApp
//
//  Created by Alvin He on 23/2/2023.
//

import AsyncDataLoader
import SwiftUI

struct PhotosListView: View {
    let asyncDataLoader: AsyncDataLoaderProtocol

    let data = (1...300).map {
        "https://picsum.photos/id/\($0)/200/200"
    }

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(data, id: \.self) { item in
                    AsyncImage(url: item, asyncDataLoader: asyncDataLoader)
                }
            }
        }
    }
}

struct AsyncImage: View {
    let url: String
    let asyncDataLoader: AsyncDataLoaderProtocol
    @State var status: ImageStatus = .loading

    var body: some View {
        elementView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fill)
            .background(Color.gray)
            .task {
                do {
                    let data = try await asyncDataLoader.data(from: url)
                    guard let image = UIImage(data: data) else {
                        status = .error
                        return
                    }
                    status = .loaded(image)
                } catch {
                    guard !Task.isCancelled else {
                        print("Cancelled: \(url)")
                        return
                    }
                    print("Error: \(url), \(error)")
                    status = .error
                }
            }
    }

    @ViewBuilder
    private var elementView: some View {
        switch status {
        case .loading:
            ProgressView()
        case .loaded(let uIImage):
            Image(uiImage: uIImage)
                .resizable()
        case .error:
            Image(systemName: "exclamationmark.arrow.triangle.2.circlepath")
                .foregroundStyle(.white)
        }
    }
}

enum ImageStatus {
    case loading
    case loaded(UIImage)
    case error
}
