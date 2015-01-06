//
//  ScrollingBars.swift
//  HoboFun
//
//  Created by Taisuke Hori on 2014/12/28.
//  Copyright (c) 2015年 Hori Taisuke. All rights reserved.
//

public protocol ScrollingBarsDelegate {
    var topBarPosition: CGFloat { get set }
    var topBarHeight: CGFloat { get }
    var topBarMinHeight: CGFloat { get }
    var bottomBarPosition: CGFloat { get set }
    var bottomBarHeight: CGFloat { get }
    var bottomBarMinHeight: CGFloat { get }
}

public class ScrollingBars: NSObject, UIScrollViewDelegate {

    var scrollView: UIScrollView!
    var delegate: ScrollingBarsDelegate!
    var proxyDelegate: UIScrollViewDelegate?

    var isScrollViewDragging: Bool = false
    var scrollBeginOffset: CGPoint = CGPoint()
    var scrollPrevPoint: CGPoint = CGPoint()
    var scrollDirection: Int = 0
    var isScrollFromBottomLine: Bool = false
    var isUpdateingInset: Bool = false

    // MARK: public

    public func follow(scrollView : UIScrollView, delegate: ScrollingBarsDelegate) {
        self.scrollView = scrollView
        self.delegate = delegate
        self.updateContentInset()
    }
    
    public func showBars(#animate: Bool) {
        let changeFunc: () -> Void = {
            self.delegate.topBarPosition = 0
            self.delegate.bottomBarPosition = 0
            self.updateContentInset()
        }
        if (animate) {
            // 何故か dispatch_async に入れないと inset の変化が滑らかに動かなかった
            dispatch_async(dispatch_get_main_queue()) {
                UIView.animateWithDuration(self.animationDuration, animations: changeFunc)
            }
        } else {
            changeFunc()
        }
    }

    public func hideBars(#animate: Bool) {
        let changeFunc: () -> Void = {
            self.delegate.topBarPosition = self.topBarMaxPosition()
            self.delegate.bottomBarPosition = self.bottomBarMaxPosition()
            self.updateContentInset()
        }
        if (animate) {
            // 何故か dispatch_async に入れないと inset の変化が滑らかに動かなかった
            dispatch_async(dispatch_get_main_queue()) {
                UIView.animateWithDuration(self.animationDuration, animations: changeFunc, completion:nil)
            }
        } else {
            changeFunc()
        }
    }
    
    public func refresh(#animated: Bool) {
        if self.delegate == nil {
            return
        }

        if self.isTopBarHidden() || self.isBottomBarHidden() {
            self.hideBars(animate: animated)
        } else {
            self.showBars(animate: animated)
        }
    }
    
