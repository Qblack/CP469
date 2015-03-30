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
}