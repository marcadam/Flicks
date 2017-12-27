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

    func fetchMoviesOfType(_ type: MovieType, successCallback: @escaping ([Movie]) -> Void, errorCallback: ((NSError?) -> Void)?) {
        let url = URL(string: "\(TMDB.BaseURL)\(type.rawValue)?api_key=\(TMDB.APIKey)")
        let request = URLRequest(url: url!)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        // configuration.URLCache = nil
        let session = URLSession(
            configuration: configuration,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )

        let task: URLSessionDataTask = session.dataTask(
            with: request,
            completionHandler: { (dataOrNil, responseOrNil, errorOrNil) in
                if let requestError = errorOrNil as NSError? {
                    errorCallback?(requestError)
                } else {
                    if let data = dataOrNil {
                        if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
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

    func getSmallPosterURLForPath(_ posterPath: String) -> String {
        return TMDB.SmallPosterBaseURL + posterPath
    }

    func getLargePosterURLForPath(_ posterPath: String) -> String {
        return TMDB.LargePosterBaseURL + posterPath
    }
}
