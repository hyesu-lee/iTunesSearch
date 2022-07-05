//
//  Track.swift
//  iTunesSearch
//
//  Created by 이혜수 on 2022/07/04.
//

import Foundation

struct Track: Decodable {
    let name: String
    let artist: String
    let previewURL: String

    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case artist = "artistName"
        case previewURL = "previewUrl"
    }
}

extension Track {
    static let samples = [
        Track(name: "Can't Stop", artist: "Red Hot Chili Peppers", previewURL: ""),
        Track(name: "Great Balls of Fire", artist: "Miles Teller", previewURL: "")
    ]
}
