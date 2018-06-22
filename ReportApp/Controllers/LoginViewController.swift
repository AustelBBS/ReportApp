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
    
    @IBAction func unwindFromCreate(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindFromMain(segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.hideKeyboardOnTouch()
        self.setKeyboardHandlers()
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
        let credentials = Login(username: userTF.text, pass: passTF.text)
        var token : String?
        var done = false
        do {
            let data = try encoder.encode(credentials)
            service.login(data: data, method: "POST") { (loginToken) in
                UserDefaults.standard.set(loginToken, forKey: "UserToken")
                token = UserDefaults.standard.string(forKey: "UserToken")
            }
            repeat {
                if token != nil {
                    done = true
                }
            } while !done
            done = false
            var loggedIn = false
            
            service.testLogin(token: token!, method: "GET") { (response) in
                if response! {
                    done = response!
                    loggedIn = true
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
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.userTF.text = ""
        self.passTF.text = ""
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func createAccount(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toCreateAccount", sender: self)
    }
    
}



