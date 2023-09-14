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
    
    @Environment(\.colorScheme) var scheme
    
    init(id: UInt) {
        self.id = id
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.phase == .loading {
                Spacer()
                
                ProgressView()
                    .progressViewStyle(.circular)
                
                Spacer()
            } else {
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Spacer()
                                
                                Text((viewModel.phase.resultValue?.name).orEmpty())
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                
                                Spacer()
                            }
                            
                            Capsule()
                                .frame(height: 1)
                                .padding(.horizontal)
                                
                            VStack(alignment: .leading, spacing: 10) {
                                LazyVGrid(
                                    columns: Array(
                                        repeating: GridItem(
                                            .fixed(115),
                                            spacing: 10
                                        ),
                                        count: 3
                                    ),
                                    alignment: .leading,
                                    spacing: 15
                                ) {
                                    ForEach(
                                        viewModel.phase.resultValue?.types ?? [],
                                        id: \.type?.name
                                    ) { item in
                                        Text((item.type?.name).orEmpty())
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .frame(width: 115, height: 30)
                                            .background(.thinMaterial)
                                            .clipShape(Capsule())
                                    }
                                }
                                .padding(.bottom, 5)
                                
                                HStack(spacing: 15) {
                                    Text("Weight: ")
                                        .fontWeight(.semibold)
                                    +
                                    Text("\((viewModel.phase.resultValue?.weight).orZero())")
                                    
                                    Text("Height: ")
                                        .fontWeight(.semibold)
                                    +
                                    Text("\((viewModel.phase.resultValue?.height).orZero())")
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            
                            Capsule()
                                .frame(height: 1)
                                .padding(.horizontal)
                                .id(1)
                            
                            LazyVStack(alignment: .leading, spacing: 8) {
                                Text("Moves")
                                    .fontWeight(.bold)
                                    .font(.title3)
                                    .padding(.horizontal)
                                 
                                LazyVGrid(
                                    columns: Array(
                                        repeating: GridItem(
                                            .fixed(115),
                                            spacing: 10
                                        ),
                                        count: 3
                                    ),
                                    spacing: 15
                                ) {
                                    ForEach(
                                        viewModel.movesArray(),
                                        id: \.move?.name
                                    ) { item in
                                        Text((item.move?.name).orEmpty())
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .frame(width: 115, height: 30)
                                            .background(.thinMaterial)
                                            .clipShape(Capsule())
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top, 10)
                                .padding(.bottom, 5)
                                
                                if (viewModel.phase.resultValue?.moves ?? []).count > 9 {
                                    Button {
                                        viewModel.showMoreMoveToggle()
                                        
                                        withAnimation(.spring()) {
                                            if !viewModel.showMoreMoves {
                                                proxy.scrollTo(1)
                                            }
                                        }
                                        
                                    } label: {
                                        HStack {
                                            Spacer()
                                            
                                            Text(viewModel.showMoreMoves ? "Show Less" : "Show More")
                                                .font(.callout)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                        }
                                    }
                                }
                                
                            }
                            .padding(.vertical, 10)
                            
                        }
                        .padding(.bottom)
                    }
                }
            }
            
            Button {
                
            } label: {
                HStack {
                    Spacer()
                    
                    Text("Catch")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .frame(height: 45)
                .background(
                    Capsule()
                        .foregroundColor(.blue)
                )
                .padding(.vertical, 10)
                .padding(.horizontal)
            }
            .background(
                Rectangle()
                    .foregroundColor(scheme == .dark ? .black : .white)
                    .edgesIgnoringSafeArea(.all)
                    .shadow(
                        color: .gray.opacity(scheme == .dark ? 0.6 : 0.4),
                        radius: 10,
                        x: 8,
                        y: 0
                    )
            )

        }
        .onAppear {
            Task {
                await viewModel.getPokemonDetail(for: id)
            }
        }
        .background(scheme == .dark ? Color.black : Color.white)
        .buttonStyle(.plain)
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(id: 1)
    }
}
