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
        
        fetchMovies()
    }
    
    func fetchMovies() {
        self.spinner.startAnimating()
        
        let rottenTomatoesUrlString = "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json"
        let request = NSMutableURLRequest(URL: NSURL(string:rottenTomatoesUrlString)!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            var errorValue: NSError? = nil
            if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as! NSDictionary? {
                self.moviesArray = dictionary["movies"] as! NSArray?
                self.moviesTableView.reloadData()
                self.spinner.stopAnimating()
                self.refreshControl.endRefreshing()
            } else {
                
            }
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.moviesTableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movieJSON = moviesArray![indexPath.row] as! NSDictionary
        cell.movieTitle!.text = movieJSON["title"] as? String
        cell.movieSynopsis!.text = movieJSON["synopsis"] as? String
        
        let posterUrl = NSURL(string: movieJSON.valueForKeyPath("posters.thumbnail") as! String)!
        cell.posterImage.setImageWithURL(posterUrl)
        
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

