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
    let movieTableViewCellID = "com.marcadam.MovieTableViewCell"
    let movieCollectionViewCellID = "com.marcadam.MovieCollectionViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load cells from nibs
        let movieTableViewCellNIB = UINib(nibName: "MovieTableViewCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(movieTableViewCellNIB, forCellReuseIdentifier: movieTableViewCellID)

        let movieCollectionViewCellNIB = UINib(nibName: "MovieCollectionViewCell", bundle: NSBundle.mainBundle())
        collectionView.registerNib(movieCollectionViewCellNIB, forCellWithReuseIdentifier: movieCollectionViewCellID)

        // Add table view refresh control
        let refreshControlTV = UIRefreshControl()
        refreshControlTV.addTarget(self, action: #selector(fetchMovies(_:_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControlTV, atIndex: 0)

        // Add collection view refresh control
        let refreshControlCV = UIRefreshControl()
        refreshControlCV.addTarget(self, action: #selector(fetchMovies(_:_:)), forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControlCV, atIndex: 0)

        // Add network error view
        networkErrorView = NetworkErrorView(frame: CGRectMake(0, 0, view.bounds.width, 44))
        networkErrorView.hidden = true
        view.addSubview(networkErrorView)

        filteredMovies = movies
        fetchMovies(refreshControlTV, refreshControlCV)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let refreshing = refreshControlTV.refreshing || refreshControlCV.refreshing
        networkErrorView.hidden = true
        if !refreshing { MBProgressHUD.showHUDAddedTo(self.view, animated: true) }
        Movie.fetchMoviesOfType(
            self.movieType,
            successCallback: { movies in
                if !refreshing { MBProgressHUD.hideHUDForView(self.view, animated: true) }
                self.movies = movies
                self.filteredMovies = self.movies
                self.tableView.reloadData()
                self.collectionView.reloadData()
                refreshControlTV.endRefreshing()
                refreshControlCV.endRefreshing()
                self.networkErrorView.hidden = true
            },
            errorCallback: { error in
                if !refreshing { MBProgressHUD.hideHUDForView(self.view, animated: true) }
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
        let cell = tableView.dequeueReusableCellWithIdentifier(movieTableViewCellID, forIndexPath: indexPath) as! MovieTableViewCell

        // Reset to defaults
        cell.titleLabel.text = nil
        cell.overviewLabel.text = nil
        cell.posterImageView.image = nil

        cell.movie = filteredMovies?[indexPath.row]

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "MovieDetail", bundle: NSBundle.mainBundle())
        let movieDetailVC = storyboard.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
        movieDetailVC.hidesBottomBarWhenPushed = true
        movieDetailVC.movie = filteredMovies![indexPath.row]
        navigationController?.pushViewController(movieDetailVC, animated: true)
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(movieCollectionViewCellID, forIndexPath: indexPath) as! MovieCollectionViewCell

        // Reset to defaults
        cell.releaseDateLabel.text = nil
        cell.ratingLabel.text = nil
        cell.posterImageView.image = nil

        cell.movie = filteredMovies?[indexPath.row]

        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "MovieDetail", bundle: NSBundle.mainBundle())
        let movieDetailVC = storyboard.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
        movieDetailVC.hidesBottomBarWhenPushed = true
        movieDetailVC.movie = filteredMovies![indexPath.row]
        navigationController?.pushViewController(movieDetailVC, animated: true)
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellSpacing = CGFloat(13)
        let posterPadding = CGFloat(2)
        let infoViewHeight = CGFloat(30)
        let cellWidthToHeightRatio = CGFloat(1.5)
        let cellWidth = (collectionView.bounds.width - (cellSpacing * 3)) / 2.0
        let cellHeight = cellWidth * cellWidthToHeightRatio + posterPadding + infoViewHeight

        return CGSize(width: cellWidth, height: cellHeight)
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
