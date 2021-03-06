//
//  LoginViewController.swift
//  ReportApp
//
//  Created by DonauMorgen on 16/04/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var linkLnl: UILabel!
    
    var activeField : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        KeyboardAvoiding.avoidingView = self.view
        self.hideKeyboardOnTouch()
        addKeyboardEvents()
        setDelegate()
        userTF.placeholder = "Usuario"
        passTF.placeholder = "Contraseña"
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.createAccount))
        linkLnl.isUserInteractionEnabled = true
        linkLnl.addGestureRecognizer(tap)
        loginBtn.layer.cornerRadius = 20.5;
        
    }
    
    func setDelegate() {
        self.userTF.delegate = self
        self.passTF.delegate = self
        self.activeField?.delegate = self
    }
    
    @IBAction func login(_ sender: UIButton) {
        attemptLogin()
    }
    
    func displayAlert(msg: String) {
        let alert = UIAlertController(title: "Ok", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.userTF.text = ""
        self.passTF.text = ""
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func createAccount(sender: UITapGestureRecognizer) {
        removeKeyboardEvents()
        performSegue(withIdentifier: "toCreateAccount", sender: self)
    }
    
    func addKeyboardEvents() {
        print("Add delegates")
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardEvents() {
        print("Remove keyboard")
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func attemptLogin() {
        let service = WebService()
        let encoder = JSONEncoder()
        let credentials = Login(username: userTF.text, pass: passTF.text)
        do {
            let data = try encoder.encode(credentials)
            service.login(data: data, method: "POST") { (loginToken) in
                if (loginToken?.contains("error"))! || (loginToken?.contains("Error"))! {
                    DispatchQueue.main.async {
                        self.displayAlert(msg: loginToken!)
                    }
                } else {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set("\(self.userTF.text!)", forKey: "user")
                        UserDefaults.standard.set(loginToken!, forKey: "cookie")
                        self.userTF.text = ""
                        self.passTF.text = ""
                        self.performSegue(withIdentifier: "toMainView", sender: self)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == passTF) {
            attemptLogin()
        } else {
            passTF.becomeFirstResponder()
        }
        return false
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                if let field = activeField {
                    let newInputYPos = (field.frame.origin.y)+keyboardSize.height
                    if newInputYPos >= self.view.frame.height {
                        self.view.frame.origin.y -= keyboardSize.height
                    } else {
                        print("No es necesario ejecutarse ya que no tapa el field!")
                    }
                } else {
                    setDelegate()
                }
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y < 0{
                self.view.frame.origin.y += keyboardSize.height
                if self.view.frame.origin.y != 0 {
                    self.view.frame.origin.y = 0
                }
            }
        }
    }
    
}



