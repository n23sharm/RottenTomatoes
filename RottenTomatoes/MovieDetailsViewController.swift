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
    @IBOutlet weak var mpaRatingLabel: UILabel!
    @IBOutlet weak var tomatoIcon: UIImageView!
    @IBOutlet weak var ratingPercentLabel: UILabel!
    
    var moviesJSON: NSDictionary!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.movieTitle!.text = moviesJSON["title"] as? String
        self.movieSynopsis!.text = moviesJSON["synopsis"] as? String
        
        let posterUrl = NSURL(string: moviesJSON.valueForKeyPath("posters.original") as! String)!
        self.posterImage.setImageWithURL(posterUrl)

        self.mpaRatingLabel!.text = moviesJSON["mpaa_rating"] as? String

        let ratingsJSON = moviesJSON["ratings"] as! NSDictionary
        let ratingPercent = ratingsJSON["critics_score"] as! Int
        self.ratingPercentLabel!.text = "\(ratingPercent)%"
        
        let rating = ratingsJSON["critics_rating"] as! String
        
        switch rating {
        case "Fresh":
            self.tomatoIcon.image = UIImage(named: "fresh")
        case "Rotten":
            self.tomatoIcon.image = UIImage(named: "rotten")
        case "Certified Fresh":
            self.tomatoIcon.image = UIImage(named: "certified_fresh")
        default:
            self.tomatoIcon.image = UIImage(named: "fresh")
            
        }


    }

}
