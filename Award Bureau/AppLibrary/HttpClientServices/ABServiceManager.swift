//
//  ABServiceManager.swift
//  Award Bureau
//
//  Created by Sushobhit Jain on 01/09/18.
//  Copyright © 2018 Sushobhit Jain. All rights reserved.
//

import Foundation
import UIKit

class ABServiceManager {
    
    //MARK:- User Login
    public static func login(param:[String:Any], completionBlock: @escaping (Bool,String)->Void) -> Void {
        guard let url = ABURLFromParameters([:], withPathExtension: Method.login) else{return}
        let urlrequest = URLRequest(url: url)
        HttpClient.postRequest(param: param, urlRequest: urlrequest) { (response, status, error,statusCode) -> (Void) in
            if statusCode == 200 {
                if let responseData = response {
                    do {
                        let json = try JSONSerialization.jsonObject(with: response!, options: .allowFragments) as! NSDictionary
                        print(json)
                        
                    } catch let error {
                        print(error)
                    }
                    do {
                        let loginRes = try JSONDecoder().decode(loginResponse.self, from: responseData)
                        if loginRes.error != nil{
                            completionBlock(false,(loginRes.error)!)
                        }
                        else{
                            let token = loginRes.token
                            let refreshToken = loginRes.refresh_token
                            let username = "\((loginRes.first_name)!) \((loginRes.last_name)!)"
                            UserDefaults.standard.set(username, forKey: UDKey.username)
                            UserDefaults.standard.set(token, forKey: UDKey.token)
                            UserDefaults.standard.set(refreshToken, forKey: UDKey.refreshToken)
                            UserDefaults.standard.synchronize()
                            completionBlock(true,"Login SuccessFully")
                        }
                        
                    }
                    catch let parsingError {
                        print("Error", parsingError)
                    }
                }
            }
            if statusCode == 403{
                delegation(param: [:], completionBlock: { (isSuccess, error) in
                    if isSuccess {
                        entitlements(param: [:], completionBlock: { (categories,isSuccess, error) in
                            completionBlock(isSuccess,error)
                        })
                    }
                    else {
                        completionBlock(false,error)
                    }
                })
            }
        }
    }
    
