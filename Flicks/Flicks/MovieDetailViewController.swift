//
//  MovieDetailViewController.swift
//  Flicks
//
//  Created by Marc Anderson on 2/3/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var movieInfoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateImage: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!

    var movie: NSDictionary?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = movie {
            if let posterPath = movie["poster_path"] as? String {
                let imageURL = NSURL(string: "http://image.tmdb.org/t/p/w500" + posterPath)!
                posterImageView.setImageWithURL(imageURL)
            }
            if let title = movie["title"] as? String {
                titleLabel.text = title
                titleLabel.sizeToFit()
            }
            if let overview = movie["overview"] as? String {
                overviewLabel.text = overview
                overviewLabel.sizeToFit()
            }

            if let releaseDate = movie["release_date"] as? String {
                releaseDateLabel.text = releaseDate
            }

            if let rating = movie["vote_average"] as? Double {
                ratingLabel.text = "\(rating)"
            }

            let padding = CGFloat(8)
            let tabBarHeight = CGFloat(49)
            let movieInfoViewDefaultVisableHeight = CGFloat(80.0)

            let movieInfoViewHeight = titleLabel.bounds.height + overviewLabel.bounds.height + releaseDateLabel.frame.height + padding * 5
            movieInfoView.frame.origin = CGPoint(x: view.frame.origin.x, y: view.frame.height - movieInfoViewDefaultVisableHeight - tabBarHeight)
            movieInfoView.frame.size = CGSize(width: movieInfoView.frame.width, height: movieInfoViewHeight)

            let releaseDateOriginY = titleLabel.bounds.height + padding * 2
            releaseDateLabel.frame.origin = CGPoint(x: releaseDateLabel.frame.origin.x, y: releaseDateOriginY)
            releaseDateImage.frame.origin = CGPoint(x: releaseDateImage.frame.origin.x, y: releaseDateOriginY)

            let ratingOriginY = releaseDateOriginY
            ratingLabel.frame.origin = CGPoint(x: ratingLabel.frame.origin.x, y: ratingOriginY)
            ratingImage.frame.origin = CGPoint(x: ratingImage.frame.origin.x, y: ratingOriginY)

            let overviewOriginY = titleLabel.bounds.height + releaseDateLabel.bounds.height + padding * 3
            overviewLabel.frame.origin = CGPoint(x: overviewLabel.frame.origin.x, y: overviewOriginY)

            let contentWidth = scrollView.bounds.width
            let contentHeight = scrollView.bounds.height + movieInfoView.frame.height - movieInfoViewDefaultVisableHeight
            scrollView.contentSize = CGSizeMake(contentWidth, contentHeight)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
