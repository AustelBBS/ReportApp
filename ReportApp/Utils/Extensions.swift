//
//  Extensions.swift
//  ReportApp
//
//  Created by DonauMorgen on 07/05/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//
// Este archivo contiene las extensiones de agregar funcionalidad extra a algunas clases
import UIKit
import Foundation

let imageCache = NSCache<AnyObject, AnyObject>()

public extension UIViewController {
    //Closes keyboard on tap of screen
    func hideKeyboardOnTouch() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func didKeyboardShowed(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            } else {
                print(self.view.frame.origin.y)
                print(keyboardSize.height)
            }
        }
    }
    
    @objc func didKeyboardHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y < 0{
                self.view.frame.origin.y += keyboardSize.height
                if self.view.frame.origin.y != 0 {
                    self.view.frame.origin.y = 0
                }
            }
        }
    }

}

extension UIImageView {
    func downloadFromUrl(id: Int) {
        guard let imgURL: URL = URL(string: "http://uruapan.ddns.net:2020/reportapp/api/pictures/get/\(id)") else { return }

        image = nil
        
        if let imageFromCache = imageCache.object(forKey: imgURL.absoluteString as AnyObject) as? UIImage {
            print("Returning from cache")
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: imgURL) {
            data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil
                else {return}
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data)
                imageCache.setObject(imageToCache!, forKey: imgURL.absoluteString as AnyObject)
                self.image = imageToCache
            }
        }.resume()
    }
}

extension UITextView : UITextViewDelegate {
    override open var bounds : CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    public var placeholder : String? {
        get {
            var placeholderText : String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel{
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    private func addPlaceholder(_ placeholderText : String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.utf8CString.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
        
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

