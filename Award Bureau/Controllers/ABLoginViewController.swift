//
//  ABLoginViewController.swift
//  Award Bureau
//
//  Created by PRASHANT DWIVEDI on 20/09/18.
//  Copyright © 2018 Jitesh. All rights reserved.
//

import UIKit
import TvOSTextViewer

class ABLoginViewController: UIViewController {

    @IBOutlet weak var imgView_background: UIImageView!
    @IBOutlet weak var view_main: UIView!
    @IBOutlet weak var imgView_logo: UIImageView!
    @IBOutlet weak var lbl_errorMessage: UILabel!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var lbl_terms: UILabel!
    @IBOutlet weak var btn_forgotPassword: UIButton!
    @IBOutlet weak var constraint_errorHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func action_login(_ sender: Any) {
        if validateFields() {
            
            // Login Service Call
            let emailId = tf_email.text!
            let pass = tf_password.text!
            let deviceID = (UIDevice.current.identifierForVendor?.uuidString)!
            let appVersion: String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            //            UserDefaults.standard.set("121121", forKey: UDKey.deviceId)
            UserDefaults.standard.set(emailId, forKey: UDKey.emailId)
            UserDefaults.standard.synchronize()
            let param = ["email": "\(emailId)", "password": "\(pass)", "deviceId": "\(deviceID)", "version": appVersion ?? "1"] as [String:Any]
            
            showHud("")

            ABServiceManager.login(param: param) { (isSuccess, msg) in
                DispatchQueue.main.async {
                    self.hideHUD()
                    if(isSuccess){
                        UserDefaults.standard.set(true, forKey: UDKey.isLogin)
                        UserDefaults.standard.synchronize()
                        
                        AppIntializer.moveToMainCategoryScreen()
                    }
                    self.showHideError(withMessage: msg, ErrorStatus: isSuccess)
                }
            }
        }
    }
        
    @IBAction func action_forgotPassword(_ sender: Any) {
    }
    
    //MARK:- Validate Email and Password before proceed
    func validateFields() -> Bool {
        
        var code: NSInteger = 0  //// code 0 used for success
        
        ///// Validate Email
        code = ABValidator.validateEmail(email: tf_email.text)
        
        if code != 0 {
            showHideError(withMessage: ABValidator.message(forCode: code), ErrorStatus: false)
            return false
        }
        
        ///// Validate Password
        code = ABValidator.validatePassword(tf_password.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), withMaximumCharacterLimit: 16, withMinimumCharacterLimit: 6)
        
        if code != 0 {
            showHideError(withMessage: ABValidator.message(forCode: code), ErrorStatus: false)
            return false
        }
        
        ///// Default :- Successfully validate
//        showHideError(withMessage: nil, ErrorStatus: true)
        return true
    }
    
    func showHideError(withMessage message: String?, ErrorStatus isSuccess: Bool) {
        if isSuccess == false && message != nil && message!.count > 0 {
            constraint_errorHeight.constant = 45
            lbl_errorMessage.text = message ?? ""
        } else {
            constraint_errorHeight.constant = 0
            lbl_errorMessage.text = ""
        }
    }
    
    @IBAction func termOfUseAction(_ sender: Any) {
        let param = ["topic":"legalTerms"]
        showHud("")
        ABServiceManager.legal(param: param) { (response, isSuccess, error) in
            let str = response?.description!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            DispatchQueue.main.async {
                self.hideHUD()
                
                let viewController = TvOSTextViewerViewController()
                viewController.text = str!
                viewController.textEdgeInsets = UIEdgeInsetsMake(100, 250, 100, 250)
                self.present(viewController, animated: true, completion: nil)

//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ABMessageViewController") as! ABMessageViewController
//                vc.message = str!
////                vc.useLable = true
////                vc.leftBtnTitle = "CLOSE"
////                vc.removeBtn = true
//                self.present(vc, animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func privacyAction(_ sender: Any) {
        let param = ["topic":"legalPrivacy"]
        showHud("")
        ABServiceManager.legal(param: param) { (response, isSuccess, error) in
            let str = response?.description!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            DispatchQueue.main.async {
                self.hideHUD()
                let viewController = TvOSTextViewerViewController()
                viewController.text = str!
                viewController.textEdgeInsets = UIEdgeInsetsMake(150, 250, 150, 250)
                self.present(viewController, animated: true, completion: nil)

//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ABAlertViewController") as! ABAlertViewController
//                vc.message = str!
//                vc.useLable = true
//                vc.leftBtnTitle = "CLOSE"
//                vc.removeBtn = true
//                self.present(vc, animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func videoPPAction(_ sender: Any) {
        let param = ["topic":"legalVideo"]
        showHud("")
        ABServiceManager.legal(param: param) { (response, isSuccess, error) in
            let str = response?.description!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            DispatchQueue.main.async {
                self.hideHUD()
                let viewController = TvOSTextViewerViewController()
                viewController.text = str!
                viewController.textEdgeInsets = UIEdgeInsetsMake(150, 250, 150, 250)
                self.present(viewController, animated: true, completion: nil)

//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ABAlertViewController") as! ABAlertViewController
//                vc.message = str!
//                vc.useLable = true
//                vc.leftBtnTitle = "CLOSE"
//                vc.removeBtn = true
//                self.present(vc, animated: false, completion: nil)
            }
        }
    }
    @IBAction func coppaAction(_ sender: Any) {
        let param = ["topic":"legalCoppa"]
        showHud("")
        ABServiceManager.legal(param: param) { (response, isSuccess, error) in
            let str = response?.description!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            DispatchQueue.main.async {
                self.hideHUD()
                
                let viewController = TvOSTextViewerViewController()
                viewController.text = str!
                viewController.textEdgeInsets = UIEdgeInsetsMake(150, 250, 150, 250)
                self.present(viewController, animated: true, completion: nil)

//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ABAlertViewController") as! ABAlertViewController
//                vc.message = str!
//                vc.useLable = true
//                vc.leftBtnTitle = "CLOSE"
//                vc.removeBtn = true
//                self.present(vc, animated: false, completion: nil)
            }
        }
    }
}
