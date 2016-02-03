//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Marc Anderson on 2/2/16.
//  Copyright © 2016 Marc Anderson. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var movies: [NSDictionary]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Movie.fetchMoviesOfType(.NowPlaying, successCallback: { movies in
            print("movies: \(self.movies)")
            self.movies = (movies as! [NSDictionary])
            self.tableView.reloadData()
            }, errorCallback: nil)
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
