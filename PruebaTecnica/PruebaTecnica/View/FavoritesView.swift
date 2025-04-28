//
//  FavoritesView.swift
//  PruebaTecnica
//
//  Created by Eibar Tzintzun on 28/04/25.
//

import SwiftUI
import Kingfisher

struct FavoritesView: View {
    var favoritesCharacters: [CharacterEntity]
    
    var body: some View {
        if favoritesCharacters.isEmpty {
            Text("Aún no has agregado personajes favoritos.")
        } else {
            List {
                ForEach(favoritesCharacters, id: \.id) { item in
                    HStack {
                        KFImage(URL(string: item.imageUrl ?? "") ?? URL(string: ""))
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(.rect(cornerRadius: 16))
                        Text(item.name ?? "")
                    }
                }
            }
        }
    }
}

#Preview {
    FavoritesView(favoritesCharacters: [])
}
