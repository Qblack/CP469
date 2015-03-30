//
//  ModuleStorage.swift
//  SensorNetApp
//
//  Created by Brian Sage on 2015-03-28.
//  Copyright (c) 2015 Quinton and Brian. All rights reserved.
//

import Foundation

struct Storage {
    static var modules = [Module]()
    static var modulesInfo = [ModuleInfo]()
    
    init() {
        
    }
    
    static func addModule(module: Module) {
        for mod in modules {
            if (mod.moduleId == module.moduleId && mod.nodeId == module.nodeId) {
                return
            }
        }
        modules.append(module)
        var emptyItem = ModuleInfo()
        modulesInfo.append(emptyItem)
    }
    
    static func addModuleInfo(info: ModuleInfo) {
        for i in 0...modules.count - 1 {
            if (modules[i].moduleId == info.moduleId) {
                modulesInfo[i] = info
                return
            }
        }
    }
}