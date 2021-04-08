//
//  MTraining.swift
//  MAD Gaze Watch Connector
//
//  Created by Sam Leung on 8/7/2020.
//  Copyright © 2020 Sam Leung. All rights reserved.
//

import Foundation

public class MTraining {
    var trainingId: Int
    var gesture: [MGesture]
    var time: Int
    var mode: Int
    
    init(id: Int, gesture: [MGesture], mode: Int = 0, time: Int = 0) {
        self.trainingId = id
        self.gesture = gesture
        self.mode = mode
        self.time = time
    }
}

class Training {
//    static var FIRST_TIME = MTraining(id: 1, gesture: [Gesture.LEFT_OF_FOREARM_1(1),
//    Gesture.RIGHT_OF_FOREARM_1(2),
//    Gesture.UP_OF_HAND_BACK_1(8),
//    Gesture.DOWN_OF_HAND_BACK_1(9),
//    Gesture.LEFT_OF_HAND_BACK_1(10),
//    Gesture.RIGHT_OF_HAND_BACK_1(11),
//    Gesture.TAP_INDEX_MIDDLE_FINGER_1(19),
//    Gesture.SNAP_FINGER_1(20)])
    
//    static var FIRST_TIME = MTraining(id: 1, gesture: [Gesture.LEFT_OF_FOREARM_1(1),
//    Gesture.RIGHT_OF_FOREARM_1(2)])
    
}
