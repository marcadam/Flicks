//
//  Movie.swift
//  Flicks
//
//  Created by Marc Anderson on 2/2/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import Foundation

class Movie {

    struct TMDB {
        static let BaseURL = "https://api.themoviedb.org/3/movie/"
        static let APIKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    }

    enum MovieType: String {
        case NowPlaying = "now_playing"
        case TopRated = "top_rated"
    }

    class func fetchMoviesOfType(type: MovieType, successCallback: (NSArray) -> Void, errorCallback: ((NSError?) -> Void)?) {
        let url = NSURL(string: "\(TMDB.BaseURL)\(type.rawValue)?api_key=\(TMDB.APIKey)")
        let request = NSURLRequest(URL: url!)
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 10
        let session = NSURLSession(
            configuration: configuration,
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )

        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, responseOrNil, errorOrNil) in
                if let requestError = errorOrNil {
                    errorCallback?(requestError)
                } else {
                    if let data = dataOrNil {
                        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary {
                            if let movies = responseDictionary["results"] as? NSArray {
                                successCallback(movies)
                            }
                        }
                    }
                }
        });
        task.resume()
    }
}
