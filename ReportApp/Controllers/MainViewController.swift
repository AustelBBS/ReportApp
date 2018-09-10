//
//  ViewController.swift
//  ReportApp
//
//  Created by DonauMorgen on 13/03/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import UIKit
import CoreLocation
import Instructions
class MainViewController: UIViewController, UITabBarDelegate, CoachMarksControllerDataSource, CoachMarksControllerDelegate {
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
    @IBOutlet weak var directory: UIButton!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var motd: UILabel!
    
    @IBOutlet weak var coachPlaceholder: UIView!
    /*
     
     
     Toca para ver los detalles o enviar un mensaje a un administrador.
     En esta sección se muestra tu historial de reportes enviados.
     
     
     */
    
    var mLatitud : Double?
    var mLongitud : Double?
    var mReportType : String?
    var isMenuHidden = true
    var gpsManager : Geolocalization?
    let service = WebService()
    let coachMarksController = CoachMarksController()
    var coachMarksArray = [CoachMarkStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.coachMarksController.dataSource = self
        self.coachMarksController.overlay.allowTap = true
        self.coachMarksController.overlay.color = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 0.6776541096)
        loadCoachMarkArray()
        prepareController()
        showMOTD()
    }
    
    func loadCoachMarkArray(){
        coachMarksArray.append(CoachMarkStruct(message: "Con esta aplicación podrás enviar reportes sobre fallas en el alumbrado público, baches en las calles o basura a las autoridades municipales.", view: coachPlaceholder))
        coachMarksArray.append(CoachMarkStruct(message: "Puedes agregar una foto a tu reporte.", view: topContainer))
        coachMarksArray.append(CoachMarkStruct(message: "Si te es posible, trata de que se vean referencias en la foto.", view: topContainer))
        coachMarksArray.append(CoachMarkStruct(message: "Con el GPS se envía la ubicación exacta de tu reporte.", view: gps))
        coachMarksArray.append(CoachMarkStruct(message: "También puedes incluir una descripción, comentarios o referencias.", view: descriptionInput))
        coachMarksArray.append(CoachMarkStruct(message: "No olvides indicar qué tipo de reporte es:", view: tabBar))
        coachMarksArray.append(CoachMarkStruct(message: "Presiona aquí para enviar tu reporte.", view: send))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.viewWillDisappear(animated)
        self.coachMarksController.stop(immediately: true)
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return coachMarksArray.count
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        if let view = coachMarksArray[index].view{
            return coachMarksController.helper.makeCoachMark(for: view)
        }else{
            let c = coachMarksController.helper.makeCoachMark(for: self.view, pointOfInterest:   CGPoint(x: 200, y:700), cutoutPathMaker: nil)
             //CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
            return c
        }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        var coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: index != 0, withNextText: false, arrowOrientation:
            coachMark.arrowOrientation)

        coachViews.bodyView.hintLabel.text = coachMarksArray[index].message
        coachViews.bodyView.nextLabel.text = nil
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        
    }
    
    func prepareController() {
        mReportType = "lighting"
        self.hideKeyboardOnTouch()
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
        descriptionInput.placeholder = "¿Que más nos quieres decir?"
        directory.layer.cornerRadius = 8.0
    }
    
    func showMOTD() {
        let service = WebService()
        service.loadMOTD(token:  UserDefaults.standard.string(forKey: "UserToken")!, method: "GET") {
            data in
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(MOTD.self, from: data!)
                DispatchQueue.main.async {
                    self.userLabel.text = UserDefaults.standard.string(forKey: "user")
                    self.motd.text = response.Message
                    self.displayAlert(msg: response.Message!, title: "Mensaje del día")
                }
            } catch {
                print(error)
            }
        }
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
            leftConstraint.constant = -200
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        isMenuHidden = !isMenuHidden
    }
    
    @IBAction func logout(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "loggedIn")
        UserDefaults.standard.synchronize()
        print("logging off")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendReport(_ sender: UIButton) {
        let params = Report(description: descriptionInput.text, latitude: mLatitud, longitude: mLongitud, type: mReportType)
        let cdReport = ReportModel(context: PersistenceService.context)
        cdReport.descripcion = descriptionInput.text
        cdReport.latitude = mLatitud!
        cdReport.longitude = mLongitud!
        cdReport.type = mReportType
        cdReport.reportImage = UIImagePNGRepresentation(reportImageType.image!)
        PersistenceService.saveContext()
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
                    let responseId = try! jsonDecoder.decode(ReportInfo.self, from: response!)
                    self.uploadPhoto(id: responseId.ReportId!)
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
                self.displayAlert(msg: "Reporte enviado!", title: "Estado")
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
    
    func displayAlert(msg: String, title: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
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
    
    @IBAction func showHelp(_ sender: UIBarButtonItem) {
        self.coachMarksController.start(on: self)
    }
    
    
}



