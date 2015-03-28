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
    
    func parseModuleList(results: NSString) -> Array<Module> {
        let json = JSON(results)
        
        let moduleArray = json.arrayValue
        var modules = [Module]()
        
        for mod in moduleArray {
            var module = Module()
            module.nodeId = mod[0].stringValue.toInt()!
            module.moduleId = mod[1].stringValue.toInt()!
            module.location = mod[2].stringValue
            module.icon = mod[3].stringValue
            
            modules.append(module)
        }
        
        return modules
    }
    
    func parseModuleInfo(results: NSString) -> ModuleInfo {
        let json = JSON(results)
        
        var moduleInfo = ModuleInfo()
        moduleInfo.querySuccess = json["querySuccess"].stringValue.toInt()! == 0 ? false : true
        moduleInfo.moduleId = json["moduleId"].stringValue.toInt()!
        moduleInfo.Id = json["ID"].stringValue.toInt()!
        moduleInfo.nodeStatus = json["nodeStatus"].stringValue.toInt()!
        moduleInfo.name = json["name"].stringValue
        moduleInfo.description = json["description"].stringValue
        moduleInfo.moduleType = json["moduleType"].stringValue.toInt()!
        moduleInfo.icon = json["icon"].stringValue
        moduleInfo.updateInterval = json["updateInterval"].stringValue.toInt()!
        moduleInfo.timestamp = json["timestamp"].stringValue.toInt()!
        moduleInfo.moduleStatus = json["moduleStatus"].stringValue.toInt()!
        moduleInfo.moduleFile = json["moduleFile"].stringValue
        var command = json["commands"][0].stringValue.toInt()!
        moduleInfo.commands.append(command)
        var lens = json["dataLens"][0].stringValue.toInt()!
        moduleInfo.dataLens.append(lens)
        var value = json["values"][0].stringValue.toInt()!
        moduleInfo.values.append(value)
        var type = json["types"][0].stringValue.toInt()!
        moduleInfo.types.append(type)
        var status = json["status"][0].stringValue.toInt()!
        moduleInfo.status.append(status)
        
        return moduleInfo
    }
    
    func callGetAPI(method: String, param: String) {
        //create url path to get APIs
        var urlPath: String = "http://192.168.0.100:5000/" + method + "?"
        
        //for getModuleInfo
        if (method == "getModuleInfo") {
            currentGetMethod = "getModuleInfo"
            urlPath += "moduleID=" + param
        }
        else {
            currentGetMethod = "getModuleList"
        }

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
        
        if (currentGetMethod != "") {
            switch currentGetMethod {
                case "getModuleList":
                    parseModuleList(results!)
                case "getModuleInfo":
                    parseModuleInfo(results!)
                default:
                    var dumb = 1
            }
        }
    }
}