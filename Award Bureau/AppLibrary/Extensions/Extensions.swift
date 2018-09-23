//
//  Extensions.swift
//  Award Bureau
//
//  Created by Sushobhit Jain on 01/09/18.
//  Copyright © 2018 Sushobhit Jain. All rights reserved.
//

import Foundation
import MBProgressHUD
import QuartzCore
import UIKit

@objc enum BarButtonPosition: Int {
    case BarButtonPositionLeft = 0
    case BarButtonPositionRight
}

@objc public enum  navigationType: Int {
    case Transparent,
    black
}

@objc public enum  BackButtonType: Int {
    case black,
    white,
    defaultColor
}

@objc public enum RemoveButtonType: Int {
    case left,
    right,
    all
}



extension Dictionary {
    
    static func += (left: inout [Key: Value], right: [Key: Value]) {
        for (key, value) in right {
            left[key] = value
        }
    }
}


extension UITableViewController {
    func showHudForTable(_ message: String) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = message
        hud.isUserInteractionEnabled = false
        hud.layer.zPosition = 2
        self.tableView.layer.zPosition = 1
    }
}

extension UIViewController {
    func removeKeyboard()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabOnScreen))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tabOnScreen()
    {
        self.view.endEditing(true)
    }
    
    func showHud(_ message: String) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = message
        hud.isUserInteractionEnabled = true
