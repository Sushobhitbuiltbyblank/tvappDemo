//
//  ABDetailViewController.swift
//  Award Bureau
//
//  Created by PRASHANT DWIVEDI on 21/09/18.
//  Copyright © 2018 Jitesh. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import TvOSTextViewer

class ABDetailViewController: UIViewController {
    
    @IBOutlet weak var imgView_mainVideo: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var sv_genres: UIStackView!
    @IBOutlet weak var lbl_genres: UILabel!
    @IBOutlet weak var lbl_categoryName: UILabel!
    @IBOutlet weak var lbl_rating: UILabel!
    @IBOutlet weak var lbl_videoDuration: UILabel!
    @IBOutlet weak var lbl_releaseDate: UILabel!
    @IBOutlet weak var lbl_directorName: UILabel!
    @IBOutlet weak var lbl_producerName: UILabel!
    @IBOutlet weak var lbl_writterName: UILabel!
    @IBOutlet weak var lbl_musicianName: UILabel!
    @IBOutlet weak var btn_watchNow: UIButton!
    @IBOutlet weak var lbl_summary: UILabel!
    @IBOutlet weak var btn_readMore: UIButton!
    @IBOutlet weak var lbl_relatedMovies: UILabel!
    @IBOutlet weak var cv_relatedMovies: UICollectionView!
    @IBOutlet weak var constraint_genresViewHeight: NSLayoutConstraint!
    
    var titleObject: TitleModel?
    var categoryName: String?
    var allTitleObjectsArray: [TitleModel]?
    var otherTitleObjectsArray: [TitleModel]?
    var currentFocusedCollectionIndex: NSInteger? = nil
    var duration: Double?
    var playResponse: PlayResponse? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        btn_readMore.layer.borderWidth = 2
        btn_readMore.layer.borderColor = UIColor.white.cgColor
        btn_watchNow.layer.borderWidth = 2
        btn_watchNow.layer.borderColor = UIColor.white.cgColor
        
        ///// set right navigation Button
        setBarButtonItem(withButtonImage: "back", withPosition: BarButtonPosition.BarButtonPositionLeft, needAdjustMent: false)
        
        imgView_mainVideo.set_sdWebImage(With: titleObject?.rep_image ?? "", placeHolderImage: "placeholder", completionBlock: { (finished) -> (Void) in
            //After completion
        })
        
        lbl_categoryName.text = categoryName ?? ""
        lbl_title.text = titleObject?.name ?? ""
        
        ///// remove current titleObject from allTitleObject
        otherTitleObjectsArray = allTitleObjectsArray?.filter( { (titleModel: TitleModel) -> Bool in
            return titleObject?.id != titleModel.id
        })

        cv_relatedMovies.reloadData()
        
