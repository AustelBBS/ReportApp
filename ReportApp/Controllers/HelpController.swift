//
//  HelpController.swift
//  ReportApp
//
//  Created by Orlando Vergara on 4/16/19.
//  Copyright © 2019 Los Ponis. All rights reserved.
//

import UIKit

class HelpController: UIViewController {

    @IBOutlet weak var okBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        okBtn.layer.cornerRadius = 8.0
    }
    

    @IBAction func exit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