//        hud.bezelView.backgroundColor = UIColor.clear
        hud.contentColor = UIColor.white
    }
    
    func hideHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func showEclipse()
    {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .customView
        let imagV = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        var imageArr = [UIImage]()
        for i in 0..<26
        {
            imageArr.append(UIImage(named: "frame-\(i)")!)
        }
        imagV.animationImages = imageArr
        imagV.animationDuration = 0
        imagV.startAnimating()
        hud.customView = imagV
        hud.isSquare = true
        hud.backgroundView.color = UIColor.black.withAlphaComponent(0.5)

    }
    
    
    @objc public func showAlertMessage(titleStr:String, messageStr:String ) {
        
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel){ _ in
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc public func showAlertMessage(titleStr:String, messageStr:String, CancelTitle: String) {
        
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: CancelTitle, style: .cancel){ _ in
            
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc public func showAlertMessageWithDone(titleStr: String, messageStr: String, preferdStyle: UIAlertControllerStyle, CancelTitle: String, otherTitle: String, completionBlock: @escaping (Bool) -> Void ) {
        
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: preferdStyle)
        
        alert.addAction(UIAlertAction(title: CancelTitle, style: .cancel){ _ in
            completionBlock(false)
        })
        if otherTitle != "" {
            alert.addAction(UIAlertAction(title: otherTitle, style: .default){ _ in
                completionBlock(true)
            })
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc public func Push(controller : UIViewController) {
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    @objc public func PopBack() {
        self.navigationController!.popViewController(animated: true)
    }
    
    @objc public func PopToRoot() {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    @objc public func PopTo(Controller controller : UIViewController) {
        self.navigationController!.popToViewController(controller, animated: true)
    }
    
    @objc func removeNavigationButton(removetype: RemoveButtonType ) {
        switch removetype {
        case .left:
            navigationItem.setLeftBarButton(nil, animated: true)
            break
            
        case .right:
            navigationItem.setRightBarButton(nil, animated: true)
            break
            
        case .all:
            navigationItem.setLeftBarButton(nil, animated: true)
            navigationItem.setRightBarButton(nil, animated: true)
            break
        }
    }
    
    @objc func setBackBarButton(With ButtonType: BackButtonType ) {
        
        let btn1 = UIButton(type: .custom)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(BackButtonClicked), for: .primaryActionTriggered)
        
        switch ButtonType {
        case .black:
            btn1.setImage(UIImage(named: "back_black"), for: .normal)
            break
            
        case .white:
            btn1.setImage(UIImage(named: "back"), for: .normal)
            break
            
        default:
            btn1.setImage(UIImage(named: "back"), for: .normal)
        }
        
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: btn1), animated: true)
    }
    
    @objc func setNavigationBar(Navigationtype: navigationType ) {
        
        if Navigationtype == .Transparent {
            navigationController?.isNavigationBarHidden = false
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
//            UIApplication.shared.setStatusBarStyle(.default, animated: true)
        }
        else {
            navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
            navigationController?.navigationBar.shadowImage = nil
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = UIColor.init(red: 51.0/255.0, green: 50.0/255.0, blue: 68.0/255.0, alpha: 1.0)
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//            UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        }
    }
    
    @objc func rightNavigationButton() {
    }
    
    @objc func leftNavigationButton() {
    }
    
    @objc func BackButtonClicked() {
        PopBack()
    }
    
    @objc func userImageButtonClicked() {
        //        PopBack()
    }
    
    @objc public func  setNavigationTitle(withTitle title: String, withNavigationType type : navigationType) {
        self.navigationItem.title = title
        setNavigationBar(Navigationtype:type)
    }
    
    // MARK:- Set BarButton Item Button With Image
    @objc func setBarButtonItem(withButtonImage: String?, withPosition: BarButtonPosition, needAdjustMent: Bool) {
        
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: withButtonImage!), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        if withPosition == .BarButtonPositionLeft {
            self.navigationItem.leftBarButtonItem = nil
            btn1.addTarget(self, action: #selector(leftNavigationButton), for: .primaryActionTriggered)
            self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: btn1), animated: true)
        }
        else {
            self.navigationItem.rightBarButtonItem = nil
            btn1.addTarget(self, action: #selector(rightNavigationButton), for: .primaryActionTriggered)
            self.navigationItem.setRightBarButton(UIBarButtonItem(customView: btn1), animated: true)
        }
    }
    
    // MARK:- Set BarButton Item Button With Text
    @objc func setBarButtonItem(withButtonTitle: String?, withPosition: BarButtonPosition, needAdjustMent: Bool) {
        
        let btn1 = UIButton(type: .custom)
        btn1.setTitle(withButtonTitle, for: .normal)
        btn1.setTitleColor(UIColor.gray, for: .normal)
        
        if #available(iOS 11.0, *), needAdjustMent {
            btn1.frame = CGRect(x: 0, y: 7, width: 60, height: 30)
        }
        else {
            btn1.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        }
        
        if withPosition == .BarButtonPositionLeft {
            btn1.addTarget(self, action: #selector(leftNavigationButton), for: .primaryActionTriggered)
            self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: btn1), animated: true)
        }
        else {
            btn1.addTarget(self, action: #selector(rightNavigationButton), for: .primaryActionTriggered)
            self.navigationItem.setRightBarButton(UIBarButtonItem(customView: btn1), animated: true)
        }
    }
    
    //MARK:- set title for navigation
    @objc public func setTitle(_ title: String, isBold: Bool) {
        self.title = title
    }
    
    // MARK:- Create View with image and text
    @objc func setBarButtonItem(withImage: String, withTitle: String, withPosition: BarButtonPosition) {
        
        let titleLabel = UILabel.init()
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 11) // UIFont.CA_AppFont(with: .Regular, withSize: 11)
        titleLabel.text = withTitle
        titleLabel.textColor = UIColor.black
        
        let titleSize = withTitle.size(withAttributes: [
            NSAttributedStringKey.font : titleLabel.font
            ])
        
        if titleSize.width < 30 {
            titleLabel.frame = CGRect.init(x: 2, y: 25, width: 30, height: 13)
        }
        else if titleSize.width > 60 {
            titleLabel.frame = CGRect.init(x: 2, y: 25, width: 60, height: 13)
        }
        else {
            titleLabel.frame = CGRect.init(x: 2, y: 25, width: titleSize.width, height: 13)
        }
        
        let imageView = UIImageView.init(frame: CGRect.init(x: ((titleLabel.frame.size.width/2) - 12.5) + titleLabel.frame.origin.x, y: 0, width: 25, height: 25))
        imageView.image = UIImage.init(named: withImage)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: titleLabel.frame.size.width + 4, height: 38))
        
        let btn1 = UIButton(type: .custom)
        btn1.frame = view.frame
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(btn1)
        
        if withPosition == .BarButtonPositionLeft {
            btn1.addTarget(self, action: #selector(leftNavigationButton), for: .primaryActionTriggered)
            self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: view), animated: true)
        }
        else {
            btn1.addTarget(self, action: #selector(rightNavigationButton), for: .primaryActionTriggered)
            self.navigationItem.setRightBarButton(UIBarButtonItem(customView: view), animated: true)
        }
    }
    
    
    // MARK:- Create View with image and text
    @objc func setBarButtonItem(withImage: String, withPosition: BarButtonPosition) {
        
        let imageSize = UIImage.init(named: withImage)?.size
        
        
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: (imageSize?.width)! > CGFloat(30) ? (imageSize?.width)! : 30, height: (imageSize?.height)! > CGFloat(40) ? (imageSize?.height)! : 40))
        imageView.image = UIImage.init(named: withImage)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        if withPosition == .BarButtonPositionLeft {
            self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: imageView), animated: true)
        }
        else {
            self.navigationItem.setRightBarButton(UIBarButtonItem(customView: imageView), animated: true)
        }
    }
    
