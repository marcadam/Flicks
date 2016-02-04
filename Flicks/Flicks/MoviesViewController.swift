//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Marc Anderson on 2/2/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var movies: [NSDictionary]?
    var movieType = Movie.MovieType.NowPlaying

    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchMovies:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        fetchMovies(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let mdvc = segue.destinationViewController as! MovieDetailViewController
        let indexPath = tableView.indexPathForCell(sender! as! MovieTableViewCell)!
        mdvc.movie = movies![indexPath.row]
    }

    func fetchMovies(refreshControl: UIRefreshControl) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Movie.fetchMoviesOfType(self.movieType, successCallback: { movies in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.movies = (movies as! [NSDictionary])
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            }, errorCallback: nil)
    }

}

// MARK: - UITableView DataSource and Delegate

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieTableViewCell") as! MovieTableViewCell

        if let movie = movies?[indexPath.row] {
            if let posterPath = movie["poster_path"] as? String {
                let imageURL = NSURL(string: "http://image.tmdb.org/t/p/w500" + posterPath)!
                cell.posterImageView.setImageWithURL(imageURL)
            }

            if let title = movie["title"] as? String {
                cell.titleLabel.text = title
            }
            if let overview = movie["overview"] as? String {
                cell.overviewLabel.text = overview
            }
        }

        return cell
    }
}
