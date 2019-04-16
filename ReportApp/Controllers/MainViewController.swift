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
    
    @IBOutlet weak var mSend : UIButton!
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var reportImageType: UIImageView!
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var gps: UIButton!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var send: UIButton!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        prepareController()
        showMOTD()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    //Prepara las propiedades visuales del controlador
    func prepareController() {
        //KeyboardAvoiding.avoidingView = self.view
        mReportType = "lighting"
        self.hideKeyboardOnTouch()
        gpsManager = Geolocalization()
        gpsManager?.requestLocation()
        if let localLocation = gpsManager?.requestCoords(){
            setLocation(localLocation: localLocation)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(exit(_:)), name: NSNotification.Name(rawValue: "exit"), object: nil)
        mSend.layer.cornerRadius = 8.0
        descriptionInput.isEditable = true
        descriptionInput.isUserInteractionEnabled = true
        descriptionInput.placeholder = "¿Que más nos quieres decir?"
    }
    //Muestra el mensaje del dia
    func showMOTD() {
        let service = WebService()
        service.loadMOTD(token:  UserDefaults.standard.string(forKey: "cookie")!, method: "GET") {
            data in
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(MOTD.self, from: data!)
                DispatchQueue.main.async {
                    UserDefaults.standard.setValue(response.Message, forKey: "MOTD")
                    self.displayAlert(msg: response.Message!, title: "Mensaje del día")
                }
            } catch {
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //Cierra sesion
    @objc func exit(_ notification: Notification) {
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "Login") as UIViewController
        self.present(initialViewControlleripad, animated: true, completion: nil)
    }
    //Envia un reporte
    @IBAction func sendReport(_ sender: UIButton) {
        if !locationInput.text!.isEmpty {
            let params = Report(description: descriptionInput.text, latitude: mLatitud, longitude: mLongitud, type: mReportType)
            let cdReport = ReportModel(context: PersistenceService.context)
            cdReport.descripcion = descriptionInput.text
            cdReport.latitude = mLatitud!
            cdReport.longitude = mLongitud!
            cdReport.type = mReportType
            cdReport.reportImage = reportImageType.image!.pngData()
            PersistenceService.saveContext()
            if let useData = UserDefaults.standard.value(forKey: "useData") {
                if useData as! Bool {
                    let jsonEncoder = JSONEncoder()
                    let jsonDecoder = JSONDecoder()
                    do {
                        let data = try jsonEncoder.encode(params)
                        service.sendPost(data: data, token: UserDefaults.standard.string(forKey: "cookie")!) {
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
                } else {
                    self.displayAlert(msg: "El reporte se enviara cuando haya una conexion disponible", title: "No hay conexion")
                }
            }
            
        } else {
            self.displayAlert(msg: "Toca el icono del gps para obtner la localizacion.", title: "Sin localizacion")
        }
    }
    //Sube la imagen del reporte
    func uploadPhoto(id : Int) {
        service.uploadImage(image: reportImageType.image!, id: id) {
            done in
            if done! {
                self.displayAlert(msg: "Reporte enviado!", title: "Estado")
                self.resetUI()
            }
        }
    }
    //Borra el contenido del reporte anterior
    func resetUI() {
        changeImage(name: "lamp")
        mReportType = "lighting"
        descriptionInput.placeholder = "¿Que más nos puedes decir?"
        locationInput.text = "Toca el gps para tener ubicación."
    }
    //Cambia la iamgen del tipo de reporte
    func changeImage (name: String) {
        reportImageType.image = UIImage(named: name)
    }
    
    //Obtiene la localizacion del telefono
    @IBAction func getLocation(_ sender: UIButton) {
        if let location = gpsManager?.requestCoords() {
            setLocation(localLocation: location)
        } else {
            gpsManager?.requestLocation()
        }
    }
    //Muestra mensajes alerta
    func displayAlert(msg: String, title: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.locationInput.text = ""
        self.descriptionInput.text = ""
        self.present(alert, animated: true, completion: nil)
    }
    
    //Fija la localizacion
    func  setLocation(localLocation: CLLocation) {
        locationInput.text = "Lat: \((localLocation.coordinate.latitude)) Lon: \((localLocation.coordinate.longitude))"
        mLatitud = Double(localLocation.coordinate.latitude)
        mLongitud = Double(localLocation.coordinate.longitude)
    }
    
    //Fija la camara
    @IBAction func selectPic(_ sender: UIButton) {
        CameraManager.shared.showActionSheet(vc: self)
        CameraManager.shared.imagePickedBlock =  {
            (image) in
            self.reportImageType.image = image
        }
    }
    //Muestra la ayuda
    //Libreria no compatible con swift 4.2+
    @IBAction func showHelp(_ sender: UIBarButtonItem) {
//        self.coachMarksController.start(on: self)
    }
    
    
}



