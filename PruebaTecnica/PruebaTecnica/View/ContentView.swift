//
//  ContentView.swift
//  PruebaTecnica
//
//  Created by Eibar Tzintzun on 27/04/25.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @StateObject private var viewModel = CharacterViewModel(apiManager: APIManager())
    @State private var showFavoritesView = false
    @State private var favoritesCharacters = [CharacterEntity]()
    
    var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .success(data: let data):
                List {
                    ForEach(data, id: \.id) { item in
                        HStack {
                            KFImage(URL(string: item.imageUrl ?? "") ?? URL(string: ""))
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(.rect(cornerRadius: 16))
                            Text(item.name ?? "")
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.updateCharacter(entity: item)
                            }) {
                                Image(systemName: item.isFavorite ? "star.fill" : "star")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.orange)
                            }
                        }
                    }
                }
                .navigationTitle("Personajes")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Mis favoritos") {
                            favoritesCharacters = viewModel.getFavoritesCharacters()
                            showFavoritesView.toggle()
                        }
                    }
                }
                .navigationDestination(isPresented: $showFavoritesView) {
                    FavoritesView(favoritesCharacters: self.favoritesCharacters)
                }
            case .loading:
                ProgressView()
            default:
                EmptyView()
            }
        }
        .alert("Error", isPresented: $viewModel.hasError, presenting: viewModel.state) { _ in
        } message: { detail in
            if case let .failed(error) = detail {
                Text(error)
            }
        }
    }
}

#Preview {
    ContentView()
}
