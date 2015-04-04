//
//  ModuleStorage.swift
//  SensorNetApp
//
//  Created by Brian Sage on 2015-03-28.
//  Copyright (c) 2015 Quinton and Brian. All rights reserved.
//

/* Title:       ModuleStorage.swift
 * Date:        March 28, 2015
 * Author:      Brian Sage and Quinton Black
 * Description: This file has a singleton class that acts as a storage object.
 *              A list of modules and an associated list of module info is stored.
 *              When adding module information, it links the data to the appropriate module.
 */

import Foundation

struct Storage {
    
    //variables
    static var modules = [Module]()
    static var modulesInfo = [ModuleInfo]()
    
    //initialization for singleton class
    init() {
        
    }
    
    /*
    *  This method adds a module to the array if it does
    *  not already exist in the array. It then creates a
    *  placeholder for the module info.
    */
    static func addModule(module: Module) {
        //loop through existing modules to see if it already exists
        for mod in modules {
            if (mod.moduleId == module.moduleId && mod.nodeId == module.nodeId) {
                return
            }
        }
        
        //add new module
        modules.append(module)
        
        //create place holder in module info array
        var emptyItem = ModuleInfo()
        modulesInfo.append(emptyItem)
    }
    
    /*
    *  This method adds module info for a specified module.
    *  Search through the existing modules to match the info.
    */
    static func addModuleInfo(info: ModuleInfo) {
        //loop through modules
        for i in 0...modules.count - 1 {
            //if match found, set the info
            if (modules[i].moduleId == info.moduleId) {
                modulesInfo[i] = info
                return
            }
        }
    }
}