//
//  DataAccessLayer.swift
//  SensorNetApp
//
//  Created by Brian Sage on 2015-03-28.
//  Copyright (c) 2015 Quinton and Brian. All rights reserved.
//

/* Title:       DataAccessLayer.swift
 * Date:        March 28, 2015
 * Author:      Brian Sage and Quinton Black
 * Description: This file contians is a singleton and contains test methods 
 *              that will retrieve test JSON data from files
 *              just in case the network connection isn't working properly.
 *              It also contains methods that will parse out the retrieved JSON data into
 *              modules and thier specific data.
 */

import Foundation

struct DataAccessLayer {
    
    //variables
    static var currentGetMethod = ""
    static var dataStore = NSMutableData()
    
    //initialization for singleton
    init() {
        
    }
    
    /*
    Accessing JSON from a file:
    https://gist.github.com/Tulkas/9f69784b37440c907e96
    */
    //Gets the module info from a json file for testing purposes
    static func getModuleData(success: ((data: NSData) -> Void)) {
        let filePath = NSBundle.mainBundle().pathForResource("ModInfo",ofType:"json")
        
        var readError:NSError?
        if let data = NSData(contentsOfFile:filePath!,
            options: NSDataReadingOptions.DataReadingUncached,
            error:&readError) {
                success(data: data)
        }
    }
    
    //Gets the module list from a json file for testing purposes
    static func getModules(success: ((data: NSData) -> Void)) {
        let filePath = NSBundle.mainBundle().pathForResource("Mods",ofType:"json")
        
        var readError:NSError?
        if let data = NSData(contentsOfFile:filePath!,
            options: NSDataReadingOptions.DataReadingUncached,
            error:&readError) {
                success(data: data)
        }
    }   
    
    //Also used for getting module list from json file
    static func getModuleList(){
        var module = Module()
        
        self.getModules { (data) -> Void in
            let json = JSON(data: data)
            println(json)
            self.parseModuleList(json)
        }
    }
    
    //Also used for getting module info from json file
    static func getModuleInfo() {
        var moduleInfo = ModuleInfo()
        
        self.getModuleData { (data) -> Void in
            let json = JSON(data: data)
            println(json)
            self.parseModuleInfo(json)
        }
    }
    
    /*
     *  This method parses valid JSON data into a list of modules
     *  that is stored for later use.
     */
    static func parseModuleList(json: JSON) {
        //get the array from the json
        let moduleArray = json.arrayValue
        var modules = [Module]()
        
        //iterate through modules and get their base data
        for mod in moduleArray {
            var module = Module()
            module.nodeId = mod.arrayValue[0].stringValue
            module.moduleId = mod.arrayValue[1].stringValue
            module.location = mod.arrayValue[2].stringValue
            module.name = mod.arrayValue[3].stringValue
            module.icon = mod.arrayValue[4].stringValue
            
            //store the module
            Storage.addModule(module)
        }
    }
    
    /*
    *  This method parses valid JSON data into a module's
    *  specific information that is stored for later use.
    */
    static func parseModuleInfo(json: JSON) {
        //retrieve all the module's info
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
        for i in 0...json["values"].arrayValue.count - 1 {
            var value = json["values"].arrayValue[i].stringValue
            moduleInfo.values.append(value)
        }
        //THESE PIECES AREN'T NEEDED AT THIS TIME
        //var command = json["commands"][0].intValue
        //moduleInfo.commands.append(command)
        //var lens = json["dataLens"][0].intValue
        //moduleInfo.dataLens.append(lens)
        //var type = json["types"][0].intValue
        //moduleInfo.types.append(type)
        //var status = json["status"][0].intValue
        //moduleInfo.status.append(status)
        
        //store the module info
        Storage.addModuleInfo(moduleInfo)
    }
}