//
//  ABMainCollectionViewController.swift
//  Award Bureau
//
//  Created by PRASHANT DWIVEDI on 20/09/18.
//  Copyright © 2018 Jitesh. All rights reserved.
//

import UIKit

class ABMainCollectionViewController: UIViewController {
    
    @IBOutlet weak var cv_category: UICollectionView!
    @IBOutlet weak var tv_category: UITableView!
    
    var categoryTitles: [TitleModel]?
    var catergories: [CategoryModel]?
    
    var noNeedToRefreshView: Bool = false
    
    
    var currentFocusedCollectionIndex: NSInteger? = nil
    var currentFocusedTableIndex: NSInteger = 0
    var currentSelectedIndex: NSInteger = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableAndCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !noNeedToRefreshView {
            getCategoriesInformation()
        }
        noNeedToRefreshView = false
    }
    
    func setupTableAndCollectionView() {
        tv_category.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tv_category.frame.width, height: 50))
        tv_category.tableFooterView = UIView()
        
        ///// set right navigation Button
        setBarButtonItem(withButtonImage: "logout", withPosition: BarButtonPosition.BarButtonPositionRight, needAdjustMent: false)
        setBarButtonItem(withImage: "logo", withPosition: BarButtonPosition.BarButtonPositionLeft)
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        print("focused")
        if let rightNavButton = context.nextFocusedItem as? UIButton, rightNavButton.currentImage == UIImage.init(named: "logout") {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
                rightNavButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            })
        } else if let rightNavButton = context.previouslyFocusedItem as? UIButton, rightNavButton.currentImage == UIImage.init(named: "logout") {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
                rightNavButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
        
        if let leftNavButton = context.nextFocusedItem as? UIButton, leftNavButton.currentImage == UIImage.init(named: "logo") {
            print("left foccued")
        }
    }
//    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
//        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)
//
//        if context.nextFocusedView == self {
//            // This is when the button will be focused
//            // You can change the backgroundColor and textColor here
//        } else {
//            // This is when the focus has left and goes back to default
//            // Don't forget to reset the values
//        }
//    }
    
    override func rightNavigationButton() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ABAlertViewController") as! ABAlertViewController
        
        vc.message = "Do you really want to logout?"
        vc.completionHandler = { yes in
            if yes {
                ABServiceManager.logout(param: [:]) { ( isSuccess, error) in
                    UserDefaults.standard.set(false, forKey: UDKey.isLogin)
                    UserDefaults.standard.removeObject(forKey: UDKey.refreshToken)
                    UserDefaults.standard.removeObject(forKey: UDKey.token)
                    UserDefaults.standard.removeObject(forKey: UDKey.username)
                    UserDefaults.standard.removeObject(forKey: UDKey.emailId)
                    UserDefaults.standard.synchronize()
                }
                AppIntializer.moveToLoginScreen()
            } else {
                self.noNeedToRefreshView = true
            }
        }
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    
    //MARK:- API Call for getting categories DATA
    func getCategoriesInformation() {
        showHud("")
        if let isLogin = UserDefaults.standard.value(forKey: UDKey.isLogin) as? Bool {
            if isLogin {
                ABServiceManager.entitlements(param: [:]) { (categories,isSuccess, error) in
                    if isSuccess {
                        
                        DispatchQueue.main.async {
                            self.hideHUD()
                            self.catergories = categories
                            
                            if self.catergories != nil && self.catergories!.count > 0 {
                                self.currentFocusedTableIndex = 0
                                self.tv_category.reloadData()
                                
                                let category: CategoryModel? = self.catergories![0]
                                
                                if category != nil && category?.titles != nil {
                                    self.categoryTitles = category?.titles
                                    self.cv_category.reloadData()
                                }
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            AppIntializer.moveToLoginScreen()
                        }
                    }
                }
            }
        }
    }
}

