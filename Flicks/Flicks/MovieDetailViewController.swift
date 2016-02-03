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
            }
            if let overview = movie["overview"] as? String {
                overviewLabel.text = overview
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
