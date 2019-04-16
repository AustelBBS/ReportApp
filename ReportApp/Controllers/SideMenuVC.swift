//
//  SideMenuVC.swift
//  ReportApp
//
//  Created by Macintosh on 11/7/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController {

    @IBOutlet weak var mReports: UIButton!
    @IBOutlet weak var mDirectory: UIButton!
    @IBOutlet weak var mConfig: UIButton!
    @IBOutlet weak var mSendComments: UIButton!
    @IBOutlet weak var mLogout: UIButton!
    @IBOutlet weak var mUser: UILabel!
    @IBOutlet weak var mMOTD: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setup() {
        mReports.layer.cornerRadius = 12.0
        mDirectory.layer.cornerRadius = 12.0
        mConfig.layer.cornerRadius = 12.0
        mSendComments.layer.cornerRadius = 12.0
        mLogout.layer.cornerRadius = 12.0
        mUser.text = UserDefaults.standard.value(forKey: "user") as? String
        mMOTD.text = UserDefaults.standard.value(forKey: "MOTD") as? String
    }
    
    @IBAction func logout() {
        print("logout")
        UserDefaults.standard.set(false, forKey: "loggedIn")
        UserDefaults.standard.synchronize()
        self.dismiss(animated: true) {
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "exit"), object: nil)
        }
    }
    
    @IBAction func reports() {
        performSegue(withIdentifier: "toReports", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mUser.text = UserDefaults.standard.value(forKey: "user") as? String
        mMOTD.text = UserDefaults.standard.value(forKey: "MOTD") as? String
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
