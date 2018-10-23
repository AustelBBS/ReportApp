//
//  CommentViewController.swift
//  ReportApp
//
//  Created by DonauMorgen on 04/06/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    @IBOutlet weak var mComment : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnTouch()
    }

    @IBAction func sendComment(_ sender: UIButton) {
        let encoder = JSONEncoder()
        let params = Comment(comments: mComment?.text)
        do {
            let data = try encoder.encode(params)
            let service = WebService()
            let token = UserDefaults.standard.string(forKey: "UserToken")!
            service.sendComments(data: data, token: token) {
                error, done, response in
                if error != nil {
                    print(error!)
                }
                if done! {
                    DispatchQueue.main.async {
                        self.displayAlert(msg: "Sugerencia enviada correctamente!")
                        self.mComment?.text = ""
                    }
                }
                
            }
        } catch {
            print(error)
        }
    }
    
    func displayAlert(msg: String) {
        let alert = UIAlertController(title: "Ok", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
}
