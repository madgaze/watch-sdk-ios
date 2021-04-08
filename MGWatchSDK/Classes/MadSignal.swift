//
//  MadSignal.swift
//  MAD Gaze Watch Connector
//
//  Created by Sam Leung on 17/6/2020.
//  Copyright © 2020 Sam Leung. All rights reserved.
//

import Foundation


public class MadSignal {

    static public let NORMAL_SIGNAL_DISCONNECT: Data = Data(bytes: [UInt8(99)], count: [UInt8(99)].count)
    static public let NORMAL_SIGNAL_BOND_CHECK: Data = Data(bytes: [UInt8(98)], count: [UInt8(98)].count)
    static public let NORMAL_SIGNAL_BOND_REQUEST: Data = Data(bytes: [UInt8(97)], count: [UInt8(97)].count)
    static public let NORMAL_SIGNAL_APPLE_SERVICE_CHECK: Data = Data(bytes: [UInt8(96)], count: [UInt8(96)].count)
    static public let NORMAL_SIGNAL_APPLE_SERVICE_REQUEST: Data = Data(bytes: [UInt8(94)], count: [UInt8(94)].count)
    static public let NORMAL_SIGNAL_CONNECT_GATT: Data = Data(bytes: [UInt8(95)], count: [UInt8(95)].count)
    static public let NORMAL_SIGNAL_APP_REGISTER_REQUEST: Data = Data(bytes: [UInt(93)], count: [UInt(93)].count)
    static public let NORMAL_SIGNAL_APP_UNREGISTER_REQUEST: Data = Data(bytes: [UInt(92)], count: [UInt(92)].count)
    
    static public let SDK_REQUIRED_GESTURE: Data = Data(bytes: [UInt8(31)], count: [UInt8(31)].count)
    static public let SDK_TRAIN_GESTURE_REQUEST: Data = Data(bytes: [UInt8(32)], count: [UInt8(32)].count)
    static public let SDK_GESTURE_DETECT_CHECK: Data = Data(bytes: [UInt8(33)], count: [UInt8(33)].count)
    static public let SDK_GESTURE_DETECT_REQUEST: Data = Data(bytes: [UInt(34)], count: [UInt(34)].count)
    
    static public func signalToString(signal: Data) -> String {
        switch signal {
        default:
            return ""
        }
    }
}
