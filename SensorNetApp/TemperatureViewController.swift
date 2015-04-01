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
    
    var moduleInfo = ModuleInfo()
    var pageTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.title = pageTitle
        nodeIdLabel.text = moduleInfo.Id
        moduleIdLabel.text = moduleInfo.moduleId
        sensorsLabel.text = moduleInfo.nodeStatus
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func refreshClicked(sender: UIButton) {
        refreshIcon.hidden = true
        loader.startAnimating()
        loader.hidden = false
        
        self.getDataFromService()
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
                    self.refreshIcon.hidden = false
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
            
            //this is so you can see the loady. Otherwise too fast
            sleep(3)
            
            //call main thread to do loady stuff
            dispatch_async(dispatch_get_main_queue(), {
                self.refreshIcon.hidden = false
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
