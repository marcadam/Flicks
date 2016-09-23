//
//  Movie.swift
//  Flicks
//
//  Created by Marc Anderson on 2/2/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import Foundation

class Movie {
    let title: String?
    let overview: String?
    let smallPosterURL: URL?
    let largePosterURL: URL?
    let releaseDate: String?
    let voteAverage: Double?

    init(dictionary: NSDictionary) {
        title = dictionary["title"] as? String
        if let overview = dictionary["overview"] as? String {
            self.overview = overview
        } else {
            self.overview = nil
        }
        if let posterPath = dictionary["poster_path"] as? String {
            self.smallPosterURL = URL(string: TMDBClient.sharedInstance.getSmallPosterURLForPath(posterPath))
            self.largePosterURL = URL(string: TMDBClient.sharedInstance.getLargePosterURLForPath(posterPath))
        } else {
            self.smallPosterURL = nil
            self.largePosterURL = nil
        }
        if let releaseDate = dictionary["release_date"] as? String {
            self.releaseDate = releaseDate
        } else {
            releaseDate = nil
        }
        if let voteAverage = dictionary["vote_average"] as? Double {
            self.voteAverage = voteAverage
        } else {
            voteAverage = nil
        }
    }

    class func moviesFromArray(_ array: [NSDictionary]) -> [Movie] {
        return array.map { Movie(dictionary: $0) }
    }

    class func fetchMoviesOfType(_ type: TMDBClient.MovieType, successCallback: @escaping ([Movie]) -> Void, errorCallback: ((NSError?) -> Void)?) {
        TMDBClient.sharedInstance.fetchMoviesOfType(type, successCallback: successCallback, errorCallback: errorCallback)
    }
}
