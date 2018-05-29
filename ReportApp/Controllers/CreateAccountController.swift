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
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func registrar() {
        let alert = UIAlertController(title: "Ok", message: "Registro exitoso!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            switch action.style {
            case .default:
                _ = self.navigationController?.popToRootViewController(animated: true)
            case .cancel :
                print("cancel")
            case .destructive :
                print("destructive")
            }
        }))
        let service = WebService()
        let datos = SignIn(username: usuario.text, email: correo.text, pass: contrasena.text)
        let encoder = JSONEncoder()
        do {
            let datos = try encoder.encode(datos)
            DispatchQueue.main.async {
                service.register(data: datos, method: "POST") { (error) in
                    if let error = error {
                        fatalError(error.localizedDescription)
                    }
                }
            }
            self.present(alert, animated: true, completion: nil)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
}

