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
        
        var body: some View {
            #if os(macOS)
            
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
                        List {
                            ForEach(viewModel.phase.resultValue ?? [], id: \.name) { item in
                                NavigationLink {
                                    Text(item.name.orEmpty())
                                } label: {
                                    Text(item.name.orEmpty())
                                }
                                
                            }
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
                    Text((viewModel.firstItem()?.name).orEmpty())
                }
            }
            
            #elseif os(iOS)
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
                        List {
                            ForEach(viewModel.phase.resultValue ?? [], id: \.name) { item in
                                NavigationLink {
                                    Text(item.name.orEmpty())
                                } label: {
                                    Text(item.name.orEmpty())
                                }
                            }
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
            } detail: {
                if viewModel.firstItem() == nil {
                    EmptyView()
                } else {
                    Text((viewModel.firstItem()?.name).orEmpty())
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
                        List {
                            ForEach(viewModel.phase.resultValue ?? [], id: \.name) { item in
                                NavigationLink {
                                    Text(item.name.orEmpty())
                                } label: {
                                    Text(item.name.orEmpty())
                                }
                            }
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
