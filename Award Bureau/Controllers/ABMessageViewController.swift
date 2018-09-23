//
//  ABMessageViewController.swift
//  Award Bureau
//
//  Created by PRASHANT DWIVEDI on 22/09/18.
//  Copyright © 2018 Jitesh. All rights reserved.
//

import UIKit

class ABMessageViewController: UIViewController {

    @IBOutlet weak var textview: UITextView!
    
    var message: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textview.text = message
        textview.isSelectable = true
        textview.isUserInteractionEnabled = true
        textview.isScrollEnabled = true
        textview.showsVerticalScrollIndicator = true;
        textview.bounces = true;
        textview.panGestureRecognizer.allowedPressTypes = [UITouchType.indirect.rawValue] as [NSNumber]
        view.addGestureRecognizer(textview.panGestureRecognizer)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