// MARK:- UICollectionViewDataSource / UICollectionViewDelegate protocol
extension ABMainCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categoryTitles != nil {
            return (categoryTitles?.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv_category.dequeueReusableCell(withReuseIdentifier: "ABMainCategoryContentCollectionViewCell", for: indexPath) as! ABMainCategoryContentCollectionViewCell
        
        let titles: TitleModel = categoryTitles![indexPath.row]
        
        cell.imgView_category.set_sdWebImage(With: titles.rep_image ?? "", placeHolderImage: "placeholder", completionBlock: { (finished) -> (Void) in
            //After completion
        })

        cell.lbl_categoryName.text = titles.name ?? ""
        cell.lbl_categoryName.textColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let currentSelectedCategory: CategoryModel? = self.catergories![currentSelectedIndex]
        let title: TitleModel = categoryTitles![indexPath.row]
        
        let detailVC = storyboard!.instantiateViewController(withIdentifier: "ABDetailViewController") as! ABDetailViewController

        detailVC.allTitleObjectsArray = categoryTitles
        detailVC.categoryName = currentSelectedCategory?.category
        detailVC.titleObject = title
        
//        next.completionHandler = {_ in
//            ABServiceManager.entitlements(param: [:]) { (categories,isSuccess, error) in
//                if isSuccess {
//                    DispatchQueue.main.async {
//                        let tag = self.selectedBtn?.tag
//                        self.catergories = categories
//                        self.titles = self.catergories![tag! - 121].titles!
//                        self.titleCollectionVIew .reloadData()
//                    }
//                }
//            }
//        }
        Push(controller: detailVC)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if let previousFocusedIndexPath = context.previouslyFocusedIndexPath, let previousCell = cv_category.cellForItem(at: previousFocusedIndexPath) {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
                previousCell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
            previousCell.layer.borderColor = UIColor.clear.cgColor
            previousCell.layer.borderWidth = 0
        }
        
        if let nextFocusedIndexPath = context.nextFocusedIndexPath, let nextCell = cv_category.cellForItem(at: nextFocusedIndexPath) {
            currentFocusedCollectionIndex = nextFocusedIndexPath.row
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
                nextCell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            })
            nextCell.layer.borderColor = UIColor.white.cgColor
            nextCell.layer.borderWidth = 4
        } else {
            currentFocusedCollectionIndex = nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        return true
    }
}

//MARK:- TableView Delegates/ datasource
extension ABMainCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if catergories != nil {
            return (catergories?.count)!
        }
        return 0
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tv_category.dequeueReusableCell(withIdentifier: "ABCollectionCategoryTableViewCell", for: indexPath) as! ABCollectionCategoryTableViewCell
        
        let category: CategoryModel = catergories![indexPath.row]
        
        cell.lbl_categoryName.text = String(format: "%@ (%d)", category.category ?? "", category.titles?.count ?? 0)
        
        if currentFocusedTableIndex == indexPath.row {
            cell.lbl_categoryName.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
            cell.lbl_categoryName.textColor = .white

        } else {
            cell.lbl_categoryName.font = UIFont.systemFont(ofSize: 25, weight: .regular)
            cell.lbl_categoryName.textColor = .darkGray

        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (catergories?.count)! > indexPath.row {
            currentSelectedIndex = indexPath.row
            let category: CategoryModel? = self.catergories![indexPath.row]
            
            if category != nil && category?.titles != nil {
                self.categoryTitles = category?.titles
                self.cv_category.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let previousFocusedIndexPath = context.previouslyFocusedIndexPath, let previousCell: ABCollectionCategoryTableViewCell = tv_category.cellForRow(at: previousFocusedIndexPath) as? ABCollectionCategoryTableViewCell {
            
            previousCell.lbl_categoryName.font = UIFont.systemFont(ofSize: 25, weight: .regular)
            previousCell.lbl_categoryName.textColor = .darkGray
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
//                previousCell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//            })
        }
        
        if let nextFocusedIndexPath = context.nextFocusedIndexPath, let nextCell: ABCollectionCategoryTableViewCell = tv_category.cellForRow(at: nextFocusedIndexPath) as? ABCollectionCategoryTableViewCell {
            currentFocusedTableIndex = nextFocusedIndexPath.row
            
            nextCell.lbl_categoryName.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
            nextCell.lbl_categoryName.textColor = .white

//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
//                nextCell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//            })
        }
    }
}
