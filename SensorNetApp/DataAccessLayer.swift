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
    
    func getModuleData(success: ((data: NSData) -> Void)) {
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
        
        self.getModuleData { (data) -> Void in
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
            module.nodeId = mod.arrayValue[0].stringValue
            module.moduleId = mod.arrayValue[1].stringValue
            module.location = mod.arrayValue[2].stringValue
            module.icon = mod.arrayValue[3].stringValue
            
            Storage.addModule(module)
        }
    }
    
    func parseModuleInfo(json: JSON) {
        
        var moduleInfo = ModuleInfo()
        moduleInfo.querySuccess = json["querySuccess"].boolValue
        moduleInfo.moduleId = json["moduleID"].stringValue
        moduleInfo.Id = json["ID"].stringValue
        moduleInfo.nodeStatus = json["nodeStatus"].stringValue
        moduleInfo.name = json["name"].stringValue
        moduleInfo.description = json["description"].stringValue
        moduleInfo.moduleType = json["moduleType"].stringValue
        moduleInfo.icon = json["icon"].stringValue
        moduleInfo.updateInterval = json["updateInterval"].stringValue
        moduleInfo.timestamp = json["timestamp"].stringValue
        moduleInfo.moduleStatus = json["moduleStatus"].stringValue
        moduleInfo.moduleFile = json["moduleFile"].stringValue
        //var command = json["commands"][0].intValue
        //moduleInfo.commands.append(command)
        //var lens = json["dataLens"][0].intValue
        //moduleInfo.dataLens.append(lens)
        /*FIX THIS*/
        for i in 1...json["values"].arrayValue.count - 1 {
            var value = json["values"].arrayValue[i].stringValue
            moduleInfo.values.append(value)
        }
        //var type = json["types"][0].intValue
        //moduleInfo.types.append(type)
        //var status = json["status"][0].intValue
        //moduleInfo.status.append(status)
        
        Storage.addModuleInfo(moduleInfo)
    }
}