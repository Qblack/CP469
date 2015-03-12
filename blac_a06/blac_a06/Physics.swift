//
//  Physics.swift
//  blac_a06
//
//  Created by Quinton Black on 2015-03-11.
//  Copyright (c) 2015 Quinton Black. All rights reserved.
//

import Foundation
import UIKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Player    : UInt32 = 0b1       // 1
    static let Monster   : UInt32 = 0b10       // 2
    static let Thwomp    : UInt32 = 0b100      // 4
    static let Projectile: UInt32 = 0b1000      // 8
    static let Ground    : UInt32 = 0b10000     // 16
}
