//
//  PokemonListsApp.swift
//  PokemonLists
//
//  Created by Gus Adi on 13/09/23.
//

import SwiftUI

@main
struct PokemonListsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
