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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup the loader
        loader.animationImages = [UIImage]()
        for var i = 1; i <= 8; i++ {
            var image = String(i)
            loader.animationImages?.append(UIImage(named: image)!)
        }
        loader.animationDuration = 1
        
        loader.startAnimating()
        loader.hidden = false
        
        self.getDataFromService("getModuleList", param: "")
        //DAL.getModuleList()
        //DAL.getModuleInfo() //will specifiy id later
    }
    
///////////////////////////////////////////////////////////
    
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
                    self.loader.stopAnimating()
                    self.loader.hidden = true
                    
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
            sleep(5)
            
            //call main thread to do loady stuff
            dispatch_async(dispatch_get_main_queue(), {
                self.loader.stopAnimating()
                self.loader.hidden = true
                
                //DELETE ME LATER
                let alert = UIAlertController(title: "Alert", message:
                    "Successfully retrieved data.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
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
