//
//  PokemonDetailView.swift
//  PokemonLists
//
//  Created by Gus Adi on 13/09/23.
//

import PokemonExtensions
import SwiftUI

struct PokemonDetailView: View {
    
    let isFromMine: Bool
    let uid: UUID
    @Binding var id: UInt?
    
    @StateObject var viewModel = PokemonDetailViewModel()
    
    @Environment(\.colorScheme) var scheme
    @Environment(\.dismiss) var dismiss
    
    init(id: Binding<UInt?>, uid: UUID = UUID(), isFromMine: Bool) {
        self._id = id
        self.uid = uid
        self.isFromMine = isFromMine
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
                        VStack(alignment: .leading, spacing: 12) {
                            
                            HStack {
                                Spacer()
                                    .alert(isPresented: $viewModel.isSuccessToSave, content: {
                                        Alert(
                                            title: Text(LocalizableText.detailSuccessSave),
                                            message: Text(LocalizableText.detailSuccessSubtitle),
                                            dismissButton: .default(Text("OK"), action: {
                                                #if os(iOS)
                                                dismiss()
                                                #endif
                                            })
                                        )
                                    })
                                
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
                                .alert(isPresented: $viewModel.isRanAway) {
                                    Alert(
                                        title: Text(LocalizableText.detailRanAway),
                                        message: Text(LocalizableText.detailPokemonFailCaught),
                                        dismissButton: .default(Text("OK"))
                                    )
                                }
                                
                                Spacer()
                                    
                            }
                            .padding(.top)

                            HStack {
                                Spacer()
                                    .alert(LocalizableText.detailCaught, isPresented: $viewModel.showSavePrompt
                                    ) {
                                        TextField(LocalizableText.detailCaughtPlaceholder, text: $viewModel.nickname)
                                        Button("OK", action: {
                                            viewModel.catchPokemon(
                                                id: id.orZero(),
                                                name: viewModel.nickname.isEmpty ? (viewModel.phase.resultValue?.name).orEmpty() : viewModel.nickname,
                                                root: (viewModel.phase.resultValue?.name).orEmpty()
                                            )

                                        })
                                    } message: {
                                        Text(LocalizableText.detailCaughtSubtitle)
                                    }
                                
                                if isFromMine {
                                    (
                                        Text(viewModel.localName)
                                        .font(.title)
                                        .fontWeight(.bold)
                                    +
                                    Text(" (\((viewModel.phase.resultValue?.name).orEmpty()))")
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                    )
                                        .padding(.horizontal)
                                        .id(1)
                                        
                                } else {
                                    Text((viewModel.phase.resultValue?.name).orEmpty())
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding(.horizontal)
                                        .id(1)
                                }
                                
                                Spacer()
                                    .alert(LocalizableText.detailRename, isPresented: $viewModel.isShowRename
                                    ) {
                                        TextField(LocalizableText.detailCaughtPlaceholder, text: $viewModel.rename)
                                        
                                        Button("Cancel", action: {})
                                        
                                        Button("OK", action: {
                                            viewModel.renamePokemon(currentName: viewModel.localName, to: viewModel.rename)
                                            viewModel.getSpesific(uid: uid)
                                        })
                                        
                                    } message: {
                                        Text(LocalizableText.detailRenameSubtitle)
                                    }
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
            
            HStack {
                if !isFromMine {
                    Button {
                        viewModel.tryToCatch()
                    } label: {
                        HStack {
                            Spacer()
                            
                            Text(isFromMine ? LocalizableText.detailRelease : LocalizableText.detailCatch)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .disabled(viewModel.phase == .loading)
                        .padding(.horizontal)
                        .frame(height: 45)
                        .background(
                            Capsule()
                                .foregroundColor(.blue.opacity(viewModel.phase == .loading ? 0.7 : 1))
                        )
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        
                    }
                }
                
                if isFromMine {
                    Button {
                        viewModel.isShowRename.toggle()
                    } label: {
                        HStack {
                            Spacer()
                            
                            Text(LocalizableText.detailRename)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .disabled(viewModel.phase == .loading)
                        .padding(.horizontal)
                        .frame(height: 45)
                        .background(
                            Capsule()
                                .foregroundColor(.blue.opacity(viewModel.phase == .loading ? 0.7 : 1))
                        )
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                    }
                    .buttonStyle(.plain)
                }
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
            if isFromMine {
                Task {
                    viewModel.getSpesific(uid: uid)
                    await viewModel.getPokemonDetail(for: id.orZero())
                }
            } else {
                Task {
                    await viewModel.getPokemonDetail(for: id.orZero())
                }
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
        PokemonDetailView(id: .constant(1), isFromMine: false)
    }
}
