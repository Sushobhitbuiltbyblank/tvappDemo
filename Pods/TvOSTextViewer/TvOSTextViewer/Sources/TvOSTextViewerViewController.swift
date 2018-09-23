//
//  TvOSTextViewerViewController.swift
//  TvOSTextViewer
//
//  Created by David Cordero on 15.02.17.
//  Copyright © 2017 David Cordero. All rights reserved.
//

import UIKit


private let defaultTextColor: UIColor = .white
private let defaultFontSize: CGFloat = 41
private let defaultFont: UIFont = .systemFont(ofSize: defaultFontSize)
private let defaultBackgroundBlurEffectStyle: UIBlurEffectStyle = .dark

public class TvOSTextViewerViewController: UIViewController {
    
    public var text: String = ""
    public var textEdgeInsets: UIEdgeInsets = .zero
    public var backgroundBlurEffectSyle = UIBlurEffect(style: defaultBackgroundBlurEffectStyle)
    public var textAttributes: [NSAttributedStringKey: Any] = [.foregroundColor: defaultTextColor,
                                                                .font: defaultFont]
    
    private var backgroundView: UIVisualEffectView!
    private var textView: UITextView!
    
    // MARK: UIViewController
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpView()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if textView.contentSize.height > textView.bounds.height {
            textView.contentInset = .zero
        }
        else {
            moveTextViewToTheCenter()
        }
    }
    
    // MARK: Private
    
    private func setUpView() {
//        setUpBackgroundView()
        setUpTextView()
        
        setUpConstraints()
    }
    
    private func setUpBackgroundView() {
        backgroundView = UIVisualEffectView(effect: backgroundBlurEffectSyle)
        view.addSubview(backgroundView)
    }
    
    private func setUpTextView() {
        textView = UITextView()
        textView.panGestureRecognizer.allowedTouchTypes = [NSNumber(integerLiteral: UITouchType.indirect.rawValue)]
        textView.isUserInteractionEnabled = true
        
        textView.attributedText = NSAttributedString(string: text,
                                                     attributes: textAttributes)
        textView.layer.borderColor = UIColor.white.cgColor
        textView.layer.borderWidth = 1.0
        textView.backgroundColor = UIColor.darkGray
        textView.showsVerticalScrollIndicator = true
        view.addSubview(textView)
    }

    private func moveTextViewToTheCenter() {
        var contentInset = UIEdgeInsets.zero
        contentInset.top = textView.bounds.height / 2
        contentInset.top -= textView.contentSize.height / 2
        textView.contentInset = contentInset
    }
    
    private func setUpConstraints() {
//        setUpBackgroundConstraints()
        setUpTextViewConstraints()
    }
    
    private func setUpBackgroundConstraints() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setUpTextViewConstraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let widthConstant = -(textEdgeInsets.left + textEdgeInsets.right)
        textView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: widthConstant).isActive = true
        textView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: textEdgeInsets.top).isActive = true
        textView.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: -(textEdgeInsets.bottom)).isActive = true
    }
}
