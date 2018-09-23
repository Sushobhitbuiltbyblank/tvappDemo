//
//  Client.swift
//  Award Bureau
//
//  Created by Sushobhit Jain on 01/09/18.
//  Copyright © 2018 Sushobhit Jain. All rights reserved.
//

import Foundation
typealias completionBlock = (Data?, Bool, String?,Int) -> (Void)

class HttpClient
{
    public static func getRequest(param:[String:Any],url:URL, completionBlock: @escaping completionBlock) -> Void {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    completionBlock(nil, true, error?.localizedDescription,0)
                    return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: (\(httpResponse.statusCode))")
                completionBlock(dataResponse, true, error?.localizedDescription,httpResponse.statusCode)
            }
        }
        task.resume()
    }
    
    public static func postRequest(param:[String:Any],urlRequest: URLRequest, completionBlock: @escaping completionBlock) -> Void {
        var postRequest = urlRequest
        postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        postRequest.httpBody = encode(param: param)
        postRequest.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: postRequest) { (responseData, responseUrl, error) in
            guard let dataResponse = responseData else {
                print(error?.localizedDescription ?? "Response Error")
                completionBlock(nil, true, error?.localizedDescription,0)
                return
            }
            if let httpResponse = responseUrl as? HTTPURLResponse {
                print("Status code: (\(httpResponse.statusCode))")
                completionBlock(dataResponse, true, error?.localizedDescription,httpResponse.statusCode)
            }
        }
        task.resume()
        
    }
    
    public static func encode(param:[String:Any]) ->Data
    {
        let Str = (param.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }) as Array).joined(separator: "&")
        return Str.data(using: .utf8)!
        
    }
}
