//
//  BLEManagerListener.swift
//  ShareBluetooth
//
//  Created by Sam Leung on 24/2/2021.
//

import Foundation
import CoreBluetooth

public protocol BLEManagerListener {
    func onBluetoothStateChanged(state: Bool)
    func onServiceIsReady(ready: Bool)
    func onWatchConnected()
    func onWatchDisconnected()
    func onWatchDetectionStateChanged(enable: Bool)
    func onGesturesIsReady(ready: Bool)
    func onWatchGestureReceived(gesture: MGesture)
}

public protocol BLECharacteristicListener {
    func onWatchGestureReceived()
}


