//
//  CreateAccountController.swift
//  ReportApp
//
//  Created by DonauMorgen on 17/04/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import UIKit

class CreateAccountController: UIViewController {
    
    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var contrasena : UITextField!
    
    @IBOutlet weak var confirmarContrasena: UITextField!
    @IBOutlet weak var registrarBtn: UIButton!
    @IBOutlet weak var cancelarBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Descomentar para hacer que el teclado detecte si tapa un textfield
        //KeyboardAvoiding.avoidingView = self.view
        self.hideKeyboardOnTouch()
        registrarBtn.layer.cornerRadius = 20.0
        cancelarBtn.layer.cornerRadius = 20.0
        usuario.placeholder = "Nombre de usuario"
        correo.placeholder = "Correo"
        contrasena.placeholder = "Contraseña"
    }
    
    
    @IBAction func cancelRegistration(_ sender: Any) {
        print("Clicked")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func registrar(_ sender: Any) {
        let pass = contrasena.text
        let confirmPass = confirmarContrasena.text
        if usuario.text != "" && correo.text != "" && pass != "" && confirmPass != "" {
            if pass == confirmPass {
                let service = WebService()
                let datos = SignIn(email: correo.text!, username: usuario.text!, pass: contrasena.text!)
                let encoder = JSONEncoder()
                do {
                    let datos = try encoder.encode(datos)
                    service.register(data: datos, method: "POST") { (error, success, response) in
                        if let error = error {
                            fatalError(error.localizedDescription)
                        }
                        if success! && response != "error"{
                            DispatchQueue.main.async {
                                self.displayAlert(title: "Ok", message: "Registro Exitoso!", style: .default, actionTitle: "Ok")
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.displayAlert(title: "Error", message: response!, style: .cancel, actionTitle: "Ok")
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                displayAlert(title: "Error", message: "Las contraseñas no coinciden.", style: .cancel, actionTitle: "Ok")
            }
        } else {
            displayAlert(title: "Campo vacío", message: "Por favor llena todos los campos.", style: .cancel, actionTitle: "Ok")
        }
        
    }
    
    func displayAlert(title: String, message: String, style: UIAlertAction.Style, actionTitle : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: style, handler: { (action) in
            switch action.style {
            case .default:
                self.navigationController?.popViewController(animated: true)
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
                self.navigationController?.popViewController(animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

