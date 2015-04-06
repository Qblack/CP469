//
//  TemperatureViewController.swift
//  SensorNetApp
//
//  Created by Quinton Black on 2015-03-28.
//  Copyright (c) 2015 Quinton and Brian. All rights reserved.
//

/* Title:       TemperatureViewController.swift
 * Date:        March 28, 2015
 * Author:      Brian Sage and Quinton Black
 * Description: This is the view controller file for the environment information page.
 *              It contains all the methods necessary to control the UI and interact
 *              with the user. It also contains the method that will go out and get
 *              the specific module information we're interested in.
 */

import UIKit

class TemperatureViewController: UIViewController {

    //GUI variables
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
    @IBOutlet weak var refreshCountdown: UILabel!
    @IBOutlet weak var shakeUI: UIView!
    
    //variables
    var helpVisible = false
    var auto = false
    var timer: NSTimer!
    var subTimer: NSTimer!
    var moduleInfo = ModuleInfo()
    var pageTitle = ""
    var help: UIView!
    var helpDesc: UILabel!
    var count = 10
    var hasSetupNotification = false
    
    override func viewWillDisappear(animated: Bool) {
        timer?.invalidate()
        subTimer?.invalidate()
    }
    
    /*
    *  This method allows for the shake gesture to be used
    */
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create gradient background
        //gradients: http://www.reddit.com/r/swift/comments/27mrlx/gradient_background_of_uiview_in_swift/
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        let cor1 = UIColor(white: 0.1, alpha: 0.98).CGColor
        let cor2 = UIColor(white: 0.5, alpha: 0.98).CGColor
        let arrayColors = [cor1, cor2]
        gradient.colors = arrayColors
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        //set all the label texts from the module info
        header.title = moduleInfo.name
        nodeIdLabel.text = moduleInfo.Id
        moduleIdLabel.text = moduleInfo.moduleId
        sensorsLabel.text = ModuleStatus(rawValue: moduleInfo.nodeStatus.toInt()!)?.toString
        descLabel.numberOfLines = 0
        descLabel.text = moduleInfo.description
        temperatureLabel.text = moduleInfo.values[1]
        humidityLabel.text = moduleInfo.values[0]
        
        //setup the loader animation
        loader.animationImages = [UIImage]()
        for var i = 1; i <= 8; i++ {
            var image = String(i)
            loader.animationImages?.append(UIImage(named: image)!)
        }
        loader.animationDuration = 1
        
        //make the shake overlay invisible
        shakeUI.alpha = 0
        
        //create help dialog
        help = UIView(frame: CGRectMake(20, 100, self.view.bounds.width - 40, 0))
        help.backgroundColor = UIColor(white: 0.5, alpha: 0.98)
        self.view.addSubview(help)
        
        helpDesc = UILabel(frame: CGRectMake(15, 10, help.bounds.width - 15, self.view.bounds.height * 0.5))
        helpDesc.textAlignment = NSTextAlignment.Left
        helpDesc.numberOfLines = 0
        helpDesc.textColor = UIColor.whiteColor()
        helpDesc.font = UIFont(name: "System", size: CGFloat(22))
        helpDesc.text = "Environment\n\n\nThis screen displays details about the temperature and humidity in the room that the sensor exists.\n\nBy default you have to manually refresh the screen to update the data.\n\nYou have the option to enable auto-updating by toggling the switch."
        help.addSubview(helpDesc)
        helpDesc.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    *  This method executes when a shake gesture is recognized.
    */
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if (!auto && !helpVisible) {
            if motion == .MotionShake {
                //show the shake overlay
                shakeUI.alpha = 0.95
                
                //schedule a task to make it fade after 1 second
                var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("hideOverlay"), userInfo: nil, repeats: false)
                
                //hide the refresh button and show the loader
                refreshIcon.hidden = true
                loader.startAnimating()
                loader.hidden = false
                
                //create notification to check temp later
                if (!hasSetupNotification) {
                    hasSetupNotification = true
                    sendNotification()
                }
                
                //call webservuce for data
                self.getDataFromService()
            }
        }        
    }
    
    /*
    *  This method makes the shake overlay fade away
    */
    func hideOverlay() {
        //animate the fading of the shake overlay
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.shakeUI.alpha = 0.0
            }, completion: nil)
    }

    /*
    *  This method executes when the refresh button is pressed
    */
    @IBAction func refreshClicked(sender: UIButton) {
        //hide the refresh button and show the loader
        refreshIcon.hidden = true
        loader.startAnimating()
        loader.hidden = false
        
        //create notification to check temp later
        if (!hasSetupNotification) {
            hasSetupNotification = true
            sendNotification()
        }
        
        //call webservuce for data
        self.getDataFromService()
    }
    
    /*
    *  This method executes when the auto update switch is toggled
    */
    @IBAction func autoSwitched(sender: UISwitch) {
        if (sender.on) {
            //hide the manual refresh button
            auto = true
            refreshIcon.hidden = true
            refreshButton.enabled = false
            refreshCountdown.hidden = false
            
            //start timer that will update the data every 10 seconds
            timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("getDataFromService"), userInfo: nil, repeats: true)
            
            subTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerCount"), userInfo: nil, repeats: true)
        }
        else {
            //show the refresh button and stop the timer
            auto = false
            refreshIcon.hidden = false
            refreshButton.enabled = true
            refreshCountdown.hidden = true
            timer.invalidate()
            subTimer.invalidate()
        }
    }
    
    /*
    *  This method controls the refresh counter value
    */
    func timerCount() {
        if (count >= 0) {
            count--
        }
        refreshCountdown.text = String(count)
    }
    
    /*
    *  This method gets the environment data from the webservice
    */
    func getDataFromService() {
        //counter stuff
        if (auto) {
            count = 10
            refreshCountdown.text = String(count)
            subTimer.invalidate()
            subTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerCount"), userInfo: nil, repeats: true)
        }
        
        //create url path to get APIs
        var urlPath: String = "http://192.168.0.100:5000/getModuleInfo?moduleID=" + moduleInfo.moduleId
        
        println(urlPath)
        
        //create request for webservice
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        session.configuration.timeoutIntervalForRequest = 30
        
        //execute the task
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
                    
                    //show an alert with the error details
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
                        //show the updated temp and humidity
                        self.temperatureLabel.text = mod.values[1]
                        self.humidityLabel.text = mod.values[0]
                    }
                }
            })
        })
        task.resume()
    }
    
    /*
    *  This method executes when the help (?) button is pressed
    */
    @IBAction func helpClicked(sender: UIButton) {
        //toggle the boolean value
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
    
    //setup a notification to check temp again after 10 minutes
    //http://www.ioscreator.com/tutorials/local-notification-tutorial-ios8-swift
    func sendNotification() {
        var module: ModuleInfo!
        //find environment module
        for i in 0...Storage.modulesInfo.count - 1 {
            var mod = Storage.modulesInfo[i]
            if mod.moduleId == self.moduleInfo.moduleId {
                module = mod
            }
        }
        
        var localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 20)//600)
        localNotification.alertBody = "Current temperature: " + module.values[1]
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
