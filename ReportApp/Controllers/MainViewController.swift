//
//  ViewController.swift
//  ReportApp
//
//  Created by DonauMorgen on 13/03/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, UITabBarDelegate {
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
    @IBOutlet weak var mRightBtn: UITabBarItem!
    @IBOutlet weak var mMiddleBtn: UITabBarItem!
    @IBOutlet weak var mLeftBtn: UITabBarItem!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var mExitBtn: UIButton!
    var mLatitud : Double?
    var mLongitud : Double?
    var mReportType : String?
    var isMenuHidden = true
    var gpsManager : Geolocalization?
    let service = WebService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareController()
    }
    
    func prepareController() {
        mReportType = "alumbrado"
        self.hideKeyboardOnTouch()
        self.setKeyboardHandlers()
        gpsManager = Geolocalization()
        gpsManager?.requestLocation()
        let localLocation = gpsManager?.requestCoords()
        locationInput.text = "Lat: ((localLocation?.coordinate.latitude)!) Lon: ((localLocation?.coordinate.longitude)!)"
        mLatitud = Double(localLocation?.coordinate.latitude ?? 0)
        mLongitud = Double(localLocation?.coordinate.longitude ?? 0)
        tabBar.delegate = self
        mImageLogo.layer.cornerRadius = 8.0
        mImageLogo.clipsToBounds = true
        mConfig.layer.cornerRadius = 8.0
        mComments.layer.cornerRadius = 8.0
        mReports.layer.cornerRadius = 8.0
        mSend.layer.cornerRadius = 8.0
        mExitBtn.layer.cornerRadius = 8.0
        descriptionInput.isEditable = true
        descriptionInput.isUserInteractionEnabled = true
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
    
    @IBAction func logout(_ sender: UIButton) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func sendReport(_ sender: UIButton) {
        print(mReportType)
        let params = Report(descripcion: descriptionInput.text, latitud: mLatitud, longitud: mLongitud, tipo: mReportType)
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(params)
            service.sendPost(data: data, token: UserDefaults.standard.string(forKey: "UserToken")!) {
                error in
                print(error)
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item == mLeftBtn {
            changeImage(name: "lamp")
            mReportType = "alumbrado"
        } else if item == mMiddleBtn {
            changeImage(name: "bache")
            mReportType = "bacheo"
        } else {
            changeImage(name: "basura")
            mReportType = "sanidad"
        }
    }
    
    func changeImage (name: String) {
        reportImageType.image = UIImage(named: name)
    }
    
    
    
    
}


