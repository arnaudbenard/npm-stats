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
    let npm = npmAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        npm.fetchModules(moduleNames) { response, _ in
            for (name, data) in response! {
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
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "My modules"
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
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let destinationViewController = segue.destinationViewController as? ModuleDetailViewController {
            if let cell = sender as? UITableViewCell, text = cell.textLabel?.text {
                destinationViewController.moduleName? = text
            }
        }

    }

}
