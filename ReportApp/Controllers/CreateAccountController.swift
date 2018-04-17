//
//  CreateAccountController.swift
//  ReportApp
//
//  Created by DonauMorgen on 17/04/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import UIKit

class CreateAccountController: UIViewController {

    @IBOutlet weak var nombreTF: UITextField!
    @IBOutlet weak var sexoTF: UITextField!
    @IBOutlet weak var fechaTF : UITextField!
    @IBOutlet weak var correoTF : UITextField!
    @IBOutlet weak var contraseñaTF : UITextField!
    @IBOutlet weak var confirmarTF : UITextField!
    @IBOutlet weak var telefonoTF : UITextField!
    @IBOutlet weak var registrarBtn: UIButton!
    @IBOutlet weak var cancelarBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nombreTF.placeholder = "Nombre"
        sexoTF.placeholder = "Sexo"
        fechaTF.placeholder = "Fecha de Nacimiento"
        correoTF.placeholder = "Correo"
        contraseñaTF.placeholder = "Contraeña"
        confirmarTF.placeholder = "Confirmar contraseña"
        telefonoTF.placeholder = "Teléfono"
        
        cancelarBtn.addTarget(self, action: "regresar", for: .touchUpInside)
        registrarBtn.addTarget(self, action: "registrar", for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func regresar() {
        print("regresar")
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
        self.present(alert, animated: true, completion: nil)
    }


}