        serviceCallForDetailInfo()
    }
    
    override func leftNavigationButton() {
        PopBack()
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        print("focused")
        if let nextButton = context.nextFocusedItem as? UIButton {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
                nextButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                nextButton.backgroundColor = UIColor.lightGray
            })
            nextButton.setTitleColor(UIColor.black, for: .focused)
            nextButton.setTitleColor(UIColor.white, for: .normal)
        }
        
         if let previousButton = context.previouslyFocusedItem as? UIButton {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
                previousButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                previousButton.backgroundColor = UIColor.clear
            })
            previousButton.setTitleColor(UIColor.black, for: .focused)
            previousButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    func serviceCallForDetailInfo() {
        showHud("")
        let param = ["title": titleObject?.vendor_id ?? ""]

        ABServiceManager.assets(param: param, completionBlock: { (asset, isSuccess, error) in
            if let duration = asset?.duration {
                self.duration = duration
                let min = Int(duration / 60.0)
                DispatchQueue.main.async {
                    self.lbl_videoDuration.text = "\(min) min"
                }
            }

            
            ABServiceManager.title(param: ["titleId": self.titleObject?.id ?? ""]) { (titleModel, isSucess, error) in
                DispatchQueue.main.async {
                    let str = (titleModel?.synopsis ?? "").replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    self.lbl_summary.text = str
                    self.lbl_directorName.text = titleModel?.director ?? ""
                    self.lbl_writterName.text = titleModel?.writer ?? ""
                    self.lbl_rating.text = titleModel?.rating ?? ""
                    self.lbl_producerName.text = ""
                    self.lbl_musicianName.text = ""
                    
                    if titleModel?.genres != nil && (titleModel?.genres?.count)! > 0 {
                        self.sv_genres.isHidden = false
                        self.constraint_genresViewHeight.constant = 45
                        let genres = titleModel?.genres?.joined(separator:"  .  ")
                        self.lbl_genres.text = genres
                    } else {
                        self.sv_genres.isHidden = true
                        self.constraint_genresViewHeight.constant = 0
                    }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let date = dateFormatter.date(from: titleModel?.release_date ?? "")
                    dateFormatter.dateFormat = "MMM d, yyyy"
                    
                    if date != nil {
                        let dateString = dateFormatter.string(from: date!)
                        self.lbl_releaseDate.text = dateString
                    }
                }
                
                
                let deviceId = (UIDevice.current.identifierForVendor?.uuidString)!
                let screenId = self.titleObject?.screener_id ?? ""
                let param = ["deviceId": deviceId, "screen_id": screenId] as [String : Any]
                
                
                ABServiceManager.play(param: param) { (playResponse, isSucess, error) in
                    if(isSucess) {
                        
                        self.playResponse = playResponse
//                        self.vendorId = (playResponse?.vendor_id)!
//                        self.anti_piracy = (playResponse?.anti_piracy)
//                        self.time = playResponse?.play_location!
//                        self.isWaterMark = playResponse?.watermark
//                        let persentage = (Double(self.time!)/self.duration!)
//                        DispatchQueue.main.async {
//                            self.progressBar.setProgress(Float(persentage), animated: true)
//                        }
                        
//                        self.playLocationID = playResponse?.play_location_id
                    }
                    DispatchQueue.main.async {
                        self.hideHUD()
                    }
                }
            }
        })
    }

    @IBAction func action_watchNow(_ sender: Any) {
        if let anti_piracy = playResponse?.anti_piracy {
            let str = anti_piracy.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ABAlertViewController") as! ABAlertViewController
            vc.message = str
            vc.leftBtnTitle = "ACCEPT"
            vc.rightBtnTitle = "REJECT"
            vc.completionHandler = { isYes in
                if isYes
                {
                    if (self.playResponse?.play_location)! > 0 {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ABAlertViewController") as! ABAlertViewController
                        vc.leftBtnTitle = "RESUME"
                        vc.rightBtnTitle = "START OVER"
                        vc.message = "Do you want to"
                        vc.completionHandler = { isYes in
                            if isYes {
                                self.playVideo(isResume: true)
                            } else {
                                self.playVideo(isResume: false)
                            }
                        }
                        self.navigationController?.present(vc, animated: false, completion: nil)
                    } else {
                        self.playVideo(isResume: false)
                    }
                }
            }
            self.navigationController?.present(vc, animated: false, completion: nil)
        }
        else {
            if (self.playResponse?.play_location)! > 0 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ABAlertViewController") as! ABAlertViewController
                vc.leftBtnTitle = "RESUME"
                vc.rightBtnTitle = "START OVER"
                vc.message = "Do you want to"
                vc.completionHandler = { isYes in
                    if isYes {
                        self.playVideo(isResume: true)
                    } else {
                        self.playVideo(isResume: false)
                    }
                }
                self.navigationController?.present(vc, animated: false, completion: nil)
            } else {
                self.playVideo(isResume: false)
            }
            
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?)
    {
        print("something new happens")
        
        if let PlayerVC = object as? NewMoviePlayerViewController {
            if PlayerVC.player != nil {
                if (PlayerVC.player?.isPlaying)! {
                    PlayerVC.player?.pause()
                } else {
                    PlayerVC.player?.play()
                }
            }
        }
    }
    
    
    
    func playVideo(isResume:Bool)
    {
        let currentTime = Int(Date().timeIntervalSince1970)+600
        let str = "tc=1&exp="+"\(currentTime)"+"&rn="+"\(arc4random_uniform(9999))"+"&ct=a&cid="+"\(playResponse?.vendor_id ?? "")"
        print(str)
        let apiKey = "IHftBsQLX63linXUX6fsTh5Dlw3E033tkBKcdUrV"
        let hmac_md5 = str.hmac(algorithm: .SHA256, key: apiKey)
        print(hmac_md5)
        let urlStr = "https://content.uplynk.com/"+"\(playResponse?.vendor_id ?? "")"+".m3u8?"+str+"&sig="+"\(hmac_md5)"
        print(urlStr)
        let videoUrl = URL(string: urlStr)
        
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: videoUrl!)
        
        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = NewMoviePlayerViewController()
        controller.player = player
        
        
        controller.addObserver(self, forKeyPath:#keyPath(UIViewController.presentationController), options: [.old, .new], context: nil)
        
        
        if let _ = playResponse?.watermark {
//            let textHeight = self.view.frame.width*0.07
//            var height = self.view.frame.width*(2/3)
//            if UIApplication.shared.statusBarOrientation != .portrait
//            {
//                height = self.view.frame.height * (2/3)
//            }
            
//            if let username = UserDefaults.standard.string(forKey: UDKey.username) {
//                let lblNew = UILabel()
//                lblNew.text = username
//                lblNew.textColor = UIColor.white.withAlphaComponent(0.3)
//                lblNew.font = UIFont(name: FontName.gothamBold, size:textHeight)
//                lblNew.translatesAutoresizingMaskIntoConstraints = false
//                
//                let topConstraint = NSLayoutConstraint(item: lblNew, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: controller.contentOverlayView!, attribute: NSLayoutAttribute.top, multiplier: 1, constant:height)
//                
//                let constraints = NSLayoutConstraint.constraints(
//                    withVisualFormat: "V:[superview]-(<=1)-[label]",
//                    options: NSLayoutFormatOptions.alignAllCenterX,
//                    metrics: nil,
//                    views: ["superview":controller.contentOverlayView!, "label":lblNew])
//                
//                controller.contentOverlayView?.addConstraints(constraints)
//                controller.contentOverlayView?.addConstraints([ topConstraint])
//                controller.contentOverlayView?.addSubview(lblNew)
//            }
        }
//        let currentScreenMode = UIApplication.shared.statusBarOrientation.rawValue
//        controller.completionHandler = {_ in
//            self.setupView()
//            let orientation = currentScreenMode
//            UIDevice.current.setValue(orientation, forKey: "orientation")
//        }
        player.allowsExternalPlayback = true
        player.usesExternalPlaybackWhileExternalScreenIsActive = true
        
        // Modally present the player and call the player's play() method when complete.
        controller.setBackBarButton(With: BackButtonType.white)
        self.present(controller, animated: true) {
            if isResume
            {
                let cmtime:CMTime = CMTime(seconds: Double(self.playResponse?.play_location ?? 0), preferredTimescale: 1000)
                player.seek(to: cmtime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero, completionHandler: { (isSuccess) in
                })
            }
            player.play()
        }
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if player.currentItem?.status == .readyToPlay {
                let time : Int = Int(CMTimeGetSeconds(player.currentTime()))
                let deviceId = (UIDevice.current.identifierForVendor?.uuidString)!
                let param = ["playLocationID": self.playResponse?.play_location_id ?? "", "location" : time, "deviceId": deviceId] as [String:Any]
                
                ABServiceManager.beacon(param: param, completionBlock: { (response, isSucess, error) in
                    if isSucess {
                        
                    }
                })
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            player.seek(to: kCMTimeZero)
            let time : Int = Int(CMTimeGetSeconds(player.currentTime()))
            let deviceId = (UIDevice.current.identifierForVendor?.uuidString)!
            let param = ["playLocationID": self.playResponse?.play_location_id ?? "", "location" : time, "deviceId": deviceId] as [String:Any]
            
            ABServiceManager.beacon(param: param, completionBlock: { (response, isSucess, error) in
                if isSucess {
                    
                }
            })
        }

    }
    
    @IBAction func action_readMore(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ABAlertViewController") as! ABAlertViewController
//        vc.message = lbl_summary.text
//        vc.useLable = true
//        vc.leftBtnTitle = "BACK"
//        vc.removeBtn = true
//        self.present(vc, animated: false, completion: nil)
        
        let viewController = TvOSTextViewerViewController()
        viewController.text = lbl_summary.text ?? ""
        viewController.textEdgeInsets = UIEdgeInsetsMake(100, 250, 100, 250)
        self.present(viewController, animated: true, completion: nil)
    }
}

