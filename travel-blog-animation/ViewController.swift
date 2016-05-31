//
//  ViewController.swift
//  travel-blog-animation
//
//  Created by Stephen Wong on 5/29/16.
//  Copyright © 2016 wingchi. All rights reserved.
//

import UIKit
import Cartography

class ViewController: UIViewController {
    
    enum ScrollDirection {
        case Up
        case Down
    }
    
    private let viewModel = BlogPostsViewModel()
    
    private var topTableViewCell: BlogPostTableViewCell? = nil
    private var topTableViewCellIndexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    private var scrollDirection: ScrollDirection = .Down
    
    private var prevDifferenceToCell: CGFloat = 0
    private var shrinkingBlogPostView = UIView()
    
    var blogPostTableViewCellIdentifier: String {
        return String(BlogPostTableViewCell)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        
        tableView.estimatedRowHeight = 400
        tableView.separatorStyle = .None
        
        let blogPostTableViewCellNib = UINib(nibName: self.blogPostTableViewCellIdentifier, bundle: nil)
        tableView.registerNib(blogPostTableViewCellNib, forCellReuseIdentifier: self.blogPostTableViewCellIdentifier)
        
        return tableView
    }()

    var tableViewCellHeight: CGFloat {
        return view.frame.height / 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupShrinkingBlogPostView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        constrain(view, tableView) { view, tableView in
            tableView.left == view.left
            tableView.right == view.right
            tableView.top == view.top + 64
            tableView.bottom == view.bottom
        }
        
        tableView.backgroundColor = UIColor.clearColor()
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: tableViewCellHeight))
    }
    
    private func setupShrinkingBlogPostView() {
        view.insertSubview(shrinkingBlogPostView, belowSubview: tableView)
        
        constrain(shrinkingBlogPostView, tableView) { shrinkingBlogPostView, tableView in
            shrinkingBlogPostView.left == tableView.left
            shrinkingBlogPostView.right == tableView.right
            shrinkingBlogPostView.top == tableView.top
            shrinkingBlogPostView.height == self.view.frame.height / 4
        }
    }
    
    private func scrollToPrevTableViewCell() {
        let targetRow = topTableViewCellIndexPath.row - 1 > -1 ? topTableViewCellIndexPath.row - 1 : 0
        let prevIndexPath = NSIndexPath(forRow: targetRow, inSection: 0)
        
        tableView.scrollToRowAtIndexPath(prevIndexPath, atScrollPosition: .Top, animated: true)
        tableView.cellForRowAtIndexPath(prevIndexPath)?.hidden = false
    }
    
    private func scrollToNextTableViewCell() {
        let targetRow = topTableViewCellIndexPath.row + 1 < viewModel.posts.count ? topTableViewCellIndexPath.row + 1 : viewModel.posts.count - 1
        let nextIndexPath = NSIndexPath(forRow: targetRow, inSection: 0)
        
        tableView.scrollToRowAtIndexPath(nextIndexPath, atScrollPosition: .Top, animated: true)
        tableView.cellForRowAtIndexPath(nextIndexPath)?.hidden = false
    }

    private func scrollToNearestTableViewCell(scrollView: UIScrollView) {
        let cellHeight = view.frame.height / 4
        let differenceToCell = scrollView.contentOffset.y % cellHeight
        
        guard differenceToCell != 0 else { return }
        
        let floorCellRow = Int(scrollView.contentOffset.y / cellHeight)
        var nearestCellRow = differenceToCell < cellHeight / 2 ? floorCellRow : floorCellRow + 1
        nearestCellRow = nearestCellRow < viewModel.posts.count ? nearestCellRow : viewModel.posts.count - 1
        let nearestIndexPath = NSIndexPath(forRow: nearestCellRow, inSection: 0)
        
        tableView.scrollToRowAtIndexPath(nearestIndexPath, atScrollPosition: .Top, animated: true)
    }
    
    private func handleScrollViewDidFinishScrolling(scrollView: UIScrollView) {
        scrollToNearestTableViewCell(scrollView)
    }
}

// MARK: UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(blogPostTableViewCellIdentifier) as! BlogPostTableViewCell
        cell.configureWithViewModel(viewModel, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return view.frame.height / 4
    }
}

// MARK: UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        var topCellIndexPathRow = Int(scrollView.contentOffset.y / tableViewCellHeight)
        topCellIndexPathRow = topCellIndexPathRow > -1 ? topCellIndexPathRow : 0
        topTableViewCellIndexPath = NSIndexPath(forRow: topCellIndexPathRow, inSection: 0)
        guard let topVisibleCell = tableView.cellForRowAtIndexPath(topTableViewCellIndexPath) as? BlogPostTableViewCell else { return }
        topTableViewCell = topVisibleCell

        let translation = scrollView.panGestureRecognizer.translationInView(scrollView.superview)
        
        scrollDirection = translation.y > 0 ? .Up : .Down

        switch scrollDirection {
        case .Down:
            shrinkingBlogPostView = topVisibleCell.postView
        default:
            break;
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let cellHeight = tableViewCellHeight
        let differenceToCell = scrollView.contentOffset.y % cellHeight
        let scaleFactor = (cellHeight - differenceToCell * 1 / 2) / cellHeight
        
        if prevDifferenceToCell < differenceToCell {
            shrinkingBlogPostView.transform = CGAffineTransformIdentity
            shrinkingBlogPostView.alpha = 1.0
        }
        
        var cellIndexPathRow = differenceToCell != 0 ? Int((scrollView.contentOffset.y - differenceToCell) / cellHeight) : viewModel.posts.count - 1
        cellIndexPathRow = cellIndexPathRow < viewModel.posts.count ? cellIndexPathRow : viewModel.posts.count - 1
        let indexPath = NSIndexPath(forRow: cellIndexPathRow, inSection: 0)
        
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? BlogPostTableViewCell else { return }
        shrinkingBlogPostView = cell.postView
        
        shrinkingBlogPostView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
        shrinkingBlogPostView.alpha = scaleFactor
  
        prevDifferenceToCell = differenceToCell
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        handleScrollViewDidFinishScrolling(scrollView)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        handleScrollViewDidFinishScrolling(scrollView)
    }
}
