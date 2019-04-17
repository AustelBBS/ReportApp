//
//  SettingsViewController.swift
//  ReportApp
//
//  Created by DonauMorgen on 22/06/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var useData: UISwitch!
    
    @IBOutlet weak var picker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        useData.setOn(UserDefaults.standard.bool(forKey: "useData"), animated: true)
        picker.selectRow(UserDefaults.standard.integer(forKey: "savedReports"), inComponent: 0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //Limt
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return String(format:"%i",row+1)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.setValue(row, forKey: "savedReports")
    }
    

    @IBAction func tappedSwitch(_ sender: UISwitch) {
        if useData.isOn {
            UserDefaults.standard.set(true, forKey: "useData")
        } else {
            UserDefaults.standard.set(false, forKey: "useData")
        }
    }
}
