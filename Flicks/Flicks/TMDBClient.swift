//
//  TMDBClient.swift
//  Flicks
//
//  Created by Marc Anderson on 4/15/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import Foundation

class TMDBClient {

    static let sharedInstance = TMDBClient()

    struct TMDB {
        static let BaseURL = "https://api.themoviedb.org/3/movie/"
        static let SmallPosterBaseURL = "http://image.tmdb.org/t/p/w342"
        static let LargePosterBaseURL = "http://image.tmdb.org/t/p/w780"
        static let APIKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    }

    enum MovieType: String {
        case NowPlaying = "now_playing"
        case TopRated = "top_rated"
    }

    func fetchMoviesOfType(type: MovieType, successCallback: ([Movie]) -> Void, errorCallback: ((NSError?) -> Void)?) {
        let url = NSURL(string: "\(TMDB.BaseURL)\(type.rawValue)?api_key=\(TMDB.APIKey)")
        let request = NSURLRequest(URL: url!)
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 10
        // configuration.URLCache = nil
        let session = NSURLSession(
            configuration: configuration,
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )

        let task: NSURLSessionDataTask = session.dataTaskWithRequest(
            request,
            completionHandler: { (dataOrNil, responseOrNil, errorOrNil) in
                if let requestError = errorOrNil {
                    errorCallback?(requestError)
                } else {
                    if let data = dataOrNil {
                        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary {
                            if let movies = responseDictionary["results"] as? [NSDictionary] {
                                successCallback(Movie.moviesFromArray(movies))
                            }
                        }
                    }
                }
            }
        );
        task.resume()
    }

    func getSmallPosterURLForPath(posterPath: String) -> String {
        return TMDB.SmallPosterBaseURL + posterPath
    }

    func getLargePosterURLForPath(posterPath: String) -> String {
        return TMDB.LargePosterBaseURL + posterPath
    }
}