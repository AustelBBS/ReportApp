//
//  SettingsViewController.swift
//  ReportApp
//
//  Created by DonauMorgen on 22/06/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var hideMOTDSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedSwitch(_ sender: UISwitch) {
        if hideMOTDSwitch.isOn {
            UserDefaults.standard.set(true, forKey: "useData")
        } else {
            UserDefaults.standard.set(false, forKey: "useData")
        }
    }
}
