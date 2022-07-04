//
//  APIResult.swift
//  iTunesSearch
//
//  Created by 이혜수 on 2022/07/04.
//

import Foundation

struct APIResult: Decodable {
    var results: [Song] = []
}
