//
//  UIImageExtension.swift
//  ColorgyCourse
//
//  Created by David on 2016/3/2.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

extension UIImage {
	class func gaussianBlurImage(image: UIImage, radius: CGFloat) -> UIImage? {
		
		guard let cgimg = image.CGImage else { return nil }
		
		let openGLContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
		let context = CIContext(EAGLContext: openGLContext)
		let coreImage = CoreImage.CIImage(CGImage: cgimg)
		let filter = CIFilter(name: "CIGaussianBlur")
		
		filter?.setValue(coreImage, forKey: kCIInputImageKey)
		filter?.setValue(radius, forKey: "inputRadius")
		
		guard let output = filter?.valueForKey(kCIInputImageKey) as? CoreImage.CIImage else { return nil }
		
		let cgimgResult = context.createCGImage(output, fromRect: output.extent)
		let result = UIImage(CGImage: cgimgResult)
		return result
	}
}