    // MARK:- Entitlement
    public static func entitlements(param:[String:Any], completionBlock: @escaping ([CategoryModel],Bool,String)->Void) -> Void {
        guard let url = ABURLFromParameters([:], withPathExtension: Method.entitlements) else{return}
        var urlrequest = URLRequest(url: url)
        let token = UserDefaults.standard.value(forKey: UDKey.token) as! String
        urlrequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        HttpClient.postRequest(param: param, urlRequest: urlrequest) { (response, status, error,statusCode) -> (Void) in
            if statusCode == 200 {
                if let responseData = response {
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! NSArray
                        print(json)
                        
                    } catch let error {
                        print(error)
                    }
                    do{
                        let categories = try JSONDecoder().decode([CategoryModel].self, from: responseData)
                        completionBlock(categories,true,"")
                    }
                    catch let error {
                        print(error)
                    }
                }
            }
            if statusCode == 403{
                delegation(param: [:], completionBlock: { (isSuccess, error) in
                    if isSuccess {
                        entitlements(param: [:], completionBlock: { (categories,isSuccess, error) in
                            completionBlock(categories,isSuccess,error)
                        })
                    }
                    else {
                        completionBlock([],false,error)
                    }
                })
            }
        }
    }
    
    // MARK:- Title
    public static func title(param:[String:Any], completionBlock: @escaping (TitleResponse?,Bool,String)->Void) -> Void {
        let titleId = param["titleId"] as! String
        guard let url = ABURLFromParameters([:], withPathExtension: "\(Method.title)/\(titleId)") else{return}
        var urlrequest = URLRequest(url: url)
        let token = UserDefaults.standard.value(forKey: UDKey.token) as! String
        urlrequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        HttpClient.postRequest(param: param, urlRequest: urlrequest) { (response, status, error,statusCode) -> (Void) in
            if statusCode == 200 {
                if let responseData = response {
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                        print(json)
                        
                    } catch let error {
                        print(error)
                    }
                    do{
                        let categories = try JSONDecoder().decode(TitleResponse.self, from: responseData)
                        completionBlock(categories,true,"")
                    }
                    catch let error {
                        print(error)
                    }
                }
            }
            if statusCode == 403{
                delegation(param: [:], completionBlock: { (isSuccess, error) in
                    if isSuccess {
                        title(param: [:], completionBlock: { (title,isSuccess, error) in
                            completionBlock(title,isSuccess,error)
                        })
                    }
                    else {
                        completionBlock(nil,false,error)
                    }
                })
            }
        }
    }
    
    // MARK:- Legal
    public static func legal(param:[String:Any], completionBlock: @escaping (LegalModel?,Bool,String)->Void) -> Void {
        let titleId = param["topic"] as! String
        guard let url = ABURLFromParameters([:], withPathExtension: "\(Method.legal)/\(titleId)") else{return}
        HttpClient.getRequest(param: param, url: url) { (response, status, error,statusCode) -> (Void) in
            if statusCode == 200 {
                if let responseData = response {
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                        print(json)
                        
                    } catch let error {
                        print(error)
                    }
                    do{
                        let legal = try JSONDecoder().decode(LegalModel.self, from: responseData)
                        completionBlock(legal,true,"")
                    }
                    catch let error {
                        print(error)
                    }
                }
            }
            if statusCode == 403{
                delegation(param: [:], completionBlock: { (isSuccess, error) in
                    if isSuccess {
                        legal(param: [:], completionBlock: { (legal,isSuccess, error) in
                            completionBlock(legal,isSuccess,error)
                        })
                    }
                    else {
                        completionBlock(nil,false,error)
                    }
                })
            }
        }
    }
    
    // MARK:- Assets
    public static func assets(param:[String:Any], completionBlock: @escaping (AssetsResponse?,Bool,String)->Void) -> Void {
        let titleId = param["title"] as! String
        let url = URL(string: "\(Method.assets)\(titleId).json")!
        HttpClient.getRequest(param: param, url: url) { (response, status, error,statusCode) -> (Void) in
            if statusCode == 200 {
                if let responseData = response {
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! NSDictionary
                        print(json)
                        guard let duration = json["duration"] as? Double else{ return }
                        guard let poster = json["poster_url"] as? String else { return }
                        let asset = AssetsResponse(duration: duration, poster_url: poster, msg: nil, error: nil)
                        completionBlock(asset,true,"")
                    } catch let error {
                        print(error)
                        completionBlock(nil,true,error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // MARK:- Play
    public static func play(param:[String:Any], completionBlock: @escaping (PlayResponse?,Bool,String)->Void) -> Void {
        let screenId = param["screen_id"] as! String
        guard let url = ABURLFromParameters([:], withPathExtension: "\(Method.play)/\(screenId)") else{return}
        var urlrequest = URLRequest(url: url)
        let token = UserDefaults.standard.value(forKey: UDKey.token) as! String
        urlrequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        HttpClient.postRequest(param: param, urlRequest: urlrequest) { (response, status, error,statusCode) -> (Void) in
            if statusCode == 200 {
                if let responseData = response {
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! NSDictionary
                        print(json)
                        
                    } catch let error {
                        print(error)
                    }
                    do{
                        let playRes = try JSONDecoder().decode(PlayResponse.self, from: responseData)
                        completionBlock(playRes,true,"")
                    }
                    catch let error {
                        print(error)
                    }
                }
            }
            if statusCode == 403{
                delegation(param: [:], completionBlock: { (isSuccess, error) in
                    if isSuccess {
                        play(param: [:], completionBlock: { (playRes,isSuccess, error) in
                            completionBlock(playRes,isSuccess,error)
                        })
                    }
                    else {
                        completionBlock(nil,false,error)
                    }
                })
            }
        }
    }
    
    // MARK:- Beacon
    public static func beacon(param:[String:Any], completionBlock: @escaping (Response?,Bool,String)->Void) -> Void {
        let playLocationID = param["playLocationID"] as! String
        guard let url = ABURLFromParameters([:], withPathExtension: "\(Method.beacon)/\(playLocationID)") else{ return }
        var urlrequest = URLRequest(url: url)
        let token = UserDefaults.standard.value(forKey: UDKey.token) as! String
        urlrequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        HttpClient.postRequest(param: param, urlRequest: urlrequest) { (response, status, error,statusCode) -> (Void) in
            if statusCode == 200 {
                if let responseData = response {
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! NSDictionary
                        print(json)
                        
                    } catch let error {
                        print(error)
                    }
                    do{
                        let response = try JSONDecoder().decode(Response.self, from: responseData)
                        completionBlock(response,true,"")
                    }
                    catch let error {
                        print(error)
                    }
                }
            }
            if statusCode == 403{
                delegation(param: [:], completionBlock: { (isSuccess, error) in
                    if isSuccess {
                        beacon(param: [:], completionBlock: { (response,isSuccess, error) in
                            completionBlock(response,isSuccess,error)
                        })
                    }
                    else {
                        completionBlock(nil,false,error)
                    }
                })
            }
        }
    }
    
    
    // MARK:- Preplay
    public static func prePlay(param:[String:Any], completionBlock: @escaping (preplayResponse?,Bool,String)->Void) -> Void {
        let vendorId = param["vendor_id"] as! String
        guard let url = URL(string: "\(Method.prePlay)"+"\(vendorId)"+"\(Method.prePlayLast)") else {
            return
        }
        HttpClient.getRequest(param: param, url: url) { (response, status, error,statusCode) -> (Void) in
            if statusCode == 200 {
                if let responseData = response {
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! NSDictionary
                        print(json)
                        
                    } catch let error {
                        print(error)
                    }
                    do{
                        let response = try JSONDecoder().decode(preplayResponse.self, from: responseData)
                        completionBlock(response,true,"")
                    }
                    catch let error {
                        print(error)
                    }
                }
            }
        }
    }
    
    // MARK:- Delegation
    public static func delegation(param:[String:Any], completionBlock: @escaping (Bool,String)->Void) -> Void {
        let deviceId = (UIDevice.current.identifierForVendor?.uuidString)!
        guard let url = ABURLFromParameters([:], withPathExtension: "\(Method.delegation)/\(deviceId)") else{return}
        var urlrequest = URLRequest(url: url)
        guard let token = UserDefaults.standard.value(forKey: UDKey.refreshToken) as? String
            else {
                return
        }
        urlrequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        HttpClient.postRequest(param: param, urlRequest: urlrequest) { (response, status, error,statusCode) -> (Void) in
            if statusCode == 200 {
                if let responseData = response {
                    do {
                        let json = try JSONSerialization.jsonObject(with: response!, options: .allowFragments) as! NSDictionary
                        print(json)
                        
                    } catch let error {
                        print(error)
                    }
                    do {
                        let loginRes = try JSONDecoder().decode(loginResponse.self, from: responseData)
                        if loginRes.error != nil{
                            completionBlock(false,(loginRes.error)!)
                        }
                        else{
                            let token = loginRes.token
                            let refreshToken = loginRes.refresh_token
                            UserDefaults.standard.set(token, forKey: UDKey.token)
                            UserDefaults.standard.set(refreshToken, forKey: UDKey.refreshToken)
                            UserDefaults.standard.synchronize()
                            completionBlock(true,"Token Updated")
                        }
                        
                    }
                    catch let parsingError {
                        print("Error", parsingError)
                    }
                }
            }
            if statusCode == 403{
                UserDefaults.standard.set(false, forKey: UDKey.isLogin)
                UserDefaults.standard.removeObject(forKey: UDKey.refreshToken)
                UserDefaults.standard.removeObject(forKey: UDKey.token)
                UserDefaults.standard.removeObject(forKey: UDKey.username)
                UserDefaults.standard.removeObject(forKey: UDKey.emailId)
                UserDefaults.standard.synchronize()
                completionBlock(false,"Logout")
            }
        }
    }
    
    // MARK:- Logout
    public static func logout(param:[String:Any], completionBlock: @escaping (Bool,String)->Void) -> Void {
        guard let url = ABURLFromParameters([:], withPathExtension: Method.logout) else{return}
        var urlrequest = URLRequest(url: url)
        let token = UserDefaults.standard.value(forKey: UDKey.token) as! String
        urlrequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        HttpClient.postRequest(param: param, urlRequest: urlrequest) { (response, status, error,statusCode) -> (Void) in
            if statusCode == 200 {
                if let responseData = response {
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                        print(json)
                        
                    } catch let error {
                        print(error)
                    }
                    do {
                        let logoutRes = try JSONDecoder().decode(LogoutResponse.self, from: responseData)
                        if logoutRes.error != nil{
                            completionBlock(false,(logoutRes.error)!)
                        }
                        else{
                            let message = logoutRes.message
                            completionBlock(true,message!)
                        }
                        
                    }
                    catch let parsingError {
                        print("Error", parsingError)
                    }
                }
            }
            if statusCode == 403{
                delegation(param: [:], completionBlock: { (isSuccess, error) in
                    if isSuccess {
                        entitlements(param: [:], completionBlock: { (categories,isSuccess, error) in
                            completionBlock(isSuccess,error)
                        })
                    }
                    else {
                        completionBlock(false,error)
                    }
                })
            }
        }
    }
    
    
    // create a URL from parameters
    public static func ABURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = AwardBureau.ApiScheme
        components.host = AwardBureau.ApiHost
        components.path = AwardBureau.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url
    }
}
