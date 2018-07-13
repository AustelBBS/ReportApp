//
//  MessageViewController.swift
//  ReportApp
//
//  Created by DonauMorgen on 03/07/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet weak var mComment : UITextField?
    @IBOutlet weak var mMsgHistory : UITextView?
    
    var reportId : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnTouch()
    }
    
    @IBAction func sendComment(_ sender: UIButton) {
        let encoder = JSONEncoder()
        let params = SendMsg(reportId: reportId, body: mComment?.text)
        do {
            let data = try encoder.encode(params)
            let service = WebService()
            let token = UserDefaults.standard.string(forKey: "UserToken")!
            let user = UserDefaults.standard.string(forKey: "user")!
            service.sendMessage(data: data, method: "POST") {
                error, done, response in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
                if done! {
                    DispatchQueue.main.async {
                        self.mMsgHistory?.text.append("\(user):\(self.mComment?.text! ?? "default")\n")
                        self.mComment?.text = ""
                        print(response!)
                    }
                }
                
            }
        } catch {
            print(error)
        }
    }
    
    func displayAlert(msg: String) {
        let alert = UIAlertController(title: "Ok", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
}
