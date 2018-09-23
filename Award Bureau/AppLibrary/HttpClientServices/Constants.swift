//
//  Constants.swift
//  Award Bureau
//
//  Created by Sushobhit Jain on 01/09/18.
//  Copyright © 2018 Sushobhit Jain. All rights reserved.
//

import Foundation
import UIKit
// MARK:-  API Key
struct AwardBureau{
    static let ApiScheme = "https"
    static let ApiHost = "cornusdistribution.com"
    static let ApiPath = "/api"
}

struct Method {
    static let login = "/token"
    static let entitlements = "/entitlements"
    static let delegation = "/delegation"
    static let logout = "/logout"
    static let title = "/title"
    static let assets = "https://content.uplynk.com/player/assetinfo/"
    static let play = "/play"
    static let beacon = "/beacon"
    static let prePlay = "https://content.uplynk.com/api/v3/preplay/"
    static let prePlayLast = ".json?rmt=fps"
    static let legal = "/legal"
}

struct WebServicekey {
    static let call_for = "call_for"
    static let auth_key = "auth_key"
    static let auth_value = "ea7979f36244af2fc3a99f2abe9b5d59"
    static let access_token = "access_token"
}

// MARK:-  Request Keys

struct LoginKeyRequest {
    static let user_name = "user_name"
    static let password = "password"
}

struct RegisterKeyRequest {
    static let first_name = "first_name"
    static let last_name = "last_name"
    static let email = "email"
    static let user_name = "user_name"
    static let birth_year = "birth_year"
    static let zip_code = "zip_code"
    static let password = "password"
}

struct ChanegPassRequest {
    static let old_password = "old_password"
    static let password = "password"
}

struct ForgetPassRequest {
    static let email = "email"
}
// MARK:- Font
struct FontName {
    static let montserrat_extraLight = "Montserrat-ExtraLight"
    static let montserrat_regular = "Montserrat-Regular"
    static let Montserrat_Medium = "Montserrat-Medium"
    static let montserrat_SemiBold = "Montserrat-SemiBold"
    static let montserrat_Bold = "Montserrat-Bold"
    static let Didot_Italic = "Didot-Italic"
    static let cardo = "Cardo-Italic"
    static let gothamBook = "GothamBook"
    static let gothamBold = "gothamBold"
}

struct FontSize {
    static let medium:CGFloat = 13
    static let tfMedium:CGFloat = 25
    static let navTitle:CGFloat = 20
    static let textField:CGFloat = 18
}

struct ABColor {
    static let highLight = UIColor(named: "yellowColor") //UIColor(red: 242/255, green: 187/255, blue: 111/255, alpha: 1)
    static let textGray = UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1)
    static let textField = UIColor(named: "textGrayColor") //UIColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1)
    static let textLine = UIColor(named: "lineColor") //UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1)
    static let grayColor = UIColor(named:"grayColor")
    static let smallTextColor = UIColor(named:"smallTextColor")
    static let highLightColor = UIColor(red: 40/255, green: 152/255, blue: 211/255, alpha: 1)
}

// MARK:- UserDefault Keys
struct UDKey {
    static let isLogin = "isLogin"
    static let token = "token"
    static let refreshToken = "refreshToken"
    static let deviceId = "deviceId"
    static let username = "username"
    static let emailId = "emailId"
}

// MARK:- Core data Key
struct DBEntity {
    static let User = "User"
}

//MARK - App Name
struct APP {
    static let name = "Award Bureau"
    
    static let APP_DELEGATE : AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    static let APP_WINDOW : UIWindow? = {
        return APP.APP_DELEGATE.window
    }()
}


