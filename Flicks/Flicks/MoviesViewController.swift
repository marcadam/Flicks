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
        case table, grid
    }

    var movies: [Movie]?
    var filteredMovies: [Movie]?
    var displayMode = DisplayMode.table
    var movieType = TMDBClient.MovieType.NowPlaying
    var networkErrorView: NetworkErrorView!
    let movieTableViewCellID = "com.marcadam.MovieTableViewCell"
    let movieCollectionViewCellID = "com.marcadam.MovieCollectionViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load cells from nibs
        let movieTableViewCellNIB = UINib(nibName: "MovieTableViewCell", bundle: Bundle.main)
        tableView.register(movieTableViewCellNIB, forCellReuseIdentifier: movieTableViewCellID)

        let movieCollectionViewCellNIB = UINib(nibName: "MovieCollectionViewCell", bundle: Bundle.main)
        collectionView.register(movieCollectionViewCellNIB, forCellWithReuseIdentifier: movieCollectionViewCellID)

        // Add table view refresh control
        let refreshControlTV = UIRefreshControl()
        refreshControlTV.addTarget(self, action: #selector(fetchMovies(_:_:)), for: .valueChanged)
        tableView.insertSubview(refreshControlTV, at: 0)

        // Add collection view refresh control
        let refreshControlCV = UIRefreshControl()
        refreshControlCV.addTarget(self, action: #selector(fetchMovies(_:_:)), for: .valueChanged)
        collectionView.insertSubview(refreshControlCV, at: 0)

        // Add network error view
        networkErrorView = NetworkErrorView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        networkErrorView.isHidden = true
        view.addSubview(networkErrorView)

        filteredMovies = movies
        fetchMovies(refreshControlTV, refreshControlCV)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBActions

    @IBAction func changeDisplayMode(_ sender: UIBarButtonItem) {
        if displayMode == .grid {
            tableView.isHidden = false
            collectionView.isHidden = true
            displayMode = .table
            displayModeButton.image = UIImage(named: "Grid")
        } else {
            tableView.isHidden = true
            collectionView.isHidden = false
            displayMode = .grid
            displayModeButton.image = UIImage(named: "Table")
        }
    }

    // MARK: - Fetch Movies

    func fetchMovies(_ refreshControlTV: UIRefreshControl, _ refreshControlCV: UIRefreshControl) {
        let refreshing = refreshControlTV.isRefreshing || refreshControlCV.isRefreshing
        networkErrorView.isHidden = true
        if !refreshing { MBProgressHUD.showAdded(to: self.view, animated: true) }
        Movie.fetchMoviesOfType(
            self.movieType,
            successCallback: { movies in
                if !refreshing { MBProgressHUD.hide(for: self.view, animated: true) }
                self.movies = movies
                self.filteredMovies = self.movies
                self.tableView.reloadData()
                self.collectionView.reloadData()
                refreshControlTV.endRefreshing()
                refreshControlCV.endRefreshing()
                self.networkErrorView.isHidden = true
            },
            errorCallback: { error in
                if !refreshing { MBProgressHUD.hide(for: self.view, animated: true) }
                refreshControlTV.endRefreshing()
                refreshControlCV.endRefreshing()
                self.networkErrorView.isHidden = false
            }
        )
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = filteredMovies {
            return movies.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: movieTableViewCellID, for: indexPath) as! MovieTableViewCell

        // Reset to defaults
        cell.titleLabel.text = nil
        cell.overviewLabel.text = nil
        cell.posterImageView.image = nil

        cell.movie = filteredMovies?[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MovieDetail", bundle: Bundle.main)
        let movieDetailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        movieDetailVC.hidesBottomBarWhenPushed = true
        movieDetailVC.movie = filteredMovies![indexPath.row]
        navigationController?.pushViewController(movieDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate

extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = filteredMovies {
            return movies.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCollectionViewCellID, for: indexPath) as! MovieCollectionViewCell

        // Reset to defaults
        cell.releaseDateLabel.text = nil
        cell.ratingLabel.text = nil
        cell.posterImageView.image = nil

        cell.movie = filteredMovies?[indexPath.row]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MovieDetail", bundle: Bundle.main)
        let movieDetailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        movieDetailVC.hidesBottomBarWhenPushed = true
        movieDetailVC.movie = filteredMovies![indexPath.row]
        navigationController?.pushViewController(movieDetailVC, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = searchText.isEmpty ? movies : movies!.filter({
            (movie: Movie) -> Bool in
            return (movie.title!).range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
        collectionView.reloadData()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredMovies = movies
        tableView.reloadData()
        collectionView.reloadData()
    }
}
