//
//  File.swift
//  
//
//  Created by Gus Adi on 14/09/23.
//

import Foundation
import Moya
@testable import PokemonDataSource

final class PokemonStubRepository: PokemonRepository {
    
    private let remote: PokemonRemoteDataSource
    private let local: PokemonLocalDataSource
    private let endpointClosureError = { (target: PokemonTargetType) -> Endpoint in
        return Endpoint(
            url: URL(target: target).absoluteString,
            sampleResponseClosure: {
                .networkResponse(
                    404,
                    ErrorResponse(status: 404, message: "Not Found").toData()
                )
            },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
    }
    
    private let isErrorRemote: Bool
    
    init(
        remote: PokemonRemoteDataSource = PokemonDefaultRemoteDataSource(
            provider: MoyaProvider<PokemonTargetType>(
                stubClosure: MoyaProvider.delayedStub(1.0),
                plugins: [NetworkLoggerPlugin()]
            )
        ),
        local: PokemonLocalDataSource = PokemonDefaultLocalDataSource(),
        isErrorRemote: Bool
    ) {
        self.remote = isErrorRemote ?
        PokemonDefaultRemoteDataSource(
            provider: MoyaProvider<PokemonTargetType>(
                endpointClosure: endpointClosureError,
                stubClosure: MoyaProvider.delayedStub(1.0)
            )
        ) :
        remote
        self.isErrorRemote = isErrorRemote
        self.local = local
    }
    
    func provideGetPokemonList(on offset: UInt) async throws -> PKPokemonList {
        try await self.remote.getPokemonList(offset: offset)
    }
    
    func provideGetPokemonDetail(for id: UInt) async throws -> PKPokemonDetail {
        try await self.remote.getPokemonDetail(id: id)
    }
    
    func provideCatchPokemon(with id: UInt, nickname: String, root: String) throws {
        try self.local.addPokemon(id: id, name: nickname, root: root)
    }
    
    func provideRenamePokemon(from old: String, to new: String) throws {
        try self.local.renamePokemon(oldName: old, newName: new)
    }
    
    func provideLoadMyPokemon() throws -> [PokemonDataSource.Pokemon] {
        try self.local.loadAllPokemon()
    }
    
    func provideDeleteSpesificPokemon(at name: String) throws {
        try self.local.deleteSpesificPokemon(name: name)
    }
    
    func provideDeleteAllPokemon() throws {
        try self.local.deleteAllPokemon()
    }
    
    func provideGetSpesificPokemon(uid: UUID) throws -> Pokemon? {
        try self.local.getSpesificPokemon(uid: uid)
    }
}
