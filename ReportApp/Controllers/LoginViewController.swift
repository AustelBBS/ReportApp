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
        let service = WebService()
        let encoder = JSONEncoder()
        let credentials = Login(nombreUsuario: userTF.text, passwordHash: passTF.text)
        var token : TestLogin?
        var done = false
        do {
            let data = try encoder.encode(credentials)
            service.login(data: data) { (loginToken) in
                print(loginToken)
                UserDefaults.standard.set(loginToken, forKey: "UserToken")
                token = TestLogin(token: UserDefaults.standard.string(forKey: "UserToken"))
            }
            repeat {
                if token != nil {
                    done = true
                }
            } while !done
            done = false
            var loggedIn = false
            let newToken = try encoder.encode(token)
            service.testLogin(data: newToken) { (response) in
                if response! {
                    done = response!
                    loggedIn = true
                } else {
                  done = true
                }
            }
            repeat {
            } while !done
            if loggedIn {
                self.userTF.text = ""
                self.passTF.text = ""
                self.performSegue(withIdentifier: "toMainView", sender: self)
            } else {
                displayAlert(msg: "Usuario no registrado!")
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func displayAlert(msg: String) {
        let alert = UIAlertController(title: "Ok", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            switch action.style {
            case .default:
                print("default")
            case .cancel :
                print("cancel")
            case .destructive :
                print("destructive")
            }
        }))
        self.userTF.text = ""
        self.passTF.text = ""
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func createAccount(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toCreateAccount", sender: self)
    }

}
