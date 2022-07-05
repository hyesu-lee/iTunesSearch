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
        case songSelected(IndexPath)
    }

    enum Mutation {
        case setSongs([Song])
        case setIsLoading(Bool)
        case setAudioURL(URL?)
    }

    struct State {
        var songs: [Song] = []
        var isLoading: Bool = false
        var audioURL: URL?
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

        case let .songSelected(indexPath):
            let url = self.currentState.songs[indexPath.row].previewURL
            return .concat([
                .just(.setIsLoading(true)),
                self.itunesService.download(url: url)
                    .map { .setAudioURL($0) },
                .just(.setIsLoading(false)),
                .just(.setAudioURL(nil))
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

        case let .setAudioURL(url):
            newState.audioURL = url
        }

        return newState
    }
}
