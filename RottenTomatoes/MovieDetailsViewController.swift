//
//  MovieDetailsViewController.swift
//  RottenTomatoes
//
//  Created by Neha Sharma on 5/9/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieSynopsis: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    
    var moviesJSON: NSDictionary!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.movieTitle!.text = moviesJSON["title"] as? String
        self.movieSynopsis!.text = moviesJSON["synopsis"] as? String
        
        let posterUrl = NSURL(string: moviesJSON.valueForKeyPath("posters.original") as! String)!
        self.posterImage.setImageWithURL(posterUrl)


    }

}
