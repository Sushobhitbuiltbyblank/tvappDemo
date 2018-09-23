//
//  AppIntializer.swift
//  Award Bureau
//
//  Created by PRASHANT DWIVEDI on 20/09/18.
//  Copyright © 2018 Jitesh. All rights reserved.
//

import UIKit

class AppIntializer: NSObject {
    
    @objc static let shared = AppIntializer()
    
    func setup(_ application: UIApplication, withLaunchOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
//        ///// Check User is login or not
        if UserDefaults.standard.bool(forKey: UDKey.isLogin) {
            AppIntializer.moveToMainCategoryScreen()
        }
        else {
            AppIntializer.moveToLoginScreen()
        }
    }
    
    //MARK:- Navigate To Home Screen
    static func moveToMainCategoryScreen() {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let mainCategoryVC = storyboard.instantiateViewController(withIdentifier: "ABMainCollectionViewController") as? ABMainCollectionViewController
        
        let navigationController = UINavigationController.init(rootViewController: mainCategoryVC!)
        navigationController.setNavigationBarHidden(false, animated: true)
        
        APP.APP_DELEGATE.window?.rootViewController = navigationController
        APP.APP_DELEGATE.window?.makeKeyAndVisible()
    }
    
    //MARK:- Navigate To Login Screen
    static func moveToLoginScreen() {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let loginVC = storyboard.instantiateViewController(withIdentifier: "ABLoginViewController") as? ABLoginViewController
        
        APP.APP_DELEGATE.window?.rootViewController = loginVC
        APP.APP_DELEGATE.window?.makeKeyAndVisible()
    }
}
