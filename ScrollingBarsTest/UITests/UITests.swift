//
//  UITests.swift
//  UITests
//
//  Created by Taisuke Hori on 2015/01/13.
//  Copyright (c) 2015年 Hori Taisuke. All rights reserved.
//

import XCTest

class UITests: KIFTestCase {
    
    override func setUp() {
        super.setUp()

        let scrollView = tester().waitForViewWithAccessibilityLabel("ScrollView") as UIScrollView

        scrollY(2000)
        scrollX(2000)
        if topBarPosition() != CGFloat(0.0) {
            XCTAssertEqual(topBarPosition(), CGFloat(10.0))
            XCTAssertEqual(bottomBarPosition(), CGFloat(0.0))
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func topBarPosition() -> CGFloat {
        let topBar = tester().waitForViewWithAccessibilityLabel("TopBar")
        return -topBar.frame.origin.y
    }
    
    // MARK: -
    
    func bottomBarPosition() -> CGFloat {
        let scrollView = tester().waitForViewWithAccessibilityLabel("ScrollView") as UIScrollView
        let bottomBar = tester().waitForViewWithAccessibilityLabel("BottomBar")

        return bottomBar.frame.origin.y - (scrollView.frame.size.height - bottomBar.frame.size.height)
    }
    
    let topBarMaxPosition: CGFloat = 44.0
    let bottomBarMaxPosition: CGFloat = 44.0
    
    func scrollX(distance: CGFloat) {
        let scrollView = tester().waitForViewWithAccessibilityLabel("ScrollView") as UIScrollView
        let start: CGFloat = scrollView.contentOffset.x + 200
        scrollView.dragFromPoint(CGPointMake(start, 1), toPoint: CGPointMake(start + distance, 1), steps: 20)
    }
    
    func scrollY(distance: CGFloat) {
        let scrollView = tester().waitForViewWithAccessibilityLabel("ScrollView") as UIScrollView
        let start: CGFloat = scrollView.contentOffset.y + 500
        scrollView.dragFromPoint(CGPointMake(1, start), toPoint: CGPointMake(1, start + distance), steps: 20)
    }
    
    // MARK: - Test Case
    
    func testDragUpFromTop() {
        scrollY(-500)

        XCTAssertEqual(topBarPosition(), topBarMaxPosition)
        XCTAssertEqual(bottomBarPosition(), bottomBarMaxPosition)
    }
    
    func testDragDownFromTop() {
        scrollY(100)
        
        XCTAssertEqual(topBarPosition(), CGFloat(10.0))
        XCTAssertEqual(bottomBarPosition(), CGFloat(0.0))
    }
    
    func testBarsAreHidden_then_DragDown() {
        // scroll and hide bars
        scrollY(-500)
        
        scrollY(100)
        
        XCTAssertEqual(topBarPosition(), topBarMaxPosition)
        XCTAssertEqual(bottomBarPosition(), bottomBarMaxPosition)
    }
    
    func testBarsAreHidden_then_SwipeDown() {
        // scroll and hide bars
        scrollY(-500)
        
        tester().swipeViewWithAccessibilityLabel("ScrollView", inDirection: KIFSwipeDirection.Down)
        
        XCTAssertEqual(topBarPosition(), CGFloat(0.0))
        XCTAssertEqual(bottomBarPosition(), CGFloat(0.0))
    }
    
    func testBarsAreHidden_then_DragDownFromTop() {
        // scroll and hide bars
        scrollY(-topBarMaxPosition)
        
        scrollY(100)
        
        XCTAssertEqual(topBarPosition(), CGFloat(0.0))
        XCTAssertEqual(bottomBarPosition(), CGFloat(0.0))
    }
    
    func testBarsAreHidden_then_DragDownThroughTop() {
        // scroll and hide bars
        scrollY(-100)
        
        scrollY(200)
        
        XCTAssertEqual(topBarPosition(), CGFloat(0.0))
        XCTAssertEqual(bottomBarPosition(), CGFloat(0.0))
    }
    
    func testBarsAreAppear_then_scrollUpLittle() {
        // scroll and hide bars
        scrollY(-topBarMaxPosition/10)
        
        XCTAssertEqual(topBarPosition(), CGFloat(0.0))
        XCTAssertEqual(bottomBarPosition(), CGFloat(0.0))
    }
    
    func testBarsAreAppear_then_scrollUpOverHalfOfTopBarHeight() {
        // scroll and hide bars
        scrollY(-topBarMaxPosition/3*2)

        XCTAssertEqual(topBarPosition(), topBarMaxPosition)
        XCTAssertEqual(bottomBarPosition(), bottomBarMaxPosition)
    }
    
    func testDragFromBottom() {
        // scroll to bottom
        scrollY(-2000)

        XCTAssertEqual(topBarPosition(), topBarMaxPosition)
        XCTAssertEqual(bottomBarPosition(), bottomBarMaxPosition)

        // scroll from bottom
        scrollY(-2000)

        XCTAssertEqual(topBarPosition(), CGFloat(0.0))
        XCTAssertEqual(bottomBarPosition(), CGFloat(0.0))
    }

    func testBarsAreAppear_DragHorizontal() {
        // scroll to bottom
        scrollX(-200)
        
        XCTAssertEqual(topBarPosition(), CGFloat(0.0))
        XCTAssertEqual(bottomBarPosition(), CGFloat(0.0))
    }

    func testBarsAreHidden_DragHorizontal() {
        // scroll to bottom
        scrollY(-200)
        scrollX(-200)
        
        XCTAssertEqual(topBarPosition(), topBarMaxPosition)
        XCTAssertEqual(bottomBarPosition(), bottomBarMaxPosition)
    }
}
