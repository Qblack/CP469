//
//  DataAccessLayer.swift
//  SensorNetApp
//
//  Created by Brian Sage on 2015-03-28.
//  Copyright (c) 2015 Quinton and Brian. All rights reserved.
//

import Foundation

class DataAccessLayer {
    
    var currentGetMethod = ""
    var dataStore = NSMutableData()
    
    func getModuleInfo(success: ((data: NSData) -> Void)) {
        //1
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //2
            let filePath = NSBundle.mainBundle().pathForResource("ModInfo",ofType:"json")
            
            var readError:NSError?
            if let data = NSData(contentsOfFile:filePath!,
                options: NSDataReadingOptions.DataReadingUncached,
                error:&readError) {
                    success(data: data)
            }
        //})
    }
    
    func getModules(success: ((data: NSData) -> Void)) {
        //1
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //2
            let filePath = NSBundle.mainBundle().pathForResource("Mods",ofType:"json")
            
            var readError:NSError?
            if let data = NSData(contentsOfFile:filePath!,
                options: NSDataReadingOptions.DataReadingUncached,
                error:&readError) {
                    success(data: data)
            }
        //})
    }

    
    func tester(res: NSData) {
        let urlPath = "http://api.topcoder.com/v2/challenges?pageSize=2"
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(res, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if err != nil {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            
            let json = JSON(jsonResult)
            let count: Int? = json["data"].array?.count
            println("found \(count!) challenges")
            
            if let ct = count {
                for index in 0...ct-1 {
                    // println(json["data"][index]["challengeName"].string!)
                    if let name = json["data"][index]["challengeName"].string {
                        println(name)
                    }
                    
                }
            }
        })
        task.resume()
    }
    
    func getModuleList(){
        var module = Module()
        
        self.getModules { (data) -> Void in
            // Get #1 app name using SwiftyJSON
            let json = JSON(data: data)
            println(json)
            self.parseModuleList(json)
        }
    }
    
    func getModuleInfo() {
        var moduleInfo = ModuleInfo()
        
        self.getModuleInfo { (data) -> Void in
            // Get #1 app name using SwiftyJSON
            let json = JSON(data: data)
            println(json)
            self.parseModuleInfo(json)
        }
    }
    
    func parseModuleList(json: JSON) {
        let moduleArray = json.arrayValue
        var modules = [Module]()
        
        for mod in moduleArray {
            var module = Module()
            module.nodeId = mod[0].intValue
            module.moduleId = mod[1].intValue
            module.location = mod[2].stringValue
            module.icon = mod[3].stringValue
            
            Storage.addModule(module)
        }
    }
    
    func parseModuleInfo(json: JSON) {
        var moduleInfo = ModuleInfo()
        moduleInfo.querySuccess = json["querySuccess"].boolValue
        moduleInfo.moduleId = json["moduleID"].intValue
        moduleInfo.Id = json["ID"].intValue
        moduleInfo.nodeStatus = json["nodeStatus"].intValue
        moduleInfo.name = json["name"].stringValue
        moduleInfo.description = json["description"].stringValue
        moduleInfo.moduleType = json["moduleType"].intValue
        moduleInfo.icon = json["icon"].stringValue
        moduleInfo.updateInterval = json["updateInterval"].intValue
        moduleInfo.timestamp = json["timestamp"].intValue
        moduleInfo.moduleStatus = json["moduleStatus"].intValue
        moduleInfo.moduleFile = json["moduleFile"].stringValue
        var command = json["commands"][0].intValue
        moduleInfo.commands.append(command)
        var lens = json["dataLens"][0].intValue
        moduleInfo.dataLens.append(lens)
        var value = json["values"][0].intValue
        moduleInfo.values.append(value)
        var type = json["types"][0].intValue
        moduleInfo.types.append(type)
        var status = json["status"][0].intValue
        moduleInfo.status.append(status)
        
        Storage.addModuleInfo(moduleInfo)
    }
    
    func callGetAPI(method: String, param: String) {
        //create url path to get APIs
        var urlPath: String = "http://192.168.0.100:5000/" + method
        
        //for getModuleInfo
        if (method == "getModuleInfo") {
            currentGetMethod = "getModuleInfo"
            urlPath += "?moduleID=" + param
        }
        else {
            currentGetMethod = "getModuleList"
        }
        
        println(urlPath)

        var url: NSURL = NSURL(string: urlPath)!
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)!
        connection.start()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        self.dataStore.appendData(data)
    }
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        println("Connection failed. \(error.localizedDescription) \n")
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        var results = NSString(data: dataStore, encoding: NSUTF8StringEncoding)
        println(results!)
        
        if (currentGetMethod != "") {
            //switch currentGetMethod {
                //case "getModuleList":
                    //parseModuleList(results!)
                //case "getModuleInfo":
                    //parseModuleInfo(results!)
                //default:
                    //var dumb = 1
            //}
        }
    }
}