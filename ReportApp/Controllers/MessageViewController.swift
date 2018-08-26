//
//  MessageViewController.swift
//  ReportApp
//
//  Created by DonauMorgen on 03/07/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//


import UIKit

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var mComment : UITextField!
    @IBOutlet weak var mChatLog: UITableView!
    @IBOutlet weak var mHeaderTitle: UILabel!
    @IBOutlet weak var mLocationLabel: UIButton!
    @IBOutlet weak var mDescriptionLabel: UILabel!
    @IBOutlet weak var mtableView: UITableView!
    var messages: [DownloadMsg]?
    var userName: String = ""
    var report : ReportInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages = []
        messages?.append(DownloadMsg(UserName: "admin", Body: "hola", DateTime: "lol", ReportId: 1))
        messages?.append(DownloadMsg(UserName: UserDefaults.standard.string(forKey: "user")!, Body: "buenas tardes como podemos ayudarte", DateTime: "lol", ReportId: 1))
        messages?.append(DownloadMsg(UserName: "admin", Body: "este es el cuerpo de mi mensaje", DateTime: "lol", ReportId: 1))
        messages?.append(DownloadMsg(UserName: UserDefaults.standard.string(forKey: "user")!, Body: "fire and blood", DateTime: "lol", ReportId: 1))
        userName = UserDefaults.standard.string(forKey: "user")!
        self.hideKeyboardOnTouch()
        downloadPreviousMessages()
        if let title = CustomDateFormatter.dateTimeFrom(isoDate: report!.DateTime!){
            self.title = title
        }
        mDescriptionLabel.text = report!.Description
        mHeaderTitle.text = report!.Type! + " #" + report!.ReportId!.description
        mLocationLabel.setTitle( report!.Latitude!.description + ", " + report!.Longitude!.description, for: .normal)
        mtableView.register(UINib.init(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: MessageCell.reuseId)
        mtableView.allowsSelection = false
    }
    
    func downloadPreviousMessages() {
        let service = WebService()
       
            let params : [String : String] = ["reportId" :"\(report!.ReportId!)", "datetime": report!.DateTime!]
            let decoder = JSONDecoder()
            service.getMessages(data: params, method: "GET") { (error, done, data) in
                do {
                    let decodedData = try decoder.decode(DownloadMsg.self, from: data!)
                    print(decodedData)
                } catch {
                    print(error)
                }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (messages?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageCell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseId) as? MessageCell
        let message = messages![indexPath.row]
        if(message.UserName == userName){
            messageCell?.mStackView.alignment = .trailing
            messageCell?.mMessageLabel.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            messageCell?.mMessageLabel.titleLabel?.textAlignment = .left
        }else{
            messageCell?.mMessageLabel.backgroundColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
            messageCell?.mMessageLabel.titleLabel?.textAlignment = .right
            messageCell?.mStackView.alignment = .leading
        }
        messageCell?.mMessageLabel.setTitle(message.Body, for: .normal)
        return messageCell!
    }
    
    
    @IBAction func sendComment(_ sender: UIButton) {
        let encoder = JSONEncoder()
        let params = SendMsg(reportId: report!.ReportId!, body: mComment?.text)
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
                        //self.mMsgHistory?.text.append("\(user):\(self.mComment?.text! ?? "default")\n")
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
    
    @IBAction func openLocation(_ sender: Any) {
        guard let url = URL(string : "https://www.google.com/maps/search/?api=1&query=" + report!.Latitude!.description + "," + report!.Longitude!.description)
            else {return}
        UIApplication.shared.open(url)
    }
    
    
}
