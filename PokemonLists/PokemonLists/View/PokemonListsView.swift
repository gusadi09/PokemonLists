//
//  PokemonListsView.swift
//  PokemonLists
//
//  Created by Gus Adi on 13/09/23.
//

import PokemonExtensions
import SwiftUI

struct PokemonListsView: View {
    
    @StateObject var viewModel = PokemonListsViewModel()
    
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

extension PokemonListsView {
    struct SplitView: View {
        
        @EnvironmentObject var viewModel: PokemonListsViewModel
        
        @Environment(\.colorScheme) var scheme
        
        var body: some View {
            #if os(macOS)
            TabView {
                NavigationSplitView {
                    VStack {
                        if viewModel.phase == .loading {
                            VStack {
                                Spacer()
                                
                                ProgressView()
                                    .progressViewStyle(.circular)
                                
                                Spacer()
                            }
                        } else {
                            List(viewModel.phase.resultValue ?? [], id: \.name, selection: $viewModel.selected) { item in
                                Text(item.name.orEmpty())
                                    .tag(viewModel.getIdOnly(for: item))
                            }
                            .listStyle(.inset(alternatesRowBackgrounds: true))
                        }
                        
                        HStack {
                            Button {
                                viewModel.decreaseOffset()
                            } label: {
                                Image(systemName: "chevron.left")
                            }
                            .disabled(!viewModel.isPrevAvailable)

                            Text("\(viewModel.currentOffset)")
                            
                            Button {
                                viewModel.increaseOffset()
                            } label: {
                                Image(systemName: "chevron.right")
                            }
                            .disabled(!viewModel.isNextAvailable)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .edgesIgnoringSafeArea(.all)
                    }
                    .navigationTitle(LocalizableText.listPokemonTitle)
                    .onAppear {
                        Task {
                            await viewModel.getPokemonList()
                        }
                    }
                } detail: {
                    if viewModel.firstItem() == nil {
                        EmptyView()
                    } else {
                        PokemonDetailView(
                            id: $viewModel.selected,
                            isFromMine: false
                        )
                    }
                }
                .tabItem {
                    Text("Wild Pokemon")
                }
                
                MyPokemonView()
                    .tabItem {
                        Text(LocalizableText.myPokemonTitle)
                    }
            }
            
            #elseif os(iOS)
            TabView {
                NavigationSplitView {
                    VStack {
                        if viewModel.phase == .loading {
                            VStack {
                                Spacer()
                                
                                ProgressView()
                                    .progressViewStyle(.circular)
                                
                                Spacer()
                            }
                        } else {
                            List(viewModel.phase.resultValue ?? [], id: \.name, selection: $viewModel.selected) { item in
                                
                                Text(item.name.orEmpty())
                                    .tag(viewModel.getIdOnly(for: item))
                            }
                            .listStyle(.inset)
                        }
                        
                        HStack {
                            Button {
                                viewModel.decreaseOffset()
                            } label: {
                                Image(systemName: "chevron.left")
                            }
                            .disabled(!viewModel.isPrevAvailable)

                            Text("\(viewModel.currentOffset)")
                            
                            Button {
                                viewModel.increaseOffset()
                            } label: {
                                Image(systemName: "chevron.right")
                            }
                            .disabled(!viewModel.isNextAvailable)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .edgesIgnoringSafeArea(.all)
                    }
                    .onAppear {
                        Task {
                            await viewModel.getPokemonList()
                        }
                    }
                    .navigationTitle(LocalizableText.listPokemonTitle)
                    .toolbar {
                        NavigationLink {
                            MyPokemonView()
                        } label: {
                            Text(LocalizableText.myPokemonTitle)
                        }
                    }
                } detail: {
                    if viewModel.firstItem() == nil {
                        EmptyView()
                    } else {
                        PokemonDetailView(
                            id: $viewModel.selected,
                            isFromMine: false
                        )
                    }
                }
                .tabItem {
                    Text("Wild Pokemon")
                }
                
                MyPokemonView()
                    .tabItem {
                        Text(LocalizableText.myPokemonTitle)
                    }
            }
            
            #endif
        }
    }
    
    struct StackView: View {
        
        @EnvironmentObject var viewModel: PokemonListsViewModel
        
        var body: some View {
            NavigationStack {
                VStack {
                    if viewModel.phase == .loading {
                        VStack {
                            Spacer()
                            
                            ProgressView()
                                .progressViewStyle(.circular)
                            
                            Spacer()
                        }
                    } else {
                        List(viewModel.phase.resultValue ?? [], id: \.name, selection: $viewModel.selected) { item in
                            
                            NavigationLink {
                                PokemonDetailView(id: $viewModel.selected, isFromMine: false)
                            } label: {
                                Text(item.name.orEmpty())
                                    
                            }
                            .tag(viewModel.getIdOnly(for: item))
                            
                        }
                    }
                    
                    HStack {
                        Button {
                            viewModel.decreaseOffset()
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        .disabled(!viewModel.isPrevAvailable)

                        Text("\(viewModel.currentOffset)")
                        
                        Button {
                            viewModel.increaseOffset()
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                        .disabled(!viewModel.isNextAvailable)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .edgesIgnoringSafeArea(.all)
                }
                .navigationTitle(LocalizableText.listPokemonTitle)
                .toolbar {
                    NavigationLink {
                        MyPokemonView()
                    } label: {
                        Text(LocalizableText.myPokemonTitle)
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.getPokemonList()
                }
            }
        }
    }
}

struct PokemonListsView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListsView()
    }
}
