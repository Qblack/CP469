//
//  SwitchViewController.swift
//  SensorNetApp
//
//  Created by Quinton Black on 2015-03-28.
//  Copyright (c) 2015 Quinton and Brian. All rights reserved.
//

import UIKit
import Foundation

class SwitchViewController: UIViewController {
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nodeId: UILabel!
    @IBOutlet weak var moduleId: UILabel!
    @IBOutlet weak var sensors: UILabel!
    @IBOutlet weak var switchToggle: UISwitch!
    @IBOutlet weak var loader: UIImageView!
    @IBOutlet weak var header: UINavigationItem!
    
    var moduleInfo = ModuleInfo()
    var pageTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        header.title = pageTitle
        nodeId.text = moduleInfo.Id
        moduleId.text = moduleInfo.moduleId
        sensors.text = moduleInfo.nodeStatus
        descLabel.numberOfLines = 0
        descLabel.text = moduleInfo.description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleSwitch(sender: UISwitch) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
