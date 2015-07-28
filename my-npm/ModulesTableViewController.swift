//
//  ModulesTableViewController.swift
//  my-npm
//
//  Created by Arnaud Benard on 28/07/2015.
//  Copyright (c) 2015 Arnaud Benard. All rights reserved.
//

import UIKit
import Alamofire

class ModulesTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewObject: UITableView!
    
    var moduleNames: [String] = ["elasto", "kue-ui", "hlcode", "gissues"]
    var moduleLabels: [String] = [String]()
    var moduleDetails: [String] = [String]()
    
    override func viewDidLoad() {
        var modules = ",".join(moduleNames)
        var url = "https://api.npmjs.org/downloads/point/last-month/\(modules)"
        
        // Move to model
        Alamofire.request(.GET, url).responseJSON { _, _, json, _ in
            if let dict = json as? NSDictionary {
                for (name, data) in dict {
                    
                    if let dataDict = data as? Dictionary<String, AnyObject>,
                        downloads = dataDict["downloads"] as? Int,
                        label = dataDict["package"] as? String {
                            
                        self.moduleLabels.append(label)
                        self.moduleDetails.append("\(downloads)")
                    }
                }
                self.tableViewObject.reloadData()
            }
    
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moduleNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        if moduleLabels.count > indexPath.row {
            cell.textLabel?.text = moduleLabels[indexPath.row]
        }
        
        if moduleDetails.count > indexPath.row {
            cell.detailTextLabel?.text = moduleDetails[indexPath.row]
        }
        return cell
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.performSegueWithIdentifier("showModuleDetail", sender: indexPath);
//    }
//
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        println("putan! \(sender?.description)")
//        println("putan! \(sender?.identifier)")
//
//    }

}
