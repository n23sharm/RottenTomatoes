//
//  ViewController.swift
//  RottenTomatoes
//
//  Created by Neha Sharma on 5/5/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var noNetworkLabel: UILabel!
    
    var moviesArray: NSArray?
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Fetching Movies")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.moviesTableView.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject) {
        fetchMovies()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController!.navigationItem.title = "Top Movies"

        let colour = UIColor(red: 236.0/255.0, green: 130.0/255.0, blue: 130.0/255.0, alpha: 1.0)

        self.navigationController!.navigationBar.barTintColor = colour
        UITabBar.appearance().barTintColor = colour
        fetchMovies()
    }
    
    func fetchMovies() {
        if Reachability.isConnectedToNetwork() == true {
            self.noNetworkLabel.hidden = true;
            self.spinner.startAnimating()
            let rottenTomatoesUrlString = "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json"
            let request = NSMutableURLRequest(URL: NSURL(string:rottenTomatoesUrlString)!)
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
                var errorValue: NSError? = nil
                if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as! NSDictionary? {
                    self.moviesArray = dictionary["movies"] as! NSArray?
                    self.moviesTableView.reloadData()
                    self.spinner.stopAnimating()
                    self.refreshControl.endRefreshing()
                } 
            })
        } else {
            self.spinner.stopAnimating()
            self.refreshControl.endRefreshing()
            self.noNetworkLabel.hidden = false;
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.moviesTableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movieJSON = moviesArray![indexPath.row] as! NSDictionary
        cell.movieTitle!.text = movieJSON["title"] as? String
        cell.mpaRatingLabel!.text = movieJSON["mpaa_rating"] as? String
        
        let posterUrl = NSURL(string: movieJSON.valueForKeyPath("posters.thumbnail") as! String)!
        cell.posterImage.setImageWithURL(posterUrl)
        
        let ratingsJSON = movieJSON["ratings"] as! NSDictionary
        let ratingPercent = ratingsJSON["critics_score"] as! Int
        cell.ratingPercent!.text = "\(ratingPercent)%"
        
        let rating = ratingsJSON["critics_rating"] as! String

        switch rating {
            case "Fresh":
                cell.tomatoIcon.image = UIImage(named: "fresh")
            case "Rotten":
                cell.tomatoIcon.image = UIImage(named: "rotten")
            case "Certified Fresh":
                cell.tomatoIcon.image = UIImage(named: "certified_fresh")
            default:
                cell.tomatoIcon.image = UIImage(named: "fresh")
            
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = self.moviesTableView.indexPathForCell(cell)
        
        let moviesJSON = moviesArray![indexPath!.row] as! NSDictionary
        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.moviesJSON = moviesJSON
    }


}

