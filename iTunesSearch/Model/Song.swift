//
//  Song.swift
//  iTunesSearch
//
//  Created by 이혜수 on 2022/07/04.
//

import Foundation

struct Song {
    let name: String
    let artist: String
}

extension Song {
    static let samples = [
        Song(name: "Can't Stop", artist: "Red Hot Chili Peppers"),
        Song(name: "Great Balls of Fire", artist: "Miles Teller")
    ]
}
