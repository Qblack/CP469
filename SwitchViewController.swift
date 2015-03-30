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
    
    let DAL = DataAccessLayer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup the loader
        loader.animationImages = [UIImage]()
        for var i = 1; i <= 8; i++ {
            var image = String(i)
            loader.animationImages?.append(UIImage(named: image)!)
        }
        loader.animationDuration = 1
        
        //initialize storage
        var storage = Storage();
        
        loader.hidden = false
        
        self.tester("getModuleList", param: "")
        //DAL.getModuleList()
        //DAL.getModuleInfo() //will specifiy id later
    }
    
///////////////////////////////////////////////////////////
    
    func tester(method: String, param: String) {
        loader.startAnimating()
        
        //create url path to get APIs
        var urlPath: String = "http://192.168.0.100:5000/" + method
        
        //for getModuleInfo
        if (method == "getModuleInfo") {
            urlPath += "?moduleID=" + param
        }
        
        println(urlPath)
        
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        session.configuration.timeoutIntervalForRequest = 10
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            
            //check for errors
            if error != nil {
                println(error.localizedDescription)
                //call main thread to do loady stuff
                dispatch_async(dispatch_get_main_queue(), {
                    self.loader.stopAnimating()
                    self.loader.hidden = true
                    
                    let alert = UIAlertController(title: "Error", message:
                        error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                return
            }
            
            //check for valid JSON
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if err != nil {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            
            //call to parse the JSON
            let json = JSON(jsonResult)
            switch method {
            case "getModuleList":
                self.DAL.parseModuleList(json)
            case "getModuleInfo":
                self.DAL.parseModuleInfo(json)
            default:
                var dumb = 1
            }
            
            //call main thread to do loady stuff
            dispatch_async(dispatch_get_main_queue(), {
                self.loader.stopAnimating()
            })
            
        })
        task.resume()
    }
////////////////////////////////////////////////////////////

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
