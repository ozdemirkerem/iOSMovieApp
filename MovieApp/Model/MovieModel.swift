//
//  MovieModel.swift
//  MovieApp
//
//  Created by Kerem Özdemir on 24.10.2022.
//

import Foundation

struct MovieModel: Codable {
    let search: [Search]?
    let totalResults, response: String?
    let error:String?

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
        case error = "Error"
    }
}

struct Search: Codable {
    let title, year, imdbID, type: String?
    let poster: URL?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}
