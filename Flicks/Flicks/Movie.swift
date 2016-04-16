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
    let smallPosterURL: NSURL?
    let largePosterURL: NSURL?
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
            self.smallPosterURL = NSURL(string: TMDBClient.sharedInstance.getSmallPosterURLForPath(posterPath))
            self.largePosterURL = NSURL(string: TMDBClient.sharedInstance.getLargePosterURLForPath(posterPath))
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

    class func moviesFromArray(array: [NSDictionary]) -> [Movie] {
        var movies = [Movie]()
        for dictionary in array {
            movies.append(Movie(dictionary: dictionary))
        }
        return movies
    }

    class func fetchMoviesOfType(type: TMDBClient.MovieType, successCallback: ([Movie]) -> Void, errorCallback: ((NSError?) -> Void)?) {
        TMDBClient.sharedInstance.fetchMoviesOfType(type, successCallback: successCallback, errorCallback: errorCallback)
    }
}
