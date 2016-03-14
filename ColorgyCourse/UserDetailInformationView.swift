//
//  UserDetailInformationView.swift
//  ColorgyCourse
//
//  Created by David on 2016/2/2.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class UserDetailInformationView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
	
	private var containerScrollView: UIScrollView = UIScrollView()
	private var detailDescriptionContainerView: UIView = UIView()
	
	convenience init(withBlurPercentage percentage: Int?, withUserImage image: UIImage?, user: ChatUserInformation?) {
		self.init()
		
		// dismiss
		self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissView"))
		
		self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
		
		// configure user image view
		let userImageView = UIImageView(frame: CGRectMake(0, 0, self.bounds.width * 0.5, self.bounds.width * 0.5))
		userImageView.center = self.center
		userImageView.center.y = self.center.y * 0.7
		userImageView.layer.cornerRadius = userImageView.bounds.width / 2
		userImageView.clipsToBounds = true
		userImageView.contentMode = .ScaleAspectFill
		
		userImageView.layer.borderColor = UIColor.whiteColor().CGColor
		userImageView.layer.borderWidth = 2.0
		
		// loading image indicator
		let loadingView = UIActivityIndicatorView()
		loadingView.tintColor = ColorgyColor.MainOrange
		loadingView.center = CGPoint(x: userImageView.bounds.midX, y: userImageView.bounds.midY)
		userImageView.addSubview(loadingView)
		loadingView.startAnimating()
		
		// loading blur image
		if let image = image {
			if let percentage = percentage {
				let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
				dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
					var radius: CGFloat = 0.0
					radius = (33 - CGFloat(percentage < 98 ? percentage : 98) % 33) / 33.0 * 4.0
					print(radius)
					print(percentage)
					let blurImage = UIImage.gaussianBlurImage(image, radius: radius)
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						userImageView.image = blurImage
						loadingView.stopAnimating()
						loadingView.removeFromSuperview()
					})
				})
			}
		}
		
		// title of this view
		let title = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 21))
		title.font = UIFont.systemFontOfSize(20)
		title.textAlignment = .Center
		title.textColor = UIColor.whiteColor()
		title.center = self.center
		
		// subtitle of this view
		let subtitle = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 18))
		subtitle.font = UIFont.systemFontOfSize(16)
		subtitle.textAlignment = .Center
		subtitle.textColor = UIColor.whiteColor()
		subtitle.center = self.center
		
		// arrange title
		title.frame.origin.y = userImageView.frame.maxY + 20
		subtitle.frame.origin.y = title.frame.maxY + 8
		
		// set text
		title.text = user?.name
		subtitle.text = user?.lastAnswer
		
		// percentage label
		let percenageLabel = UILabel(frame: CGRectMake(0, 0, 66, 28))
		percenageLabel.layer.cornerRadius = 13.0
		percenageLabel.clipsToBounds = true
		percenageLabel.text = "30%"
		percenageLabel.textAlignment = .Center
		percenageLabel.textColor = UIColor.whiteColor()
		percenageLabel.backgroundColor = ColorgyColor.MainOrange
		let centerOfUserImageView: CGPoint = userImageView.center
		let radius: CGFloat = userImageView.bounds.width / 2
		// arrange
		let x = centerOfUserImageView.x + cos(60.0.RadianValue).CGFloatValue * radius
		let y = centerOfUserImageView.y + sin(60.0.RadianValue).CGFloatValue * radius
		percenageLabel.center = CGPoint(x: x, y: y)
		
		// configure container scroll view
		containerScrollView = UIScrollView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
		containerScrollView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
		
		// adding subview
		containerScrollView.addSubview(userImageView)
		containerScrollView.addSubview(title)
		containerScrollView.addSubview(subtitle)
		containerScrollView.addSubview(percenageLabel)
		
		self.addSubview(containerScrollView)
		let g = generateAttributedLabel("hiiii", content: "fuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfuckfu", width: 50)
		g.center = containerScrollView.bounds.centerPoint
		g.anchorViewTo(containerScrollView)
		
		// adjust blur percentage
		if let percentage = percentage {
			if percentage > 100 {
				// set to 100%
				percenageLabel.text = "100%"
			} else if percentage < 0 {
				// set to 0%
				percenageLabel.text = "0%"
			} else {
				// ok!
				percenageLabel.text = "\(percentage)%"
			}
		} else {
			// error on percentage
			percenageLabel.text = "???%"
		}
		
		// expand the size of view according to size.
		expandContentSize()
	}
	
	func expandContentSize() {
//		self.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height*2)
	}
	
	func generateDetailDescriptionContainerView(school: String, ) -> UIView {
		
	}
	
	func generateAttributedLabel(title: String, content: String, width: CGFloat) -> UILabel {
		
		// 0
		let attributedLabel = UILabel()

		// 1
		let string = "\(title)：\(content)" as NSString
		let attributedString = NSMutableAttributedString(string: string as String)
		
		// 2
		let grayAttributes = [NSForegroundColorAttributeName: ColorgyColor.grayContentTextColor, NSFontAttributeName: UIFont.systemFontOfSize(15.0)]
		let contentWhiteAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(15.0)]
  
		// 3
		attributedString.addAttributes(grayAttributes, range: string.rangeOfString("\(title)："))
		attributedString.addAttributes(contentWhiteAttributes, range: string.rangeOfString(content))
		
		// 4
		attributedLabel.attributedText = attributedString
		
		// 5
		attributedLabel.frame.size.width = width
		attributedLabel.numberOfLines = 0
		attributedLabel.sizeToFit()
		
		// resize
		if attributedLabel.bounds.width < width {
			attributedLabel.frame.size.width = width
		}
		
		// 6
		return attributedLabel
	}
	
	func dismissView() {
		self.removeFromSuperview()
	}
	
	init() {
		super.init(frame: UIScreen.mainScreen().bounds)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

}
