//
//  RootTableViewController.swift
//  SensorNetApp
//
//  Created by Quinton Black on 2015-03-30.
//  Copyright (c) 2015 Quinton and Brian. All rights reserved.
//

import UIKit

class RootTableViewController: UITableViewController, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize storage
        var storage = Storage()
        
        //initialize DAL
        var dal = DataAccessLayer()
        
        self.getDataFromService("getModuleList", param: "")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        var module = Storage.modules[indexPath.row]
        cell.textLabel?.text = module.name
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    func getDataFromService(method: String, param: String) {
        
        //create url path to get APIs
        var urlPath: String = "http://192.168.0.100:5000/" + method
        
        //for getModuleInfo
        if (method == "getModuleInfo") {
            urlPath += "?moduleID=" + param
        }
        
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
                DataAccessLayer.parseModuleList(json)
            case "getModuleInfo":
                DataAccessLayer.parseModuleInfo(json)
                return
            default:
                var dumb = 1
            }
            
            //this is so you can see the loady. Otherwise too fast
            
            //call main thread to do loady stuff
            dispatch_async(dispatch_get_main_queue(), {
              
                //DELETE ME LATER
                let alert = UIAlertController(title: "Alert", message:
                    "Successfully retrieved data.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))


                self.presentViewController(alert, animated: true, completion: nil)
                self.tableView.reloadData()

            })
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
        
        
        
        if (segue.identifier == "rgbSegue"){
            let destinationVC = segue.destinationViewController as RGBViewController;
        }else if(segue.identifier=="switchSegue"){
            let destinationVC = segue.destinationViewController as SwitchViewController;
        }else if(segue.identifier == "temperatureSegue"){
            let destinationVC = segue.destinationViewController as TemperatureViewController;
        }
    }

}
