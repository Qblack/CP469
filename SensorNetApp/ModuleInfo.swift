//
//  ModuleInfo.swift
//  Final
//
//  Created by Brian Sage on 2015-03-28.
//  Copyright (c) 2015 Brian Sage. All rights reserved.
//

import Foundation

class ModuleInfo {
    var querySuccess = false
    var moduleId = -1
    var Id = -1
    var nodeStatus = -1
    var name = ""
    var description = ""
    var moduleType = -1
    var icon = ""
    var updateInterval = -1
    var timestamp = -1
    var moduleStatus = -1
    var moduleFile = ""
    var commands = [Int]()
    var dataLens = [Int]()
    var values = [Int]()
    var types = [Int]()
    var status = [Int]()
    var archiveData = []
    var criticalBounds = [[]]
    var warningBounds = [[]]
}