    // MARK: - ScrollView Delegate

    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.scrollBeginOffset = self.scrollView.contentOffset
        self.scrollPrevPoint = scrollView.panGestureRecognizer.locationInView(scrollView.superview)
        self.isScrollViewDragging = true
        self.isScrollFromBottomLine = scrollView.contentSize.height - scrollView.frame.size.height <= self.scrollBeginOffset.y + CGFloat(FLT_EPSILON) && (self.isBottomBarHidden() || self.bottomBarMaxPosition() == 0)
    }

    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.isScrollViewDragging = false
        
        if !decelerate {
            if self.isTopBarHalfWay() || self.isBottomBarHalfWay() {
                let isUnderTopBar = scrollView.contentOffset.y < -self.delegate.topBarMinHeight
                let appearRatio = self.delegate.bottomBarPosition / self.bottomBarMaxPosition()
                if isUnderTopBar || appearRatio <=  self.barAppearThreshold {
                    self.showBars(animate: true)
                } else {
                    self.hideBars(animate: true)
                }
            }
        }
    }

    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if !self.isScrollViewDragging {
            return
        }
        if self.isUpdateingInset {
            return
        }
        

        let currentPoint = scrollView.panGestureRecognizer.locationInView(scrollView.superview)

        if currentPoint.y == self.scrollPrevPoint.y {
            self.scrollDirection = 0
        } else if currentPoint.y < self.scrollPrevPoint.y {
            self.scrollDirection = 1
        } else {
            self.scrollDirection = -1
        }

        let scrollDistanceFromPrev = -(currentPoint.y - self.scrollPrevPoint.y)
        self.scrollPrevPoint = currentPoint

        let isSmallContentSize = scrollView.contentSize.height <= scrollView.frame.size.height - self.delegate.topBarHeight + CGFloat(FLT_EPSILON)
        let isScrollOverBottom = scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height - CGFloat(FLT_EPSILON)

        if isSmallContentSize {
            // do nothing
        } else if isScrollOverBottom {
            if self.isBottomBarHidden() && self.isScrollFromBottomLine {
                self.showBars(animate: true)
            }
        } else {
            let isUnderTopBar = scrollView.contentOffset.y < -self.delegate.topBarMinHeight && scrollView.contentOffset.y >= -self.delegate.topBarHeight
            let isOverUnderTopBar = scrollView.contentOffset.y < -self.delegate.topBarHeight
            if (!self.isTopBarHidden() || isUnderTopBar) && !isOverUnderTopBar && !self.isScrollFromBottomLine {
                self.delegate.topBarPosition = min(self.topBarMaxPosition(), max(0, scrollDistanceFromPrev + self.delegate.topBarPosition))
            }
            if (!self.isBottomBarHidden() || isUnderTopBar) && !isOverUnderTopBar && !self.isScrollFromBottomLine {
                self.delegate.bottomBarPosition = min(self.bottomBarMaxPosition(), max(0, scrollDistanceFromPrev + self.delegate.bottomBarPosition))
                let prevTop = self.scrollView.contentInset.top
                self.updateContentInset()
            }
        }
    }
    
    public func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        if self.scrollDirection < 0 {
            if !self.isTopBarFullAppear() || !self.isBottomBarFullAppear() {
                self.showBars(animate: true)
            }
        } else if self.scrollDirection > 0 {
            let isScrollOverBottom = scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height - CGFloat(FLT_EPSILON)
            if !(self.isTopBarHidden() && self.isBottomBarHidden()) && !(self.isBottomBarFullAppear() && (isScrollOverBottom || scrollView.contentOffset.y < 0)) {
                self.hideBars(animate: true)
            }
        }
    }
    
    public func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        if !self.isTopBarFullAppear() {
            self.showBars(animate: true)
            return false
        }
        return true
    }

    // MARK: - Internal Func

    func updateContentInset() {
        self.isUpdateingInset = true
        self.scrollView.contentInset = UIEdgeInsetsMake(
            self.delegate.topBarHeight - self.delegate.topBarPosition,
            self.scrollView.contentInset.left,
            self.delegate.bottomBarHeight - self.delegate.bottomBarPosition,
            self.scrollView.contentInset.right)
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
        self.isUpdateingInset = false
    }
    
    // MARK: - Constants

    var animationDuration: NSTimeInterval {
        return 0.2
    }
    
    var barAppearThreshold: CGFloat {
        return 1 / 4
    }
    
    // MARK: - Bar State
    
    func topBarMaxPosition() -> CGFloat {
        return self.delegate.topBarHeight - self.delegate.topBarMinHeight
    }
    
    func isTopBarHidden() -> Bool {
        return self.delegate.topBarPosition >= self.topBarMaxPosition()
    }

    func isTopBarFullAppear() -> Bool {
        return self.delegate.topBarPosition == 0
    }

    func isTopBarHalfWay() -> Bool {
        return !isTopBarHidden() && !isTopBarFullAppear()
    }
    
    func bottomBarMaxPosition() -> CGFloat {
        return self.delegate.bottomBarHeight - self.delegate.bottomBarMinHeight
    }
    
    func isBottomBarHidden() -> Bool {
        return self.delegate.bottomBarPosition >= self.bottomBarMaxPosition()
    }

    func isBottomBarFullAppear() -> Bool {
        return self.delegate.bottomBarPosition == 0
    }
    
    func isBottomBarHalfWay() -> Bool {
        return !isBottomBarHidden() && !isBottomBarFullAppear()
    }
}
