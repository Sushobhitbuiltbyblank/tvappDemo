//
//  ABAlertViewController.swift
//  Award Bureau
//
//  Created by PRASHANT DWIVEDI on 21/09/18.
//  Copyright © 2018 Jitesh. All rights reserved.
//

import UIKit
class ABAlertViewController: UIViewController {
    
    @IBOutlet var heightC: NSLayoutConstraint!
    @IBOutlet var textV: UITextView!
    @IBOutlet var stackV: UIStackView!
    var message:String?
    var attributedMessage:NSAttributedString?
    @IBOutlet var messageL: UILabel!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet var noBtn: UIButton!
    var leftBtnTitle:String?
    var rightBtnTitle:String?
    var removeBtn:Bool = false
    @IBOutlet var containerV: UIView!
    var useLable = false
    var completionHandler : (Bool) ->Void = {_  in }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textV.allowsEditingTextAttributes = false
        if let left = leftBtnTitle
        {
            self.yesBtn.setTitle(left, for: .normal)
        }
        if let right = rightBtnTitle
        {
            self.noBtn.setTitle(right, for: .normal)
        }
        if message == nil {
            if let attributedStr = attributedMessage
            {
                self.messageL.attributedText = attributedStr
                self.heightC.constant = 0
            }
        }
        else{
            if useLable
            {
                if let msg = message
                {
                    self.textV.text = msg
                    textV.isSelectable = true
                    textV.isUserInteractionEnabled = true
                    textV.isScrollEnabled = true
                    textV.showsVerticalScrollIndicator = true;
                    textV.bounces = true;
                    textV.panGestureRecognizer.allowedPressTypes = [UITouchType.indirect.rawValue] as [NSNumber]
                    
                    
//                    [myParentView addGestureRecognizer:myTextView.panGestureRecognizer];
//
//                    [myParentView addGestureRecognizer:myTextView.directionalPressGestureRecognizer];
                    

                    
                    
                }
            }
            else{
                self.messageL.text = message!
                self.heightC.constant = 0
            }
        }
        
        
        self.containerV.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        self.containerV.layer.borderWidth = 1
        
        if removeBtn
        {
            self.removeOneBtn()
        }
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let nextButton = context.nextFocusedItem as? UIButton {
            nextButton.setTitleColor(UIColor.black, for: .focused)
            nextButton.setTitleColor(UIColor.white, for: .normal)

//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
//                nextButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//                nextButton.backgroundColor = UIColor.lightGray
//            })
        }
        
        if let previousButton = context.previouslyFocusedItem as? UIButton {
            previousButton.setTitleColor(UIColor.black, for: .focused)
            previousButton.setTitleColor(UIColor.white, for: .normal)

//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
//                previousButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                previousButton.backgroundColor = UIColor.clear
//            })
        }
    }

    @IBAction func yesAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        completionHandler(true)
    }
    
    @IBAction func noAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        completionHandler(false)
    }
    
    func removeOneBtn()
    {
        if let stackView = stackV
        {
            if let no = noBtn {
                stackView.removeArrangedSubview(no)
                no.removeFromSuperview()
            }
            else{
                print("not found no button")
            }
        }
        else{
            print("not found stack view")
        }
        
    }
}

