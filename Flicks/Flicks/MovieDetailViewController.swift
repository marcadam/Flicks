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

    var movie: Movie!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadPosterImage()

        titleLabel.text = movie.title
        titleLabel.sizeToFit()

        overviewLabel.text = movie.overview
        overviewLabel.sizeToFit()

        if let releaseDate = movie.releaseDate {
            releaseDateLabel.text = formatDate(releaseDate, format: .Long)
        }

        if let voteAverage = movie.voteAverage {
            ratingLabel.text = "\(voteAverage)"
        }

        let padding = CGFloat(8)
        let movieInfoViewDefaultVisableHeight = CGFloat(160.0)
        // This is too keep the user from seeing the bottom of the movieInfoView
        // when they scroll up. By adding it to the movieInfoView, and subtracting
        // it from the content height you have more content than the scroll view
        // can scroll.
        let overflowHeight = CGFloat(1000)

        let movieInfoViewHeight = titleLabel.bounds.height + overviewLabel.bounds.height + releaseDateLabel.frame.height + padding * 5 + overflowHeight
        movieInfoView.frame.origin = CGPoint(x: view.bounds.origin.x, y: view.bounds.height - movieInfoViewDefaultVisableHeight)
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
        let contentHeight = scrollView.bounds.height + movieInfoView.frame.height - movieInfoViewDefaultVisableHeight - overflowHeight
        scrollView.contentSize = CGSizeMake(contentWidth, contentHeight)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Privide animation to inform user that movie info is scrollable.
        UIView.animateWithDuration(
            0.5,
            delay: 0.0,
            options: [.CurveEaseInOut],
            animations: {
                self.movieInfoView.frame.origin.y = self.movieInfoView.frame.origin.y - 20
            },
            completion: { finished in
                UIView.animateWithDuration(0.5,
                    delay: 0.0, options: [.CurveEaseInOut],
                    animations: {
                        self.movieInfoView.frame.origin.y = self.movieInfoView.frame.origin.y + 20
                    },
                    completion: nil)
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func loadPosterImage() {
        if let smallPosterURL = movie.smallPosterURL, largePosterURL = movie.largePosterURL {
            let smallImageRequest = NSURLRequest(URL: smallPosterURL)
            let largeImageRequest = NSURLRequest(URL: largePosterURL)

            posterImageView.setImageWithURLRequest(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in

                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = smallImage;

                    UIView.animateWithDuration(0.3, animations: { () -> Void in

                        self.posterImageView.alpha = 1.0

                        }, completion: { (sucess) -> Void in

                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                            // per ImageView. This code must be in the completion block.
                            self.posterImageView.setImageWithURLRequest(
                                largeImageRequest,
                                placeholderImage: smallImage,
                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in

                                    self.posterImageView.image = largeImage;

                                },
                                failure: { (request, response, error) -> Void in
                                    // do something for the failure condition of the large image request
                                    // possibly setting the ImageView's image to a default image
                            })
                    })
                },
                failure: { (request, response, error) -> Void in
                    // do something for the failure condition
                    // possibly try to get the large image
            })
        }
    }
}
