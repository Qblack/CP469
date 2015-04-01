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
    @IBOutlet weak var offLabel: UILabel!
    @IBOutlet weak var onLabel: UILabel!
    
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
        
        onLabel.layer.borderColor = UIColor.whiteColor().CGColor
        offLabel.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toggleOff(sender: UIButton) {
        onLabel.layer.borderWidth = 0
        offLabel.layer.borderWidth = 3.0
    }

    @IBAction func toggleOn(sender: UIButton) {
        onLabel.layer.borderWidth = 3.0
        offLabel.layer.borderWidth = 0
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
