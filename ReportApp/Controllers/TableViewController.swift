//
//  TableViewController.swift
//  ReportApp
//
//  Created by DonauMorgen on 16/03/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    var mReports : [ReportInfo]?
    let service = WebService()
    var report : ReportInfo?
    var localReports = [ReportModel]()
    var hasLocalReports = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest : NSFetchRequest<ReportModel> = ReportModel.fetchRequest()
        
        do {
            localReports = try PersistenceService.context.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        hasLocalReports = (localReports.count > 0) ? true : false
        
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
        
        if hasLocalReports {
            let report = localReports[indexPath.row]
            cell?.mImage?.image = UIImage(data: report.reportImage!)
            cell?.mImage?.layer.cornerRadius = 8.0
            cell?.mImage?.clipsToBounds = true
            cell?.mStatusLabel.text = report.descripcion
            cell?.mDateLabel.text = ""
            return cell!
        } else {
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
            if let d =  CustomDateFormatter.dateTimeFrom(isoDate: report.DateTime!){
                cell?.mDateLabel?.text = d
            }
            return cell!
        }
       
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        report = mReports![indexPath.row]
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toChat", sender: self)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MessageViewController {
            destination.report = report
        }
    }
 

}
