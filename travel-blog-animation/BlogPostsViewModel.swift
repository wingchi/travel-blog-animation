//
//  BlogPostsViewModel.swift
//  travel-blog-animation
//
//  Created by Stephen Wong on 5/29/16.
//  Copyright © 2016 wingchi. All rights reserved.
//

import UIKit

struct BlogPostsViewModel {

    var posts = [
        BlogPost(
            title: "There and Back Again",
            author: "J.R.R. Tolkein",
            backgroundImageURL: NSURL(string: "https://i.imgur.com/TQDmLGD.jpg"),
            color: UIColor.greenColor()
        ),
        BlogPost(
            title: "A Galaxy Far Far Away",
            author: "George Lucas",
            backgroundImageURL: NSURL(string: "https://i.imgur.com/I6gl7Wc.jpg"),
            color: UIColor.yellowColor()
        ),
        BlogPost(
            title: "20K Leagues Under the Sea",
            author: "Jules Verne",
            backgroundImageURL: NSURL(string: "https://i.imgur.com/9R4v7FM.jpg"),
            color: UIColor.blueColor()
        ),
        BlogPost(
            title: "Romance Dawn",
            author: "Oda Eiichiro",
            backgroundImageURL: NSURL(string: "https://i.imgur.com/h1u5Z2H.jpg"),
            color: UIColor.redColor()
        ),
        BlogPost(
            title: "Apollo XI",
            author: "Neil Armstrong",
            backgroundImageURL: NSURL(string: "https://i2.wp.com/listverse.com/wp-content/uploads/2012/12/flag-waving-moon-landing_9803_600x450.jpg?resize=600%2C450"),
            color: UIColor.grayColor()
        )
    ]
}
