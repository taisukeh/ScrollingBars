//
//  ViewController.swift
//  ScrollingBarsExample
//
//  Created by Taisuke Hori on 2015/01/06.
//  Copyright (c) 2015年 Hori Taisuke. All rights reserved.
//

import UIKit
import ScrollingBars

class ViewController: UIViewController, ScrollingBarsDelegate, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var bottomBar: UIToolbar!

    @IBOutlet weak var topBarTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var topBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBarBottomSpaceConstraint: NSLayoutConstraint!

    var scrollingBars = ScrollingBars()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollingBars.follow(webView.scrollView, delegate: self)
        webView.scrollView.delegate = scrollingBars
        webView.delegate = self
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://en.wikipedia.org/wiki/Scroll")!))
    }

    func setTopBarElementAlpha(alpha: CGFloat) {
        for view in topBar.subviews as [UIView] {
            view.alpha = alpha
        }
    }

    // MARK: - ScrollingBars
    
    var topBarHeight: CGFloat {
        return self.topBar.frame.size.height
    }
    
    var topBarMinHeight: CGFloat {
        if UIApplication.sharedApplication().statusBarFrame.size.height > 20  {
            // In-Call statusbar
            return 0
        } else {
            return UIApplication.sharedApplication().statusBarFrame.size.height
        }
    }

    var topBarPosition: CGFloat {
        get {
            return -self.topBarTopSpaceConstraint.constant
        }
        set {
            self.topBarTopSpaceConstraint.constant = -newValue
            let hiddingRatio = newValue / (self.topBarHeight - self.topBarMinHeight)
            self.setTopBarElementAlpha(1 - hiddingRatio)
            self.topBar.layoutIfNeeded()
        }
    }

    var bottomBarHeight: CGFloat {
        return self.bottomBar.frame.size.height
    }
    
    var bottomBarPosition: CGFloat {
        get {
            return -self.bottomBarBottomSpaceConstraint.constant
        }
        set {
            self.bottomBarBottomSpaceConstraint.constant = -newValue
            self.bottomBar.layoutIfNeeded()
        }
    }

    var bottomBarMinHeight: CGFloat {
        return 0
    }

    // MARK: - orientation

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context : UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.updateTopBarHeight()
            }, completion: nil)
    }
    
    func updateTopBarHeight() {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        var height: CGFloat
        if orientation.isPortrait || UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            height = 64
        } else {
            height = 44
        }

        let isHeightChanged = self.topBarHeightConstraint.constant != height
        if isHeightChanged {
            self.topBarHeightConstraint.constant = height
            self.topBar.layoutIfNeeded()
            self.scrollingBars.refresh(animated: false)
        }
    }
    
    // MARK: - UIWebViewDelegate
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .LinkClicked:
            scrollingBars.showBars(animate: true)
        default:
            break
        }
        return true
    }

    // MARK: - ScrollView Delegate

    /**

    If you can't overwrite UIScrollView's delegate (e.g. You uses UITableView),
    pass scroll view events to ScrollingBars.

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollingBars.scrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollingBars.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollingBars.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        scrollingBars.scrollViewWillBeginDecelerating(scrollView)
    }
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        return scrollingBars.scrollViewShouldScrollToTop(scrollView)
    }

    */

}

