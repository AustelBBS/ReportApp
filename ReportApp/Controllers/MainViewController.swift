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
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var gps: UIButton!
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
        mReportType = "lighting"
        self.hideKeyboardOnTouch()
        self.setKeyboardHandlers()
        gpsManager = Geolocalization()
        gpsManager?.requestLocation()
        if let localLocation = gpsManager?.requestCoords(){
            setLocation(localLocation: localLocation)
        }
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
        UserDefaults.standard.set("", forKey: "UserToken")
        UserDefaults.standard.synchronize()
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func sendReport(_ sender: UIButton) {
        let params = Report(description: descriptionInput.text, latitude: mLatitud, longitude: mLongitud, type: mReportType)
        let jsonEncoder = JSONEncoder()
        let jsonDecoder = JSONDecoder()
        do {
            let data = try jsonEncoder.encode(params)
            service.sendPost(data: data, token: UserDefaults.standard.string(forKey: "UserToken")!) {
                error, success, response in
                if error != nil {
                    print(error as Any)
                }
                if success! {
                    let responseId = try! jsonDecoder.decode(ResponseID.self, from: response!)
                    print(responseId.reportId!)
                    self.uploadPhoto(id: responseId.reportId!)
                }
            }
        } catch {
            print(error)
        }
        
    }
    
    func uploadPhoto(id : Int) {
        service.uploadImage(image: reportImageType.image!, id: id) {
            done in
            if done! {
                self.resetUI()
            }
        }
    }
    
    func resetUI() {
        changeImage(name: "lamp")
        mReportType = "lighting"
        descriptionInput.text = "¿Que más nos puedes decir?"
        locationInput.text = "Toca el gps para tener ubicación."
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item == mLeftBtn {
            changeImage(name: "lamp")
            mReportType = "lighting"
        } else if item == mMiddleBtn {
            changeImage(name: "bache")
            mReportType = "roads"
        } else {
            changeImage(name: "basura")
            mReportType = "trash"
        }
    }
    
    func changeImage (name: String) {
        reportImageType.image = UIImage(named: name)
    }
    
    @IBAction func getLocation(_ sender: UIButton) {
        if let location = gpsManager?.requestCoords() {
            setLocation(localLocation: location)
        } else {
            gpsManager?.requestLocation()
        }
    }
    
    func displayAlert(msg: String) {
        let alert = UIAlertController(title: "Ok", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.locationInput.text = ""
        self.descriptionInput.text = ""
        self.present(alert, animated: true, completion: nil)
    }
    
    func  setLocation(localLocation: CLLocation) {
        locationInput.text = "Lat: \((localLocation.coordinate.latitude)) Lon: \((localLocation.coordinate.longitude))"
        mLatitud = Double(localLocation.coordinate.latitude)
        mLongitud = Double(localLocation.coordinate.longitude)
    }
    
    @IBAction func selectPic(_ sender: UIButton) {
        CameraManager.shared.showActionSheet(vc: self)
        CameraManager.shared.imagePickedBlock =  {
            (image) in
            self.reportImageType.image = image
        }
    }
    
    
    
}


