//
//  PokemonDetailView.swift
//  PokemonLists
//
//  Created by Gus Adi on 13/09/23.
//

import PokemonExtensions
import SwiftUI

struct PokemonDetailView: View {
    
    @Binding var id: UInt?
    
    @StateObject var viewModel = PokemonDetailViewModel()
    
    @Environment(\.colorScheme) var scheme
    
    init(id: Binding<UInt?>) {
        self._id = id
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
                                
                                AsyncImage(
                                    url: viewModel.picture()
                                ) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 300)
                                        .background(
                                            Color.white
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                } placeholder: {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                }
                                
                                Spacer()
                            }
                            .padding(.top)

                            HStack {
                                Spacer()
                                
                                Text((viewModel.phase.resultValue?.name).orEmpty())
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                    .id(1)
                                
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
                                    Text(LocalizableText.detailWeight)
                                        .fontWeight(.semibold)
                                    +
                                    Text("\((viewModel.phase.resultValue?.weight).orZero())")
                                    
                                    Text(LocalizableText.detailHeight)
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
                            
                            LazyVStack(alignment: .leading, spacing: 8) {
                                Text(LocalizableText.detailMoves)
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
                                            
                                            Text(viewModel.showText())
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
                    
                    Text(LocalizableText.detailCatch)
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
        .onAppear(perform: {
            Task {
                await viewModel.getPokemonDetail(for: id.orZero())
            }
        })
        .onChange(of: id, perform: { newValue in
            Task {
                await viewModel.getPokemonDetail(for: newValue.orZero())
            }
        })
        .background(scheme == .dark ? Color.black : Color.white)
        .buttonStyle(.plain)
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(id: .constant(1))
    }
}
