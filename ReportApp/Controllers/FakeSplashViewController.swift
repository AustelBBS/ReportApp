//
//  FakeSplashViewController.swift
//  ReportApp
//
//  Created by DonauMorgen on 22/06/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import UIKit

class FakeSplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        if UserDefaults.standard.bool(forKey: "loggedIn") {
            //skip
            performSegue(withIdentifier: "skipToMain", sender: self)
        } else {
            print("noskip")
            performSegue(withIdentifier: "noSkip", sender: self)
        }
    }

}
