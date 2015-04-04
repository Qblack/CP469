//
//  TemperatureViewController.swift
//  SensorNetApp
//
//  Created by Quinton Black on 2015-03-28.
//  Copyright (c) 2015 Quinton and Brian. All rights reserved.
//

import UIKit

class TemperatureViewController: UIViewController {

    @IBOutlet weak var nodeIdLabel: UILabel!
    @IBOutlet weak var moduleIdLabel: UILabel!
    @IBOutlet weak var sensorsLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var loader: UIImageView!
    @IBOutlet weak var refreshIcon: UIImageView!
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var refreshButton: UIButton!
    
    var helpVisible = false
    var auto = false
    var timer: NSTimer!
    var moduleInfo = ModuleInfo()
    var pageTitle = ""
    var help: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.title = pageTitle
        nodeIdLabel.text = moduleInfo.Id
        moduleIdLabel.text = moduleInfo.moduleId
        sensorsLabel.text = ModuleStatus(rawValue: moduleInfo.nodeStatus.toInt()!)?.toString
        descLabel.numberOfLines = 0
        descLabel.text = moduleInfo.description
        temperatureLabel.text = moduleInfo.values[1]
        humidityLabel.text = moduleInfo.values[0]
        
        //setup the loader
        loader.animationImages = [UIImage]()
        for var i = 1; i <= 8; i++ {
            var image = String(i)
            loader.animationImages?.append(UIImage(named: image)!)
        }
        loader.animationDuration = 1
        
        //create help dialog
        help = UIView(frame: CGRectMake(20, 100, self.view.bounds.width - 40, 0))
        help.backgroundColor = UIColor(white: 0.5, alpha: 0.95)
        self.view.addSubview(help)
        
        let helpDesc = UILabel(frame: CGRectMake(15, 10, help.bounds.width - 15, self.view.bounds.height - 130))
        helpDesc.textAlignment = NSTextAlignment.Left
        helpDesc.numberOfLines = 0
        helpDesc.textColor = UIColor.whiteColor()
        helpDesc.font = UIFont(name: "System", size: CGFloat(22))
//        helpDesc.text = "This screen displays details about the temperature and humidity in the room that the sensor exists.  By default you have to manually refresh the screen to update the data.  You have the option to enable auto-updating by toggling the switch."
        help.addSubview(helpDesc)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func helpClicked(sender: UIButton) {
        helpVisible = !helpVisible
        
        //show or hide the help dialog
        if (helpVisible) {
            UIView.animateWithDuration(2, animations: {
                self.help.frame.size = CGSizeMake(self.view.bounds.width - 40, self.view.bounds.height - 120)
            })
        }
        else {
            UIView.animateWithDuration(2, animations: {
                self.help.frame.size = CGSizeMake(self.view.bounds.width - 40, 0)
            })
        }
    }

    @IBAction func refreshClicked(sender: UIButton) {
        refreshIcon.hidden = true
        loader.startAnimating()
        loader.hidden = false
        
        //create notification to check temp later
        sendNotification()
        
        self.getDataFromService()
    }
    
    @IBAction func autoSwitched(sender: UISwitch) {
        if (sender.on) {
            auto = true
            refreshIcon.hidden = true
            refreshButton.enabled = false
        
            timer = NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: Selector("getDataFromService"), userInfo: nil, repeats: true)
        }
        else {
            auto = false
            refreshIcon.hidden = false
            refreshButton.enabled = true
            timer.invalidate()
        }
    }
    
    ///////////////////////////////////////////////////////////
    
    func getDataFromService() {
        
        //create url path to get APIs
        var urlPath: String = "http://192.168.0.100:5000/getModuleInfo?moduleID=" + moduleInfo.moduleId
        
        println(urlPath)
        
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        session.configuration.timeoutIntervalForRequest = 30
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            
            //check for errors
            if error != nil {
                println(error)
                //call main thread to do loady stuff
                dispatch_async(dispatch_get_main_queue(), {
                    if (!self.auto) {
                        self.refreshIcon.hidden = false
                    }
                    self.loader.stopAnimating()
                    self.loader.hidden = true
                    
                    //clear values so it's clear there was an error
                    self.temperatureLabel.text = "-"
                    self.humidityLabel.text = "-"
                    
                    let alert = UIAlertController(title: "Error", message:
                        error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                return
            }
            
            //call to parse the JSON
            let json = JSON(data:data)
            DataAccessLayer.parseModuleInfo(json)
            
            //call main thread to do loady stuff
            dispatch_async(dispatch_get_main_queue(), {
                if (!self.auto) {
                    self.refreshIcon.hidden = false
                }
                self.loader.stopAnimating()
                self.loader.hidden = true
                
                //find environment module
                for i in 0...Storage.modulesInfo.count - 1 {
                    var mod = Storage.modulesInfo[i]
                    if mod.moduleId == self.moduleInfo.moduleId {
                        self.temperatureLabel.text = mod.values[1]
                        self.humidityLabel.text = mod.values[0]
                    }
                }
            })
        })
        task.resume()
    }
    ////////////////////////////////////////////////////////////
    
    //setup a notification to check temp again after 10 minutes
    //http://www.ioscreator.com/tutorials/local-notification-tutorial-ios8-swift
    func sendNotification() {
        var localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 20)//600)
        localNotification.alertBody = "Check the temperature."
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
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
