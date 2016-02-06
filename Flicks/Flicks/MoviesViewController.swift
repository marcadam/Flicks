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
    @IBOutlet weak var collectionView: UICollectionView!

    var movies: [NSDictionary]?
    var movieType = Movie.MovieType.NowPlaying
    var networkErrorView: NetworkErrorView!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        networkErrorView = NetworkErrorView(frame: CGRectMake(0, 64, view.bounds.width, 30))
        networkErrorView.hidden = true
        view.addSubview(networkErrorView)

        // Add table view refresh controll
        let refreshControlTV = UIRefreshControl()
        refreshControlTV.addTarget(self, action: "fetchMovies::", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControlTV, atIndex: 0)

        // Add collection view refresh controll
        let refreshControlCV = UIRefreshControl()
        refreshControlCV.addTarget(self, action: "fetchMovies::", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControlCV, atIndex: 0)

        // Set origin and size of collection view
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let collectionViewOriginY = view.bounds.origin.y + statusBarHeight + appDelegate.navBarHeight!
        let collectionViewHeight = view.bounds.size.height - (statusBarHeight + appDelegate.navBarHeight! + appDelegate.tabBarHeight!)
        collectionView.frame = CGRectMake(0, collectionViewOriginY, view.bounds.size.width, collectionViewHeight)

        fetchMovies(refreshControlTV, refreshControlCV)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let mdvc = segue.destinationViewController as! MovieDetailViewController
        var indexPath: NSIndexPath?
        if let cell = sender as? MovieTableViewCell {
            indexPath = tableView.indexPathForCell(cell)
        }
        if let cell = sender as? MovieCollectionViewCell {
            indexPath = collectionView.indexPathForCell(cell)
        }
        mdvc.movie = movies![indexPath!.row]
    }

    // MARK: - IBActions

    @IBAction func changeDisplayMode(segmentedControl: UISegmentedControl) {
        let selectedIndex = segmentedControl.selectedSegmentIndex

        switch selectedIndex {
        case 0:
            tableView.hidden = false
            collectionView.hidden = true
        case 1:
            tableView.hidden = true
            collectionView.hidden = false
        default:
            break
        }
    }

    // MARK: - Fetch Movies

    func fetchMovies(refreshControlTV: UIRefreshControl, _ refreshControlCV: UIRefreshControl) {
        networkErrorView.hidden = true
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Movie.fetchMoviesOfType(self.movieType, successCallback: { movies in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.movies = (movies as! [NSDictionary])
                self.tableView.reloadData()
                self.collectionView.reloadData()
                refreshControlTV.endRefreshing()
                refreshControlCV.endRefreshing()
                self.networkErrorView.hidden = true
            }, errorCallback: { error in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                refreshControlTV.endRefreshing()
                refreshControlCV.endRefreshing()
                self.networkErrorView.hidden = false
            }
        )
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCollectionViewCell", forIndexPath: indexPath) as! MovieCollectionViewCell

        if let movie = movies?[indexPath.row] {
            if let posterPath = movie["poster_path"] as? String {
                let imageURL = NSURL(string: "http://image.tmdb.org/t/p/w500" + posterPath)!
                cell.posterImageView.setImageWithURL(imageURL)
            }

            if let releaseDate = movie["release_date"] as? String {
                cell.releaseDateLabel.text = releaseDate
            }

            if let rating = movie["vote_average"] as? Double {
                cell.ratingLabel.text = "\(rating)"
            }
        }

        return cell
    }
}
