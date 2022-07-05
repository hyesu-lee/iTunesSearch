//
//  Song.swift
//  iTunesSearch
//
//  Created by 이혜수 on 2022/07/04.
//

import Foundation

struct Song: Decodable {
    let name: String
    let artist: String
    let previewURL: String

    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case artist = "artistName"
        case previewURL = "previewUrl"
    }
}

extension Song {
    static let samples = [
        Song(name: "Can't Stop", artist: "Red Hot Chili Peppers", previewURL: ""),
        Song(name: "Great Balls of Fire", artist: "Miles Teller", previewURL: "")
    ]
}
