//
//  PopupViewController.swift
//  ReportApp
//
//  Created by Macintosh on 7/31/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var background: UIView!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        background.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
