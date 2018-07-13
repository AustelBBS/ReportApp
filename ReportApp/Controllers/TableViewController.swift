//
//  TableViewController.swift
//  ReportApp
//
//  Created by DonauMorgen on 16/03/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var mReports : [ReportInfo]?
    let service = WebService()
    var reportId : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        let token = UserDefaults.standard.string(forKey: "UserToken")
        var data : Data?
        var flag : Bool = false
        service.loadReports(token: token!, method: "GET") {
                responseData in
                data = responseData
                do {
                    let decoder = JSONDecoder()
                    let reportsArray = try decoder.decode(JSONArray.self, from: data!)
                    self.mReports = reportsArray
                    flag = true
                } catch {
                    print(error.localizedDescription)
                }
        }
        
        repeat {
        } while !flag
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (mReports?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? Cell

        let report = mReports![indexPath.row]
        if let id = report.ReportId {
         cell?.mImage?.downloadFromUrl(id:id)
        } else {
            print(report.ReportId!)
            cell?.mImage?.image = UIImage(named: "light")
        }
        
        cell?.mImage?.layer.cornerRadius = 8.0
        cell?.mImage?.clipsToBounds = true
        cell?.mStatusLabel?.text = report.Description
        cell?.mDateLabel?.text = report.DateTime

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let report = mReports![indexPath.row]
        reportId = report.ReportId
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toChat", sender: self)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MessageViewController {
            destination.reportId = reportId
        }
    }
 

}
