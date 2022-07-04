//
//  SearchViewReactor.swift
//  iTunesSearch
//
//  Created by 이혜수 on 2022/07/04.
//

import Foundation

import ReactorKit

final class SearchViewReactor: Reactor {
    enum Action: Equatable {
        case updateQuery(String?)
    }

    enum Mutation {
        case setSongs([Song])
        case setIsLoading(Bool)
    }

    struct State {
        var songs: [Song] = []
        var isLoading: Bool = false
    }

    let initialState: State = State()

    var itunesService = ITunesService()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateQuery(query):
            return .concat([
                .just(.setIsLoading(true)),
                self.itunesService.search(query: query)
                    .map { .setSongs($0) },
                .just(.setIsLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setSongs(songs):
            newState.songs = songs

        case let .setIsLoading(isLoading):
            newState.isLoading = isLoading
        }

        return newState
    }
}