//
//  ViewController.swift
//  ReportApp
//
//  Created by DonauMorgen on 13/03/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    //hola
    @IBOutlet weak var mImageLogo: UIImageView!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var mConfig   : UIButton!
    @IBOutlet weak var mComments : UIButton!
    @IBOutlet weak var mReports  : UIButton!
    @IBOutlet weak var mSend : UIButton!
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var reportImageType: UIImageView!
    @IBOutlet weak var camera: UIImageView!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var gps: UIImageView!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var send: UIButton!
    
    var isMenuHidden = true
    override func viewDidLoad() {
        super.viewDidLoad()
        mImageLogo.layer.cornerRadius = 8.0
        mImageLogo.clipsToBounds = true
        mConfig.layer.cornerRadius = 8.0
        mComments.layer.cornerRadius = 8.0
        mReports.layer.cornerRadius = 8.0
        mSend.layer.cornerRadius = 8.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showMenu(_ sender: UIBarButtonItem) {
        if isMenuHidden {
            leftConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            leftConstraint.constant = -150
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        isMenuHidden = !isMenuHidden
    }
    
    
}

