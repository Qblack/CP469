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
    
    let updateUrl = "http://192.168.0.100:5000/updateControl"
    var moduleInfo = ModuleInfo()
    var pageTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        header.title = pageTitle
        nodeId.text = moduleInfo.Id
        moduleId.text = moduleInfo.moduleId
        sensors.text = ModuleStatus(rawValue: moduleInfo.nodeStatus.toInt()!)?.toString
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
        
        var params: Dictionary<String, NSObject> = ["moduleID":moduleInfo.moduleId, "commands":[16], "values":[0]]
        updateControl(params)
    }

    @IBAction func toggleOn(sender: UIButton) {
        onLabel.layer.borderWidth = 3.0
        offLabel.layer.borderWidth = 0
        
        var params: Dictionary<String, NSObject> = ["moduleID":moduleInfo.moduleId, "commands":[16], "values":[1]]
        updateControl(params)
    }
    
    func updateControl(params : Dictionary<String, NSObject>) {
        var req = NSMutableURLRequest(URL: NSURL(string: updateUrl)!)
        var session = NSURLSession.sharedSession()
        req.HTTPMethod = "POST"
        
        var err: NSError?
        req.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(req, completionHandler: {data, response, error -> Void in
            //print that we toggled the light
            //we only ever get back 1, so there's nothing we can do or know
            //if it didn't actually change the light
            println("Toggled main light.")
        })
        
        task.resume()
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
