//
//  UIImageExtension.swift
//  Award Bureau
//
//  Created by PRASHANT DWIVEDI on 21/09/18.
//  Copyright © 2018 Jitesh. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

typealias ImageCompletionBlock = (Bool) -> (Void)

@objc extension UIImageView {
    
    @objc func set_sdWebImage(With URLstring: String ,placeHolderImage: String)  {
        if placeHolderImage.count <= 0 {
            (self as UIView).sd_addActivityIndicator()
            (self as UIView).sd_setIndicatorStyle(UIActivityIndicatorViewStyle.white )
        }
        (self as UIView).sd_setIndicatorStyle(UIActivityIndicatorViewStyle.white )
        
        let imageurl = URLstring.replacingOccurrences(of:" ", with:"")
        self.sd_setImage(with: (NSURL.init(string: imageurl)! as URL), placeholderImage: UIImage(named:placeHolderImage) , options: SDWebImageOptions.refreshCached) { (image, error, type, url) in
            
            if(error == nil) {
                
                if type == SDImageCacheType.none || type == SDImageCacheType.disk {
                    UIView.transition(with: self, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
//                        self.image = nil
                        self.image = image
                        
                    }, completion:nil)
                }
                else
                {
                    self.backgroundColor = UIColor.clear
                }
            }
        }
    }
    
    @objc func set_sdWebImage(With URLstring: String ,placeHolderImage: String, completionBlock: @escaping ImageCompletionBlock)  {
        if placeHolderImage.count <= 0 {
            (self as UIView).sd_addActivityIndicator()
            (self as UIView).sd_setIndicatorStyle(UIActivityIndicatorViewStyle.white )
        }

        let imageurl = URLstring.replacingOccurrences(of:" ", with:"")
        self.sd_setImage(with: (NSURL.init(string: imageurl)! as URL), placeholderImage: UIImage(named:placeHolderImage) , options: SDWebImageOptions.refreshCached) { (image, error, type, url) in
            
            if(error == nil) {
                
                if type == SDImageCacheType.none || type == SDImageCacheType.disk {
                    UIView.transition(with: self, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
//                        self.image = nil
                        self.image = image
                        completionBlock(true)
                    }, completion:nil)
                }
                else
                {
                    completionBlock(true)
                    self.backgroundColor = UIColor.clear
                }
            }
            completionBlock(true)
        }
    }
}
