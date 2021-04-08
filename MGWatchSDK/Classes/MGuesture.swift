//
//  MGesture.swift
//  MAD Gaze Watch Connector
//
//  Created by Sam Leung on 10/7/2020.
//  Copyright © 2020 Sam Leung. All rights reserved.
//

import Foundation

public struct MGesture: Hashable {

    public var gestureId: Int
    public var signal: UInt8
    public var gestureImage: String
    public var time: Int
    public var needTrain: Bool
    
    init(id: Int, signal: UInt8, time: Int, image: String, needTrain: Bool) {
        self.gestureId = id
        self.signal = signal
        self.time = time
        self.gestureImage = image
        self.needTrain = needTrain
    }
}

public class Gesture {
    static public let LEFT_OF_FOREARM_1 = MGesture(id: 1, signal: UInt8(1), time: 1, image: "", needTrain: true)
    static public let RIGHT_OF_FOREARM_1 = MGesture(id: 2, signal: UInt8(2), time: 1, image: "", needTrain: true)
    static public let UP_OF_HAND_BACK_1 = MGesture(id: 3, signal: UInt8(3), time: 1, image: "", needTrain: true)
    static public let DOWN_OF_HAND_BACK_1 = MGesture(id: 4, signal: UInt8(4), time: 1, image: "", needTrain: true)
    static public let LEFT_OF_HAND_BACK_1 = MGesture(id: 5, signal: UInt8(5), time: 1, image: "", needTrain: true)
    static public let RIGHT_OF_HAND_BACK_1 = MGesture(id: 6, signal: UInt8(6), time: 1, image: "", needTrain: true)
    static public let TAP_INDEX_MIDDLE_FINGER_1 = MGesture(id: 7, signal: UInt8(7), time: 1, image: "", needTrain: true)
    static public let SNAP_FINGER_1 = MGesture(id: 8, signal: UInt8(8), time: 1, image: "", needTrain: true)
    static public let LEFT_OF_FOREARM_2 = MGesture(id: 9, signal: UInt8(1), time: 2, image: "", needTrain: true)
    static public let RIGHT_OF_FOREARM_2 = MGesture(id: 10, signal: UInt8(2), time: 2, image: "", needTrain: true)
    static public let UP_OF_HAND_BACK_2 = MGesture(id: 11, signal: UInt8(3), time: 2, image: "", needTrain: true)
    static public let DOWN_OF_HAND_BACK_2 = MGesture(id: 12, signal: UInt8(4), time: 2, image: "", needTrain: true)
    static public let LEFT_OF_HAND_BACK_2 = MGesture(id: 13, signal: UInt8(5), time: 2, image: "", needTrain: true)
    static public let RIGHT_OF_HAND_BACK_2 = MGesture(id: 14, signal: UInt8(6), time: 2, image: "", needTrain: true)
    static public let TAP_INDEX_MIDDLE_FINGER_2 = MGesture(id: 15, signal: UInt8(7), time: 2, image: "", needTrain: true)
    static public let SNAP_FINGER_2 = MGesture(id: 16, signal: UInt8(8), time: 2, image: "", needTrain: true)
    static public let LEFT_OF_THUMB_1 = MGesture(id: 17, signal: UInt8(9), time: 1, image: "", needTrain: true)
    static public let RIGHT_OF_THUMB_1 = MGesture(id: 18, signal: UInt8(10), time: 1, image: "", needTrain: true)
    static public let LEFT_OF_INDEX_FINGER_1 = MGesture(id: 19, signal: UInt8(11), time: 1, image: "", needTrain: true)
    static public let RIGHT_OF_INDEX_FINGER_1 = MGesture(id: 20, signal: UInt8(12), time: 1, image: "", needTrain: true)
    static public let LEFT_OF_MIDDLE_FINGER_1 = MGesture(id: 21, signal: UInt8(13), time: 1, image: "", needTrain: true)
    static public let RIGHT_OF_MIDDLE_FINGER_1 = MGesture(id: 22, signal: UInt8(14), time: 1, image: "", needTrain: true)
    static public let LEFT_OF_RING_FINGER_1 = MGesture(id: 23, signal: UInt8(15), time: 1, image: "", needTrain: true)
    static public let RIGHT_OF_RING_FINGER_1 = MGesture(id: 24, signal: UInt8(16), time: 1, image: "", needTrain: true)
    static public let LITTLE_FINGER_1 = MGesture(id: 25, signal: UInt8(17), time: 1, image: "", needTrain: true)
    static public let TAP_INDEX_FINGER_1 = MGesture(id: 26, signal: UInt8(18), time: 1, image: "", needTrain: true)
    static public let TAP_MIDDLE_FINGER_1 = MGesture(id: 27, signal: UInt8(19), time: 1, image: "", needTrain: true)
    static public let TAP_INDEX_FINGER_2 = MGesture(id: 28, signal: UInt8(18), time: 2, image: "", needTrain: true)
    static public let TAP_MIDDLE_FINGER_2 = MGesture(id: 29, signal: UInt8(19), time: 2, image: "", needTrain: true)
    static public let MOVE_ARM_UP = MGesture(id: 30, signal: UInt8(100), time: 1, image: "", needTrain: true)
    static public let MOVE_ARM_DOWN = MGesture(id: 31, signal: UInt8(101), time: 1, image: "", needTrain: true)
    static public let MOVE_ARM_LEFT = MGesture(id: 32, signal: UInt8(102), time: 1, image: "", needTrain: true)
    static public let MOVE_ARM_RIGHT = MGesture(id: 33, signal: UInt8(103), time: 1, image: "", needTrain: true)
    
    static public let ALL = [LEFT_OF_FOREARM_1,RIGHT_OF_FOREARM_1,
    UP_OF_HAND_BACK_1,DOWN_OF_HAND_BACK_1,
    LEFT_OF_HAND_BACK_1,RIGHT_OF_HAND_BACK_1,
    TAP_INDEX_MIDDLE_FINGER_1,SNAP_FINGER_1,
    LEFT_OF_FOREARM_2,RIGHT_OF_FOREARM_2,
    UP_OF_HAND_BACK_2,DOWN_OF_HAND_BACK_2,
    LEFT_OF_HAND_BACK_2,RIGHT_OF_HAND_BACK_2,
    TAP_INDEX_MIDDLE_FINGER_2,
    SNAP_FINGER_2,
    LEFT_OF_THUMB_1,RIGHT_OF_THUMB_1,
    LEFT_OF_INDEX_FINGER_1,RIGHT_OF_INDEX_FINGER_1,
    LEFT_OF_MIDDLE_FINGER_1,RIGHT_OF_MIDDLE_FINGER_1,
    LEFT_OF_RING_FINGER_1,RIGHT_OF_RING_FINGER_1,
    LITTLE_FINGER_1,
    TAP_INDEX_FINGER_1,TAP_MIDDLE_FINGER_1,
    TAP_INDEX_FINGER_2,TAP_MIDDLE_FINGER_2,
    MOVE_ARM_UP,MOVE_ARM_DOWN,MOVE_ARM_LEFT,MOVE_ARM_RIGHT]
}
