//
//  CourseCommentCell.swift
//  ColorgyCourse
//
//  Created by David on 2015/9/1.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class CourseCommentCell: UITableViewCell {

    // Outlets
    
    // necessary region
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdTimeLabel: UILabel!

    @IBOutlet weak var sideColorView: UIView!
    @IBOutlet weak var middleLineView: UIView!
    
    @IBOutlet weak var commentContentLabel: UILabel!
    
    // 3 stars
    @IBOutlet weak var praticalLabel: UILabel!
    @IBOutlet weak var praticalStarImageView1: UIImageView!
    @IBOutlet weak var praticalStarImageView2: UIImageView!
    @IBOutlet weak var praticalStarImageView3: UIImageView!
    @IBOutlet weak var praticalStarImageView4: UIImageView!
    @IBOutlet weak var praticalStarImageView5: UIImageView!
    
    
    @IBOutlet weak var sweetnessLabel: UILabel!
    @IBOutlet weak var sweetnessStarImageView1: UIImageView!
    @IBOutlet weak var sweetnessStarImageView2: UIImageView!
    @IBOutlet weak var sweetnessStarImageView3: UIImageView!
    @IBOutlet weak var sweetnessStarImageView4: UIImageView!
    @IBOutlet weak var sweetnessStarImageView5: UIImageView!
    
    @IBOutlet weak var hardLabel: UILabel!
    @IBOutlet weak var hardnessStarImageView1: UIImageView!
    @IBOutlet weak var hardnessStarImageView2: UIImageView!
    @IBOutlet weak var hardnessStarImageView3: UIImageView!
    @IBOutlet weak var hardnessStarImageView4: UIImageView!
    @IBOutlet weak var hardnessStarImageView5: UIImageView!
    
    // public API
    var userName: String! {
        didSet {
            updateUI()
        }
    }
    var userProfileImage: UIImage!
    
    private func updateUI() {
        
    }
    
    override func layoutSubviews() {
        self.userProfileImageView?.layer.cornerRadius = self.userProfileImageView.bounds.width / 2
        self.userProfileImageView?.clipsToBounds = true
    }
}
