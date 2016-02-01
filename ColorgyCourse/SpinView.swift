//
//  SpinView.swift
//  ScrollViewWorkout
//
//  Created by David on 2015/12/14.
//  Copyright © 2015年 David. All rights reserved.
//

import UIKit

class SpinView: UIView {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    var imagePaths: [String]?
    var contentViews: [SpinContentView]?
	var contentTitle: [String]?
	var contentSubtitle: [String]?
    var rotatePercentage: Double = 0.0 {
        didSet {
            self.transform = CGAffineTransformMakeRotation(percentToDegree(rotatePercentage).RadianValue.CGFloatValue)
            if imagePaths != nil {
                if rotatePercentage >= ((imagePaths!.count - 1).DoubleValue / imagePaths!.count.DoubleValue) {
                    delegate?.enterLastPage()
                } else {
                    delegate?.notInLastPage()
                }
            }
        }
    }
    
    var delegate: SpinViewDelegate?
    
    func setupSpinContentView(frame: CGRect) {
//        self = UIView(frame: CGRectMake(0, 0, self.frame.height, self.frame.height))
//        self.center = CGPoint(x: center.x, y: frame.maxY)
//        self.clipsToBounds = true
        self.backgroundColor = UIColor(red:0.973,  green:0.588,  blue:0.502, alpha:1)
//        self.backgroundColor = UIColor(red:0.973,  green:0.888,  blue:0.802, alpha:1)
        self.layer.cornerRadius = self.bounds.size.height / 2
    }
    
	func attachImagesToSpinContentView(imagePaths: [String], titles: [String], subtitles: [String]) {
        var images: [UIImage] = [UIImage]()
        // get images
        for path in imagePaths {
            if let image = UIImage(named: path) {
                images.append(image)
            }
        }
        // attach it onto the view
        // calculate the center of the view
        let originOfSpinView = (x: self.bounds.width.DoubleValue / 2, y: self.bounds.height.DoubleValue / 2)
        // set start degree
        let startAngle = 90.0
        // radius
        let radiusOfSpinView = (self.bounds.height / 2).DoubleValue - 0
        contentViews = [SpinContentView]()
        // check the image counts
        for (index, image) : (Int, UIImage) in images.enumerate() {
            let degreesPerSpace = 360.0 / Double(images.count)
            let degreeOfImage = (index.DoubleValue * degreesPerSpace) - startAngle
            print(degreeOfImage)
            // calculate (x, y) with degree
            let x = cos(degreeOfImage.RadianValue) * radiusOfSpinView + originOfSpinView.x
            let y = sin(degreeOfImage.RadianValue) * radiusOfSpinView + originOfSpinView.y
            let positionOnSpinView = (x: x, y: y)
            print(positionOnSpinView)
            let imageWidth = UIScreen.mainScreen().bounds.height
            // generate view
            let contentView = SpinContentView(title: titles[index], subtitle: subtitles[index], image: image)
            let imageView = UIImageView(frame: CGRectMake(0, 0, imageWidth, imageWidth))
            imageView.contentMode = .ScaleAspectFit
            imageView.image = image
            
            // center the view
            contentView.center = CGPoint(x: positionOnSpinView.x, y: positionOnSpinView.y)
            imageView.center = CGPoint(x: positionOnSpinView.x, y: positionOnSpinView.y)
            // spin images on the view
            contentView.transform = CGAffineTransformMakeRotation((degreeOfImage + startAngle).RadianValue.CGFloatValue)
            
            self.addSubview(contentView)
            contentViews?.append(contentView)
        }
    }
    
    func degreesToRadians(angle: Double) -> CGFloat {
        return (M_PI * angle / 180.0).CGFloatValue
    }
    
    //    func updateUI(offset: CGFloat) {
    //        // calculate percentage
    //        let percent = offset / (topScrollView!.contentSize.width)
    //        print(percent)
    //        print("size \(topScrollView?.contentSize), now \(offset)")
    //        self?.transform = CGAffineTransformMakeRotation(percentToDegree(percent.DoubleValue).CGFloatValue.DoubleValue.RadianValue.CGFloatValue)
    //    }
    
    func percentToDegree(percent: Double) -> Double {
        return -360.0 * percent
    }
    
    func getFocusedToBottomScreen() {
        self.center = CGPoint(x: UIScreen.mainScreen().bounds.midX, y: UIScreen.mainScreen().bounds.maxY)
    }
    
    func moveBelowBottom(offset: CGFloat) {
        self.center = CGPoint(x: UIScreen.mainScreen().bounds.midX, y: UIScreen.mainScreen().bounds.maxY + offset)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSpinContentView(frame)
    }
    
	convenience init(radius: CGFloat, imagePaths: [String], titles: [String], subtitles: [String]) {
        self.init(frame: CGRectMake(0, 0, radius * 2, radius * 2))
        self.imagePaths = imagePaths
		attachImagesToSpinContentView(imagePaths, titles: titles, subtitles: subtitles)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

public protocol SpinViewDelegate {
    func enterLastPage()
    func notInLastPage()
}
