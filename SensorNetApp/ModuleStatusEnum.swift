//
//  ModuleStatusEnum.swift
//  SensorNetApp
//
//  Created by Brian Sage on 2015-04-01.
//  Copyright (c) 2015 Quinton and Brian. All rights reserved.
//

enum ModuleStatus: Int {
    case ALL_GOOD = 0, WARNING, CRITICAL, NO_COMM
    
    var toString : String {
        switch self {
            // Use Internationalization, as appropriate.
            case .ALL_GOOD: return "All Good";
            case .WARNING: return "Warning";
            case .CRITICAL: return "Critical";
            case .NO_COMM: return "No Communication";
        }
    }
}
