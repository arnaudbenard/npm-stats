//
//  ModuleDetailViewController.swift
//  my-npm
//
//  Created by Arnaud Benard on 28/07/2015.
//  Copyright (c) 2015 Arnaud Benard. All rights reserved.
//

import UIKit

class ModuleDetailViewController: UIViewController {

    @IBOutlet var ModuleDetailView: UIView!
    
    @IBOutlet weak var moduleLabel: UILabel!
    
    var moduleName: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moduleLabel.text = moduleName
    }
}
