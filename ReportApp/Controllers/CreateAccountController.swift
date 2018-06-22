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
        self.hideKeyboardOnTouch()
        usuario.placeholder = "Nombre de usuario"
        correo.placeholder = "Correo"
        contrasena.placeholder = "Contraseña"
        
        cancelarBtn.addTarget(self, action: #selector(CreateAccountController.regresar), for: .touchUpInside)
        registrarBtn.addTarget(self, action: #selector(CreateAccountController.registrar), for: .touchUpInside)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func regresar() {
        performSegue(withIdentifier: "goBackToLogin", sender: self)
    }
    
    @objc func registrar() {
        let pass = contrasena.text
        let confirmPass = confirmarContrasena.text
        if usuario.text != "" || correo.text != "" || pass != "" || confirmPass != "" {
            if pass == confirmPass {
                let service = WebService()
                let datos = SignIn(username: usuario.text, email: correo.text, pass: contrasena.text)
                let encoder = JSONEncoder()
                do {
                    let datos = try encoder.encode(datos)
                    DispatchQueue.main.async {
                        service.register(data: datos, method: "POST") { (error, success, response) in
                            if let error = error {
                                fatalError(error.localizedDescription)
                            }
                            if success! && response != "error"{
                                self.displayAlert(title: "Ok", message: "Registro Exitoso!", style: .default, actionTitle: "Ok")
                            } else {
                                self.displayAlert(title: "Error", message: "Usuario o correo ya registrados!", style: .default, actionTitle: "Ok")
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
    
    func displayAlert(title: String, message: String, style: UIAlertActionStyle, actionTitle : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: style, handler: { (action) in
            switch action.style {
            case .default:
                self.performSegue(withIdentifier: "goBackToLogin", sender: self)
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

