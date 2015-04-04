//
//  RootTableViewController.swift
//  SensorNetApp
//
//  Created by Quinton Black on 2015-03-30.
//  Copyright (c) 2015 Quinton and Brian. All rights reserved.
//

/* Title:       RootTableViewController.swift
 * Date:        March 28, 2015
 * Author:      Brian Sage and Quinton Black
 * Description: This is the view controller for the main table view screen.
 *              It goes out and gets a list of modules and their information,
 *              stores it in the storage class, and displays each module available
 *              in the table view. When you select a module, you will be segued to 
 *              that module's screen.
 */

import UIKit

class RootTableViewController: UITableViewController, UITableViewDelegate {
    
    //variables
    var levelCount = 0
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize storage
        var storage = Storage()
        
        //initialize DAL
        var dal = DataAccessLayer()
        
        //create gradient background
        //gradients: http://www.reddit.com/r/swift/comments/27mrlx/gradient_background_of_uiview_in_swift/
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        let cor1 = UIColor(white: 0.1, alpha: 0.98).CGColor
        let cor2 = UIColor(white: 0.5, alpha: 0.98).CGColor
        let arrayColors = [cor1, cor2]
        gradient.colors = arrayColors
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        //create loader animation for when retrieving data from service
        activityIndicator.frame = self.view.bounds
        activityIndicator.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        activityIndicator.startAnimating()
        self.view.addSubview( activityIndicator )
        
        //get modules from webservice
        self.getDataFromService("getModuleList", param: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return Storage.modules.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //create new cell
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        //get the module for this row
        var module = Storage.modules[indexPath.row]
        
        //create nice font text for the cell
        let text = module.name
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        let textColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        let attributes = [
            NSForegroundColorAttributeName : textColor,
            NSFontAttributeName : font,
            NSTextEffectAttributeName : NSTextEffectLetterpressStyle
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        
        //set the cell to have transparent background and fancy text
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.attributedText = attributedString
        
        return cell
    }
    
    /*
    *  This method is used for manual segue control
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let moduleInfo = Storage.modulesInfo[indexPath.row]
//        if (moduleInfo.moduleType == String(ModuleType.RGB.rawValue)){
//            self.performSegueWithIdentifier("rgb", sender:tableView.cellForRowAtIndexPath(indexPath))
//        }
//        else if(moduleInfo.moduleType == String(ModuleType.LIGHT.rawValue)){
//            self.performSegueWithIdentifier("light", sender:tableView.cellForRowAtIndexPath(indexPath))
//        }
//        else if(moduleInfo.moduleType == String(ModuleType.ENVIRONMENT.rawValue)){
//            self.performSegueWithIdentifier("environment", sender:tableView.cellForRowAtIndexPath(indexPath))
//        }
        
        //just in case we cant change the module type use the moduleId instead
        switch (moduleInfo.moduleId) {
        case "858050250518":
            self.performSegueWithIdentifier("environment", sender:tableView.cellForRowAtIndexPath(indexPath))
        case "870985681430":
            self.performSegueWithIdentifier("rgb", sender:tableView.cellForRowAtIndexPath(indexPath))
            
        case "918415594774":
            self.performSegueWithIdentifier("light", sender:tableView.cellForRowAtIndexPath(indexPath))
        default:
            var dumb = 1
        }
    }

    /*
    *  This method gets the environment data from the webservice
    */
    func getDataFromService(method: String, param: String) {
        
        //create url path to get APIs
        var urlPath: String = "http://192.168.0.100:5000/" + method
        
        //for getModuleInfo
        if (method == "getModuleInfo") {
            urlPath += "?moduleID=" + param
        }
        
        println(urlPath)
        
        //create http request
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        session.configuration.timeoutIntervalForRequest = 30
        
        //execute task
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            
            //check for errors
            if error != nil {
                println(error)
                //call main thread to do loady stuff
                dispatch_async(dispatch_get_main_queue(), {
                    //display an alert with the error details
                    let alert = UIAlertController(title: "Error", message:
                        error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                return
            }
            
            //call to parse the JSON
            let json = JSON(data:data)
            switch method {
            case "getModuleList":
                //parse the module list
                DataAccessLayer.parseModuleList(json)
                
                //for each module, call webservice to get it's information
                for mod in 0...Storage.modules.count - 1 {
                    self.levelCount++
                    let modId = Storage.modules[mod].moduleId
                    self.getDataFromService("getModuleInfo", param: modId)
                }
            case "getModuleInfo":
                //parse the module info
                self.levelCount--
                DataAccessLayer.parseModuleInfo(json)
            default:
                var dumb = 1
            }
            
            //this is for recursion control
            if (self.levelCount == 0) {
                //call main thread to do loady stuff
                dispatch_async(dispatch_get_main_queue(), {
                    //stop loader animation and reload the table data
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                })
            }
        })
        task.resume()
    }


    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let indexPath = tableView.indexPathForCell(sender as UITableViewCell)!
        let moduleInfo = Storage.modulesInfo[indexPath.row]
        
        if (segue.identifier == "rgb") {
            let destinationVC = segue.destinationViewController as RGBViewController;
            destinationVC.pageTitle = "RGB Light"
            destinationVC.moduleInfo = moduleInfo
        }
        else if(segue.identifier == "light") {
            let destinationVC = segue.destinationViewController as SwitchViewController;
            destinationVC.pageTitle = "Main Light"
            destinationVC.moduleInfo = moduleInfo
        }
        else if(segue.identifier == "environment") {
            let destinationVC = segue.destinationViewController as TemperatureViewController;
            destinationVC.pageTitle = "Environment"
            destinationVC.moduleInfo = moduleInfo
        }
    }
}
