//
//  LoginViewController.swift
//  ReportApp
//
//  Created by DonauMorgen on 16/04/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    
    @IBOutlet weak var linkLnl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTF.placeholder = "Usuario"
        passTF.placeholder = "Contraseña"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.createAccount))
        linkLnl.isUserInteractionEnabled = true
        linkLnl.addGestureRecognizer(tap)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: UIButton) {
        print("click")
        
        performSegue(withIdentifier: "toMainView", sender: self)
    }
    
    @objc func createAccount(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toCreateAccount", sender: self)
    }

}
