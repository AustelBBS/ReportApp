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
        
        usuario.placeholder = "Nombre de usuario"
        correo.placeholder = "Correo"
        contrasena.placeholder = "Contraseña"
        
        cancelarBtn.addTarget(self, action: "regresar", for: .touchUpInside)
        registrarBtn.addTarget(self, action: "registrar", for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func regresar() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func registrar() {
        let alert = UIAlertController(title: "Ok", message: "Registro exitoso!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            switch action.style {
            case .default:
                    self.performSegue(withIdentifier: "fromRegisterToMain", sender: self)
            case .cancel :
                print("cancel")
            case .destructive :
                print("destructive")
            
            }
        }))
        let service = WebService()
        let datos = SignIn(nombreUsuario: usuario.text, correo: correo.text, passwordHash: contrasena.text)
        let encoder = JSONEncoder()
        do {
            let datos = try encoder.encode(datos)
            DispatchQueue.main.async {
                service.register(data: datos) { (error) in
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