//    @objc func setleftNavigationItems(WithBackButtonType ButtonType: BackButtonType, withUserImage imageUrl: String?) {
//
//        ////// back button
//        let btn1 = UIButton(type: .custom)
//        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        btn1.addTarget(self, action: #selector(BackButtonClicked), for: .touchUpInside)
//
//        switch ButtonType {
//        case .black:
//            btn1.setImage(UIImage(named: "back_black"), for: .normal)
//            break
//
//        case .white:
//            btn1.setImage(UIImage(named: "back_white"), for: .normal)
//            break
//
//        default:
//            btn1.setImage(UIImage(named: "back_white"), for: .normal)
//        }
//
//        ////// User Image
//        let imageBtn = UIButton(type: .custom)
//        imageBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        imageBtn.addTarget(self, action: #selector(userImageButtonClicked), for: .touchUpInside)
//        imageBtn.backgroundColor = .red
//        imageBtn.setImage(UIImage(named: "user"), for: .normal)
//        imageBtn.setTitle("", for: .normal)
//        imageBtn.contentMode = .scaleAspectFit
//        imageBtn.layer.cornerRadius = 15
//        imageBtn.clipsToBounds = true
//
//        if imageUrl != nil {
//
//            SDWebImageManager.shared().downloadImage(with: URL.init(string: imageUrl!), options: SDWebImageOptions.refreshCached, progress: {(receiveSize, targetSize)  in
//
//            }, completed: { (image, error, type, status, url) in
//                if(error == nil) {
//
//                    if type == SDImageCacheType.none || type == SDImageCacheType.disk {
//                        imageBtn.setImage(self.resizeImage(image: image!, newWidth: 35), for: .normal)
//                    }
//                    else
//                    {
//                        imageBtn.setImage(UIImage(named: "user"), for: .normal)
//                    }
//                }
//            })
//            self.navigationItem.setLeftBarButtonItems([UIBarButtonItem(customView: btn1), UIBarButtonItem(customView: imageBtn)], animated: true)
//        }
//        else {
//            self.navigationItem.setLeftBarButtonItems([UIBarButtonItem(customView: btn1)], animated: true)
//        }
//    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: newWidth, height: newWidth), false, UIScreen.main.scale)
        image.draw(in: CGRect.init(x: 0, y: 0, width: newWidth, height: newWidth))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
