//
//  MessageViewController.swift
//  ReportApp
//
//  Created by DonauMorgen on 03/07/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//


import UIKit

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
  
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var mComment : UITextField!
    @IBOutlet weak var mChatLog: UITableView!
    @IBOutlet weak var mHeaderTitle: UILabel!
    @IBOutlet weak var mLocationLabel: UIButton!
    @IBOutlet weak var mDescriptionLabel: UILabel!
    @IBOutlet weak var mtableView: UITableView!
    var messages: [DownloadMsg] = []
    var userName: String = "omar"
    var report : ReportInfo?
    var maxWidth: CGFloat = 250
    
    override func viewDidLoad() {
        super.viewDidLoad()
        KeyboardAvoiding.avoidingView = self.view
        maxWidth = view.frame.width - 40
        userName = UserDefaults.standard.string(forKey: "user")!
        self.hideKeyboardOnTouch()
        mChatLog.delegate = self
        mChatLog.dataSource = self
        downloadPreviousMessages()
        if let title = CustomDateFormatter.dateTimeFrom(isoDate: report!.DateTime!){
            self.title = title
        }
        mDescriptionLabel.text = report!.Description
        mHeaderTitle.text = report!.Type! + " #" + report!.ReportId!.description
        mLocationLabel.setTitle( report!.Latitude!.description + ", " + report!.Longitude!.description, for: .normal)
        mtableView.register(UINib.init(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: MessageCell.reuseId)
        mtableView.allowsSelection = false
        HeaderView.frame.size.height = 40 + report!.Description!.height(withConstrainedWidth: view.frame.width - 50, font: UIFont.systemFont(ofSize: 16))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messages[indexPath.row]
        return message.Body.height(withConstrainedWidth: maxWidth, font: UIFont.systemFont(ofSize: 14)) + 10 + 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func downloadPreviousMessages() {
        let service = WebService()
            let params : [String : String] = ["reportId" :"\(report!.ReportId!)", "datetime": report!.DateTime!]
            let decoder = JSONDecoder()
            service.getMessages(data: params, method: "GET") { (error, done, data) in
                do {
                    let decodedData = try decoder.decode(MessageArray.self, from: data!)
                    self.messages = decodedData
                    DispatchQueue.main.async {
                        self.mtableView.reloadData()
                    }
                } catch {
                    print(error)
                }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageCell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseId) as? MessageCell
        let message = messages[indexPath.row]
        
        let rowHeight = message.Body.height(withConstrainedWidth: view.frame.width, font: UIFont.systemFont(ofSize: 14)) + 10
        let labelWidth = message.Body.width(withConstrainedHeight: rowHeight, font: UIFont.systemFont(ofSize: 14)) + 10
        
        messageCell?.mWidthConstraint.constant = labelWidth > maxWidth ? maxWidth : labelWidth
        messageCell?.mMessageLabel.text = message.Body
        
        if(message.UserName != userName){
            messageCell?.mBubbleView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            messageCell?.mMessageLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            messageCell?.mMessageLabel.textAlignment = .left
            messageCell?.mLeadingSpaceConstraint.constant = 5
        }else{
            messageCell?.mBubbleView.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            messageCell?.mMessageLabel.textColor = UIColor.white
            messageCell?.mMessageLabel.textAlignment = .right
            messageCell?.mLeadingSpaceConstraint.constant = view.frame.width - (labelWidth > maxWidth ? maxWidth : labelWidth) - 5
        }
    
        return messageCell!
    }
    
    
    @IBAction func sendComment(_ sender: UIButton?) {
        if let t = mComment.text{
            if (t.isEmpty){
                return
            }
            let m = DownloadMsg(UserName: userName, Body: t, DateTime: Date().description, ReportId: (report?.ReportId!)!)
            messages.append(m)
            mtableView.beginUpdates()
            mtableView.insertRows(at:[IndexPath(row: messages.count == 0 ? 0 : messages.count - 1, section: 0)], with: UITableView.RowAnimation.fade)
            mtableView.endUpdates()
            mtableView.scrollToRow(at: IndexPath(row: messages.count == 0 ? 0 : messages.count - 1, section: 0),at: .bottom , animated: true)
        }
        let encoder = JSONEncoder()
        let params = SendMsg(reportId: report!.ReportId!, body: mComment?.text)
        mComment.text = ""
        do {
            let data = try encoder.encode(params)
            let service = WebService()
            service.sendMessage(data: data, method: "POST") {
                error, done, response in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
                if done! {
                    DispatchQueue.main.async {
                        self.mComment?.text = ""
                        print(response!)
                    }
                }
                
            }
        } catch {
            print(error)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendComment(nil)
        return true
    }
    
    func displayAlert(msg: String) {
        let alert = UIAlertController(title: "Ok", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func openLocation(_ sender: Any) {
        guard let url = URL(string : "https://www.google.com/maps/search/?api=1&query=" + report!.Latitude!.description + "," + report!.Longitude!.description)
            else {return}
        UIApplication.shared.open(url)
    }
    
    
}
