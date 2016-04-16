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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var displayModeButton: UIBarButtonItem!

    enum DisplayMode {
        case Table, Grid
    }

    var movies: [Movie]?
    var filteredMovies: [Movie]?
    var displayMode = DisplayMode.Table
    var movieType = TMDBClient.MovieType.NowPlaying
    var networkErrorView: NetworkErrorView!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add table view refresh controll
        let refreshControlTV = UIRefreshControl()
        refreshControlTV.addTarget(self, action: #selector(fetchMovies(_:_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControlTV, atIndex: 0)

        // Add collection view refresh controll
        let refreshControlCV = UIRefreshControl()
        refreshControlCV.addTarget(self, action: #selector(fetchMovies(_:_:)), forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControlCV, atIndex: 0)

        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let navBarHeight = appDelegate.navBarHeight!
        let statusAndNavbarHeight = statusBarHeight + navBarHeight

        // Search bar
        let searchBarOriginY = view.bounds.origin.y + statusAndNavbarHeight
        searchBar.frame.origin = CGPoint(x: 0, y: searchBarOriginY)

        // Table view
        let tableViewOriginY = searchBar.frame.height
        let tableViewHeight = view.bounds.size.height - (searchBar.frame.size.height)
        tableView.frame = CGRectMake(0, tableViewOriginY, view.bounds.size.width, tableViewHeight)

        // Collection view
        let collectionViewOriginY = searchBarOriginY + searchBar.frame.height
        let collectionViewHeight = view.bounds.size.height - (statusAndNavbarHeight + searchBar.frame.size.height + appDelegate.tabBarHeight!)
        collectionView.frame = CGRectMake(0, collectionViewOriginY, view.bounds.size.width, collectionViewHeight)

        // Add network error view
        networkErrorView = NetworkErrorView(frame: CGRectMake(0, statusAndNavbarHeight, view.bounds.width, 44))
        networkErrorView.hidden = true
        view.addSubview(networkErrorView)

        filteredMovies = movies
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
        mdvc.movie = filteredMovies![indexPath!.row]
    }

    // MARK: - IBActions

    @IBAction func changeDisplayMode(sender: UIBarButtonItem) {
        if displayMode == .Grid {
            tableView.hidden = false
            collectionView.hidden = true
            displayMode = .Table
            displayModeButton.image = UIImage(named: "Grid")
        } else {
            tableView.hidden = true
            collectionView.hidden = false
            displayMode = .Grid
            displayModeButton.image = UIImage(named: "Table")
        }
    }

    // MARK: - Fetch Movies

    func fetchMovies(refreshControlTV: UIRefreshControl, _ refreshControlCV: UIRefreshControl) {
        networkErrorView.hidden = true
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Movie.fetchMoviesOfType(self.movieType, successCallback: { movies in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.movies = movies
                self.filteredMovies = self.movies
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

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = filteredMovies {
            return movies.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieTableViewCell") as! MovieTableViewCell

        // Reset to defaults
        cell.titleLabel.text = nil
        cell.overviewLabel.text = nil
        cell.posterImageView.image = nil

        cell.movie = filteredMovies?[indexPath.row]

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate

extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = filteredMovies {
            return movies.count
        } else {
            return 0
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCollectionViewCell", forIndexPath: indexPath) as! MovieCollectionViewCell

        // Reset to defaults
        cell.releaseDateLabel.text = nil
        cell.ratingLabel.text = nil
        cell.posterImageView.image = nil

        cell.movie = filteredMovies?[indexPath.row]

        return cell
    }
}

// MARK: - UISearchBarDelegate

extension MoviesViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = searchText.isEmpty ? movies : movies!.filter({
            (movie: Movie) -> Bool in
            return (movie.title!).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        tableView.reloadData()
        collectionView.reloadData()
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredMovies = movies
        tableView.reloadData()
        collectionView.reloadData()
    }
}
