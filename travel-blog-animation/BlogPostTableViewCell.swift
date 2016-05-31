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
    
    let postView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .None
        backgroundColor = UIColor.clearColor()
        
        setupPostView()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupPostView() {
        addSubview(postView)
        
        constrain(postView, self) { postView, view in
            postView.top == view.top + padding
            postView.bottom == view.bottom - padding
            postView.left == view.left + padding
            postView.right == view.right - padding
        }
        
        postView.addSubview(titleLabel)
        
        constrain(titleLabel, postView) { titleLabel, postView in
            titleLabel.center == postView.center
        }
        
        postView.layer.cornerRadius = cornerRadius
        
        postView.backgroundColor = UIColor.orangeColor()
    }
    
    func configureWithViewModel(viewModel: BlogPostsViewModel, atIndexPath indexPath: NSIndexPath) {
        titleLabel.text = viewModel.posts[indexPath.row]
    }
}
