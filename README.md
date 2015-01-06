# Introduction

## What is it?

`ScrollingBars` make Top Bar and Bottom Bar follow scrollilng of a UIScrollVieww or similar view (e.g. UITableView or UIWebView). It works like the in Safari app for iOS8.


## UIKit Dynamics?

`MSDynamicsDrawerViewController` integrates with Apple's UIKit Dynamics APIs (new in iOS7) to provide a realistic new feel to the classic drawer navigation paradigm. While the `.gifs` below can do it some justice, it's best to just clone, build, and run the example project on a device to get a feel for it how it performs.

## So what can I do with it?

![](ScreenShot1.gif)
# Installation

Add the following to your `Podfile` and run `$ pod install`.

``` ruby
pod 'ScrollingBars
```

 If you don't have CocoaPods installed or integrated into your project, you can learn how to do so [here](http://cocoapods.org).

# Documentation

## Xcode

If you would like to install the `MSDynamicsDrawerViewController` documentation into Xcode, you can do so by first installing [Appledoc](https://github.com/tomaz/appledoc/) (`$ brew install appledoc`), and then by running the `Documentation` target in the `MSDynamicsDrawerViewController.xcodeproj` in the root of repository.

# Example

`Example.xcworkspace` in the `Example` directory serves as an example implementation of `ScrollingBars`. It uses Cocoapods to link with the `ScrollingBars` source files in the root directory as a development pod. As such, use the example `xcworkspace` and not the `xcproj`.

# Usage

## Pane View Controller


# Requirements

Requires iOS 7.0, Swift.

# Contributing

Forks, patches and other feedback are welcome.

