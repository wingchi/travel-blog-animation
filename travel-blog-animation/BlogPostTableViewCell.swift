//
//  BlogPostTableViewCell.swift
//  travel-blog-animation
//
//  Created by Stephen Wong on 5/29/16.
//  Copyright © 2016 wingchi. All rights reserved.
//

import UIKit
import Cartography

class BlogPostTableViewCell: UITableViewCell {

    private let padding: CGFloat = 5
    private let cornerRadius: CGFloat = 5
    
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let overlay = UIView()
    let imageViewBackground = UIImageView()
    
    let postView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .None
        backgroundColor = UIColor.clearColor()
        layer.cornerRadius = cornerRadius
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupPostView(blogPost: BlogPost, withHeight height: CGFloat) {
        addSubview(postView)
        
        constrain(postView, self) { postView, view in
            postView.height == height - 2 * padding
            postView.bottom == view.bottom - padding
            postView.left == view.left + padding
            postView.right == view.right - padding
        }
        
        postView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.whiteColor()
        constrain(titleLabel, postView) { titleLabel, postView in
            titleLabel.centerX == postView.centerX
            titleLabel.centerY == postView.centerY - 10
        }
        
        postView.addSubview(authorLabel)
        authorLabel.textColor = UIColor.whiteColor()
        authorLabel.font = authorLabel.font.fontWithSize(12)
        constrain(authorLabel, titleLabel) { authorLabel, titleLabel in
            authorLabel.centerX == titleLabel.centerX
            authorLabel.top == titleLabel.bottom + 10
        }
        
        postView.layer.cornerRadius = cornerRadius

        overlay.backgroundColor = blogPost.color.colorWithAlphaComponent(0.5)
        postView.addSubview(overlay)
        postView.sendSubviewToBack(overlay)
        
        constrain(overlay, postView) { overlay, postView in
            overlay.left == postView.left
            overlay.right == postView.right
            overlay.top == postView.top
            overlay.bottom == postView.bottom
        }
        
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        imageViewBackground.clipsToBounds = true
        
        if  let backgroundImageURL = blogPost.backgroundImageURL,
            let backgroundImageData = NSData(contentsOfURL: backgroundImageURL),
            let backgroundImage = UIImage(data: backgroundImageData) {
            imageViewBackground.image = backgroundImage
        }
        
        postView.addSubview(imageViewBackground)
        postView.sendSubviewToBack(imageViewBackground)
        
        constrain(imageViewBackground, postView) { imageViewBackground, view in
            imageViewBackground.left == view.left
            imageViewBackground.right == view.right
            imageViewBackground.bottom == view.bottom
            imageViewBackground.top == view.top
        }
    }
    
    func configureWithViewModel(viewModel: BlogPostsViewModel, atIndexPath indexPath: NSIndexPath, height: CGFloat) {
        
        setupPostView(viewModel.posts[indexPath.row], withHeight: height)
        
        titleLabel.text = viewModel.posts[indexPath.row].title
        authorLabel.text = "by " + viewModel.posts[indexPath.row].author
    }
}