// MARK:- UICollectionViewDataSource / UICollectionViewDelegate protocol
extension ABDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if otherTitleObjectsArray != nil {
            return (otherTitleObjectsArray?.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv_relatedMovies.dequeueReusableCell(withReuseIdentifier: "ABDetailCollectionViewCell", for: indexPath) as! ABDetailCollectionViewCell
        
        let title: TitleModel = otherTitleObjectsArray![indexPath.row]
        
        cell.imgView_category.set_sdWebImage(With: title.rep_image ?? "", placeHolderImage: "placeholder", completionBlock: { (finished) -> (Void) in
            //After completion
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        titleObject = otherTitleObjectsArray![indexPath.row]

        setupView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if let previousFocusedIndexPath = context.previouslyFocusedIndexPath, let previousCell = cv_relatedMovies.cellForItem(at: previousFocusedIndexPath) {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
                previousCell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
            previousCell.layer.borderColor = UIColor.clear.cgColor
            previousCell.layer.borderWidth = 0
        }
        
        if let nextFocusedIndexPath = context.nextFocusedIndexPath, let nextCell = cv_relatedMovies.cellForItem(at: nextFocusedIndexPath) {
            currentFocusedCollectionIndex = nextFocusedIndexPath.row
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
                nextCell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
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

final class NewMoviePlayerViewController: AVPlayerViewController {
    var completionHandler : (Bool) ->Void = {_  in }
    var showLogo:Bool?
    
    override func viewDidDisappear(_ animated: Bool) {
        completionHandler(true)
    }
//    override func viewDidLayoutSubviews() {
//        UIViewController.attemptRotationToDeviceOrientation()
//        super.viewDidLayoutSubviews()
//        if UIApplication.shared.statusBarOrientation == .portrait
//        {
//            DispatchQueue.main.async {
//                let orientation = UIInterfaceOrientation.landscapeRight.rawValue
//                UIDevice.current.setValue(orientation, forKey: "orientation")
//            }
//        }
//        else{
//            DispatchQueue.main.async {
//                let value = UIApplication.shared.statusBarOrientation.rawValue
//                UIDevice.current.setValue(value, forKey: "orientation")
//            }
//        }
//    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

