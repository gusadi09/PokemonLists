//
//  MyPokemonView.swift
//  PokemonLists
//
//  Created by Gus Adi on 13/09/23.
//

import SwiftUI

struct MyPokemonView: View {
    
    @StateObject var viewModel = MyPokemonViewModel()
    
    var body: some View {
#if os(macOS)
        
        SplitView()
            .environmentObject(viewModel)
        
#elseif os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            SplitView()
                .environmentObject(viewModel)
        } else {
            StackView()
                .environmentObject(viewModel)
        }
#endif
    }
}

extension MyPokemonView {
    struct SplitView: View {
        
        @EnvironmentObject var viewModel: MyPokemonViewModel
        
        @Environment(\.colorScheme) var scheme
        
        var body: some View {
#if os(macOS)
            
            NavigationSplitView {
                VStack {
                    List(viewModel.savedList, id: \.uid, selection: $viewModel.uid) { item in
                        (
                            Text("\(item.name.orEmpty()) ")
                            +
                            Text("(\(item.rootParent.orEmpty()))")
                                .foregroundColor(.gray)
                        )
                        .tag(item.uid)
                        .onTapGesture {
                            self.viewModel.nickname = item.name.orEmpty()
                            self.viewModel.id = UInt(item.id)
                        }
                    }
                    .listStyle(.inset(alternatesRowBackgrounds: true))
                }
                .navigationTitle(LocalizableText.myPokemonTitle)
                .onAppear {
                    viewModel.getAllPokemon()
                }
            } detail: {
                if viewModel.firstItem() == nil {
                    EmptyView()
                } else {
                    PokemonDetailView(
                        id: $viewModel.id,
                        uid: self.viewModel.uid ?? UUID(),
                        isFromMine: true
                    )
                }
            }
            
#elseif os(iOS)
            NavigationSplitView {
                VStack {
                    List(viewModel.savedList, id: \.name, selection: $viewModel.uid) { item in
                        
                        (
                            Text("\(item.name.orEmpty()) ")
                            +
                            Text("(\(item.rootParent.orEmpty()))")
                                .foregroundColor(.gray)
                        )
                        .tag(item.uid)
                        .onTapGesture {
                            self.viewModel.nickname = item.name.orEmpty()
                            self.viewModel.id = UInt(item.id)
                        }
                    }
                    .listStyle(.inset)
                    
                }
                .onAppear {
                    viewModel.getAllPokemon()
                }
                .navigationTitle(LocalizableText.myPokemonTitle)
            } detail: {
                if viewModel.firstItem() == nil {
                    EmptyView()
                } else {
                    PokemonDetailView(
                        id: $viewModel.id,
                        uid: self.viewModel.uid ?? UUID(),
                        isFromMine: true
                    )
                }
            }
#endif
        }
    }
    
    struct StackView: View {
        
        @EnvironmentObject var viewModel: MyPokemonViewModel
        
        var body: some View {
            VStack {
                List(viewModel.savedList, id: \.name, selection: $viewModel.id) { item in
                    
                    NavigationLink {
                        PokemonDetailView(id: $viewModel.id, uid: item.uid ?? UUID(), isFromMine: true)
                    } label: {
                        Text("\(item.name.orEmpty()) ")
                        +
                        Text("(\(item.rootParent.orEmpty()))")
                            .foregroundColor(.gray)
                    }
                    .tag(UInt(item.id))
                    
                }
                .onAppear {
                    viewModel.getAllPokemon()
                }
                
            }
            .navigationTitle(LocalizableText.myPokemonTitle)
        }
    }
}

struct MyPokemonView_Previews: PreviewProvider {
    static var previews: some View {
        MyPokemonView()
    }
}
