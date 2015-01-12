//
//  DetailViewController.swift
//  ScrollingBarsTest
//
//  Created by Taisuke Hori on 2015/01/12.
//  Copyright (c) 2015年 Hori Taisuke. All rights reserved.
//

import UIKit
import ScrollingBars

class MyScrollViewController: UIViewController, ScrollingBarsDelegate {
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottombarBottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var topBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topBarTopSpaceConstraint: NSLayoutConstraint!
    
    var scrollingBars = ScrollingBars()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.scrollingBars.follow(self.scrollView, delegate: self)
        self.scrollView.delegate = self.scrollingBars
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: ScrollingBars
    
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
            self.topBar.layoutIfNeeded()
        }
    }
    
    var bottomBarHeight: CGFloat {
        return self.bottomBar.frame.size.height
    }
    
    var bottomBarPosition: CGFloat {
        get {
            return -self.bottombarBottomSpaceConstraint.constant
        }
        set {
            self.bottombarBottomSpaceConstraint.constant = -newValue
            self.bottomBar.layoutIfNeeded()
        }
    }
    
    var bottomBarMinHeight: CGFloat {
        return 0
    }
    
}

