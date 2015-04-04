//
//  ModuleStatusEnum.swift
//  SensorNetApp
//
//  Created by Brian Sage on 2015-04-01.
//  Copyright (c) 2015 Quinton and Brian. All rights reserved.
//

/* Title:       ModuleStatusEnum.swift
* Date:        March 28, 2015
* Author:      Brian Sage and Quinton Black
* Description: This is an enum for the status of modules
*/

enum ModuleStatus: Int {
    case ALL_GOOD = 0, WARNING, CRITICAL, NO_COMM
    
    //returns a string representation of the ENUM value
    var toString : String {
        switch self {
            case .ALL_GOOD: return "All Good";
            case .WARNING: return "Warning";
            case .CRITICAL: return "Critical";
            case .NO_COMM: return "No Communication";
        }
    }
}
