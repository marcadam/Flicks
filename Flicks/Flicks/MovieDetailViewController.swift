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

            let padding = CGFloat(8)
            let movieInfoViewDefaultVisableHeight = CGFloat(80.0)

            let movieInfoViewHeight = titleLabel.bounds.height + overviewLabel.bounds.height + padding * 4
            movieInfoView.frame.origin = CGPoint(x: view.frame.origin.x, y: view.frame.height - movieInfoViewDefaultVisableHeight)
            movieInfoView.frame.size = CGSize(width: movieInfoView.frame.width, height: movieInfoViewHeight)

            let overviewOriginY = titleLabel.bounds.height + padding * 2
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
