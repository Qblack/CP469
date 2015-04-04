//
//  SwitchViewController.swift
//  SensorNetApp
//
//  Created by Quinton Black on 2015-03-28.
//  Copyright (c) 2015 Quinton and Brian. All rights reserved.
//

/* Title:       SwitchViewController.swift
 * Date:        March 28, 2015
 * Author:      Brian Sage and Quinton Black
 * Description: This is the view controller file for the main light switch.
 *              It contains all the methods necessary to control the UI and interact
 *              with the user. It also contains the method that will go out and get
 *              the specific module information we're interested in.
 */

import UIKit
import Foundation
import QuartzCore

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
    var helpVisible = false
    var help: UIView!
    var helpDesc: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //gradients: http://www.reddit.com/r/swift/comments/27mrlx/gradient_background_of_uiview_in_swift/
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        let cor1 = UIColor(white: 0.1, alpha: 0.98).CGColor
        let cor2 = UIColor(white: 0.5, alpha: 0.98).CGColor
        let arrayColors = [cor1, cor2]        
        gradient.colors = arrayColors
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        header.title = moduleInfo.name
        nodeId.text = moduleInfo.Id
        moduleId.text = moduleInfo.moduleId
        sensors.text = ModuleStatus(rawValue: moduleInfo.nodeStatus.toInt()!)?.toString
        descLabel.numberOfLines = 0
        descLabel.text = moduleInfo.description
        
        onLabel.layer.borderColor = UIColor.whiteColor().CGColor
        offLabel.layer.borderColor = UIColor.whiteColor().CGColor
        
        //create help dialog
        help = UIView(frame: CGRectMake(20, 100, self.view.bounds.width - 40, 0))
        help.backgroundColor = UIColor(white: 0.5, alpha: 0.98)
        self.view.addSubview(help)
        
        helpDesc = UILabel(frame: CGRectMake(15, 10, help.bounds.width - 15, self.view.bounds.height * 0.5))
        helpDesc.textAlignment = NSTextAlignment.Left
        helpDesc.numberOfLines = 0
        helpDesc.textColor = UIColor.whiteColor()
        helpDesc.font = UIFont(name: "System", size: CGFloat(22))
        helpDesc.text = "Main Light\n\n\nThis allows you to toggle the main light on and off.\n\nJust remember, with great power comes great responsibility."
        help.addSubview(helpDesc)
        helpDesc.alpha = 0
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
    
    @IBAction func helpClicked(sender: UIButton) {
        helpVisible = !helpVisible
        
        //show or hide the help dialog
        if (helpVisible) {
            UIView.animateWithDuration(2, animations: {
                self.help.frame.size = CGSizeMake(self.view.bounds.width - 40, self.view.bounds.height - 120)
            })
            UIView.animateWithDuration(1, delay: 1, options: nil, animations: {
                self.helpDesc.alpha = 1
                }, completion: nil)
        }
        else {
            UIView.animateWithDuration(2, animations: {
                self.help.frame.size = CGSizeMake(self.view.bounds.width - 40, 0)
            })
            UIView.animateWithDuration(1, animations: {
                self.helpDesc.alpha = 0
            })
        }
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
