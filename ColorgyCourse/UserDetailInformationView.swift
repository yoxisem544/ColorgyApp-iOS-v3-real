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
	private var closeButton: UIButton = UIButton()
	
	convenience init(withBlurPercentage percentage: Int?, withUserImage image: UIImage?, user: ChatUserInformation?) {
		self.init()
		
		// dismiss
//		self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissView"))
		
//		self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
		let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
		visualEffectView.frame = self.bounds
		self.addSubview(visualEffectView)
		
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
					print(blurImage)
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
		
		let w: CGFloat = 250.0
		let labels = generateContentLabels(user, width: 250)
		print(user)
		let constellation = user?.aboutHoroscope ?? " "
		let school = user?.organizationCode ?? "未知學校"
		let place = user?.aboutHabitancy ?? " "
		
		detailDescriptionContainerView = generateDetailDescriptionContainerView(school, constellation: constellation, whereAreYouFrom: place, detailDescriptionLabels: labels, width: w)
		containerScrollView.addSubview(detailDescriptionContainerView)
		
		// name and something
		title.text = user?.name
		subtitle.text = user?.lastAnswer
		
		// arrange
		detailDescriptionContainerView.frame.origin.y = 40.0 + subtitle.frame.maxY
		detailDescriptionContainerView.center.x = containerScrollView.bounds.midX
		
		// close button
		configureCloseButton()
		let closeButtonX: CGFloat = UIScreen.mainScreen().bounds.width - closeButton.bounds.width - 24.0
		let closeButtonY: CGFloat = 36.0
		closeButton.frame.origin = CGPoint(x: closeButtonX, y: closeButtonY)
		closeButton.anchorViewTo(self)
		
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
	
	private func expandContentSize() {
		containerScrollView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: detailDescriptionContainerView.frame.maxY + 40.0)
		print(containerScrollView.contentSize)
	}
	
	private func configureCloseButton() {
		closeButton = UIButton(type: UIButtonType.System)
		closeButton.tintColor = UIColor.whiteColor()
		closeButton.frame.size = CGSize(width: 36.0, height: 36.0)
//		closeButton.setImage(UIImage(named: "closeButton"), forState: UIControlState.Normal)
		closeButton.setTitle("✕", forState: UIControlState.Normal)
		closeButton.titleLabel?.font = UIFont.systemFontOfSize(24.0)
		closeButton.addTarget(self, action: "closeButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
	}
	
	internal func closeButtonClicked() {
		dismissView()
	}
	
	private func generateContentLabels(user: ChatUserInformation?, width: CGFloat) -> [UILabel] {
		guard let user = user else { return [] }
		var labels = [UILabel]()
		
		if let con = user.aboutConversation {
			labels.append(generateAttributedLabel("想聊的話題", content: con, width: width))
		}
		if let con = user.aboutPassion {
			labels.append(generateAttributedLabel("最近熱衷的事", content: con, width: width))
		}
		if let con = user.aboutExpertise {
			labels.append(generateAttributedLabel("專精的事情", content: con, width: width))
		}
		
		return labels
	}
	
	private func generateDetailDescriptionContainerView(school: String, constellation: String, whereAreYouFrom: String, detailDescriptionLabels: [UILabel], width: CGFloat) -> UIView {
		
		let containerView = UIView()
		let schoolLabel = UILabel()
		let detailLabel = UILabel()
		
		let padding: CGFloat = 16.0
		let textPadding: CGFloat = 8.0
		let upperPadding: CGFloat = 24.0
		let lineSpacing: CGFloat = 5.0
		
		let lineSpacingStyle = NSMutableParagraphStyle()
		lineSpacingStyle.lineSpacing = lineSpacing
		
		// configure
		schoolLabel.textColor = UIColor.whiteColor()
		schoolLabel.textAlignment = .Center
		schoolLabel.font = UIFont.systemFontOfSize(15.0)
		schoolLabel.frame.size.width = width
		schoolLabel.adjustsFontSizeToFitWidth = true
		schoolLabel.minimumScaleFactor = 0.5
		schoolLabel.text = school
		var string = school as NSString
		let schoolAttributedString = NSMutableAttributedString(string: school)
		schoolAttributedString.addAttribute(NSParagraphStyleAttributeName, value: lineSpacingStyle, range: string.rangeOfString(school))
		schoolLabel.attributedText = schoolAttributedString
		schoolLabel.sizeToFit()
		detailLabel.textColor = UIColor.whiteColor()
		detailLabel.textAlignment = .Center
		detailLabel.font = UIFont.systemFontOfSize(15.0)
		detailLabel.frame.size.width = width
		detailLabel.adjustsFontSizeToFitWidth = true
		detailLabel.minimumScaleFactor = 0.5
		detailLabel.text = "\(constellation) / \(whereAreYouFrom)"
		string = "\(constellation) / \(whereAreYouFrom)" as NSString
		let detailAttributedString = NSMutableAttributedString(string: string as String)
		detailAttributedString.addAttribute(NSParagraphStyleAttributeName, value: lineSpacingStyle, range: string.rangeOfString(string as String))
		detailLabel.attributedText = detailAttributedString
		detailLabel.sizeToFit()
		
		// arrange
		schoolLabel.frame.origin.y = upperPadding
		detailLabel.frame.origin.y = schoolLabel.frame.maxY
		
		// arrange views
		var heightOfLabels: CGFloat = detailLabel.frame.maxY
		for label in detailDescriptionLabels {
			// make space
			heightOfLabels += textPadding
			//arrage
			label.frame.origin.y = heightOfLabels
			// count its height
			heightOfLabels += label.bounds.height
		}
		
		// expand view
		let height = heightOfLabels + upperPadding
		let w = width + 2 * padding
		containerView.frame.size = CGSize(width: w, height: height)
		
		// center views
		detailLabel.center.x = containerView.bounds.midX
		schoolLabel.center.x = containerView.bounds.midX
		for label in detailDescriptionLabels {
			label.center.x = containerView.bounds.midX
		}
		
		// anchor views
		schoolLabel.anchorViewTo(containerView)
		detailLabel.anchorViewTo(containerView)
		for l in detailDescriptionLabels {
			l.anchorViewTo(containerView)
		}
		
		// border line
		containerView.layer.borderColor = ColorgyColor.grayContentTextColor.CGColor
		containerView.layer.borderWidth = 1.0
		containerView.layer.cornerRadius = 3.0
		
		// return
		return containerView
	}
	
	private func generateAttributedLabel(title: String, content: String, width: CGFloat) -> UILabel {
		
		// 0
		let attributedLabel = UILabel()

		// 1
		let string = "\(title)：\(content)" as NSString
		let attributedString = NSMutableAttributedString(string: string as String)
		
		// 2
		let grayAttributes = [NSForegroundColorAttributeName: ColorgyColor.grayContentTextColor, NSFontAttributeName: UIFont.systemFontOfSize(15.0)]
		let contentWhiteAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(15.0)]
		let lineSpacingStyle = NSMutableParagraphStyle()
		lineSpacingStyle.lineSpacing = 5.0
  
		// 3
		attributedString.addAttributes(grayAttributes, range: string.rangeOfString("\(title)："))
		attributedString.addAttributes(contentWhiteAttributes, range: string.rangeOfString(content))
		attributedString.addAttribute(NSParagraphStyleAttributeName, value: lineSpacingStyle, range: string.rangeOfString(string as String))
		
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
