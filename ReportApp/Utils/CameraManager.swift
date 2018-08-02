//
//  CameraManager.swift
//  ReportApp
//
//  Created by DonauMorgen on 14/05/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//
import Foundation
import UIKit


class CameraManager: NSObject{
    static let shared = CameraManager()
    
    fileprivate var currentVC: UIViewController!
    
    //MARK: Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    /*
     let actionSheetController: UIAlertController = UIAlertController(title: "SomeTitle", message: nil, preferredStyle: .actionSheet)
     
     let editAction: UIAlertAction = UIAlertAction(title: "Edit Details", style: .default) { action -> Void in
     
     print("Edit Details")
     }
     
     let deleteAction: UIAlertAction = UIAlertAction(title: "Delete Item", style: .default) { action -> Void in
     
     print("Delete Item")
     }
     
     let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
     
     actionSheetController.addAction(editAction)
     actionSheetController.addAction(deleteAction)
     actionSheetController.addAction(cancelAction)
     
     //        present(actionSheetController, animated: true, completion: nil)   // doesn't work for iPad
     
     actionSheetController.popoverPresentationController?.sourceView = yourSourceViewName // works for both iPhone & iPad
     
     present(actionSheetController, animated: true) {
     print("option menu presented")
     }
     */
    
    func showActionSheet(vc: UIViewController) {
        currentVC = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
}


extension CameraManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickedBlock?(image)
        }else{
            print("Something went wrong")
        }
        currentVC.dismiss(animated: true, completion: nil)
    }
    
}
