//
//  ModuleInfo.swift
//  SensorNetApp
//
//  Created by Brian Sage on 2015-03-28.
//  Copyright (c) 2015 Quinton and Brian. All rights reserved.
//

/* Title:       ModuleInfo.swift
 * Date:        March 28, 2015
 * Author:      Brian Sage and Quinton Black
 * Description: This file is a container class to store all of the information
 *              about an individual module in the system.
 */

import Foundation

class ModuleInfo {
    var querySuccess = false
    var moduleId = "-1"
    var Id = "-1"
    var nodeStatus = "-1"
    var name = ""
    var description = ""
    var moduleType = "-1"
    var icon = ""
    var updateInterval = "-1"
    var timestamp = "-1"
    var moduleStatus = "-1"
    var moduleFile = ""
    var commands = [String]()
    var dataLens = [String]()
    var values = [String]()
    var types = [String]()
    var status = [String]()
    var archiveData = []
    var criticalBounds = [[]]
    var warningBounds = [[]]
}
