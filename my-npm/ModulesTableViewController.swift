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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    @IBAction func addModule(sender: UIBarButtonItem) {
        promptAddModuleModal()
    }
    
    var moduleLabels: [String] = [String]()
    var moduleDetails: [String] = [String]()
    let npm = npmAPI()
    let userSettings = UserSettings()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        
        var moduleNames = userSettings.modules as! [String]
        npm.fetchModules(moduleNames, period: npmAPI.Period.LastDay) { response, _ in
            if let res = response {
                self.appendTableData(res)
                self.tableViewObject.reloadData()
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Modules"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moduleLabels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.detailTextLabel?.textColor = UIColor.grayColor()

        if moduleLabels.count > indexPath.row {
            cell.textLabel?.text = moduleLabels[indexPath.row]
        }
        
        if moduleDetails.count > indexPath.row {
            cell.detailTextLabel?.text = "Last day: \(moduleDetails[indexPath.row]) downloads"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            let label = moduleLabels[indexPath.row]
            // remove the deleted item from the model
            self.userSettings.removeModule(label)
            self.moduleLabels.removeAtIndex(indexPath.row)
            self.moduleDetails.removeAtIndex(indexPath.row)
            // remove the deleted item from the `UITableView`
            self.tableViewObject.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? ModuleDetailViewController {
            if let cell = sender as? UITableViewCell, text = cell.textLabel?.text {
                // set title of the detail view to module name
                destinationViewController.moduleName = text
            }
        }
    }
    
    private func appendTableData(response: NSDictionary) {
        for (name, data) in response {
            if let dataDict = data as? Dictionary<String, AnyObject> {
                self.appendRowData(dataDict)
            }
        }
    }
    
    private func appendRowData(data: Dictionary<String, AnyObject>) {
        if let downloads = data["downloads"] as? Int, label = data["package"] as? String {
            self.moduleLabels.append(label)
            self.moduleDetails.append("\(downloads)")
        }
    }
    
    private func promptAddModuleModal() {
        
        let alertController = UIAlertController(title: "Add Module", message: "Enter the name of the module you would like to add to your list.", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Add", style: .Default) { (action) in
            let nameTextField = alertController.textFields![0] as! UITextField
            self.addModuleToSettings(nameTextField.text)
        }
        
        alertController.addAction(OKAction)

        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Name"
        }
        
        self.presentViewController(alertController, animated: true) {}
    }
    
    private func addModuleToSettings(name: String) {
        npm.fetchModule(name, period: npmAPI.Period.LastDay) { response, _ in
            if let module = response as? Dictionary<String, AnyObject> {
                self.appendRowData(module)
                self.userSettings.addModule(name)
                self.tableViewObject.reloadData()
                println("Added \(self.userSettings.modules.description)")
            }
        }
    }

}
