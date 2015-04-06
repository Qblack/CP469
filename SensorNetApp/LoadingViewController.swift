//
//  LoadingViewController.swift
//  SensorNetApp
//
//  Created by Quinton Black on 2015-04-06.
//  Copyright (c) 2015 Quinton and Brian. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    var levelCount = 0


    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.animationImages = [UIImage]()
        for var i = 1; i <= 20; i++ {
            var img = "l" + String(i)
            image.animationImages?.append(UIImage(named: img)!)
        }
        image.animationDuration = 1
        image.startAnimating()
        
        self.getDataFromService("getModuleList", param: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
                    self.image.stopAnimating()
                    println("Done")
                    self.performSegueWithIdentifier("modules", sender:self)
                    

                    
                })
            }
        })
        task.resume()
    }

}
