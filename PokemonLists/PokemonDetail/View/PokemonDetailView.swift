//
//  PokemonDetailView.swift
//  PokemonLists
//
//  Created by Gus Adi on 13/09/23.
//

import SwiftUI

struct PokemonDetailView: View {
    
    let id: UInt
    
    @ObservedObject var viewModel = PokemonDetailViewModel()
    
    init(id: UInt) {
        self.id = id
    }
    
    var body: some View {
        VStack {
            if viewModel.phase == .loading {
                Spacer()
                
                ProgressView()
                    .progressViewStyle(.circular)
                
                Spacer()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    Text((viewModel.phase.resultValue?.name).orEmpty())
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.getPokemonDetail(for: id)
            }
        }
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(id: 1)
    }
}
