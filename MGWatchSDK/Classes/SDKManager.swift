//
//  SDKManager.swift
//  MGWatchSDK
//
//  Created by Sam Leung on 24/3/2021.
//

import Foundation

public class MGWatchSDKManager: NSObject {
    
    public static let shared = MGWatchSDKManager()
    public private(set) static var uuId: String {
        get {
            return BLEManager.shared.MADGAZE_SERVICE
        }
        
        set {
            BLEManager.shared.MADGAZE_SERVICE = newValue
        }
    }
    
    public var isGestureReady: Bool {
        get {
            return BLEManager.shared.isGesturesReady
        }
    }
    
    public var isDetectGesture: Bool {
        get {
            return BLEManager.shared.isDetectGesture
        }
    }
    
    public var requiredGesture: [MGesture] {
        get {
            return BLEManager.shared.requiredGesture
        }
    }
    
    private override init() {
        super.init()
    }
    
    public func setService(uuId: String) {
        MGWatchSDKManager.uuId = uuId
    }
    
    public func sdkRegister() {
        BLEManager.shared.SDKregister()
    }
    
    public func sdkUnregister() {
        BLEManager.shared.SDKUnregister()
    }
    
    public func addListener(listener: BLEManagerListener) {
        BLEManager.shared.addListener(listener: listener)
    }
    
    public func removeListener(listener: BLEManagerListener) {
        BLEManager.shared.removeListener(listener: listener)
    }
    
    public func requiredWatchGesture(gesture: [MGesture]) {
        BLEManager.shared.requiredWatchGesture(gesture: gesture)
    }
    
    public func trainRequiredGesture() {
        BLEManager.shared.trainRequiredGesture()
    }
    
    public func detectionCheck() {
        BLEManager.shared.detectionCheck()
    }
    
    public func detectionRequest(enable: Bool) {
        BLEManager.shared.detectionRequest(enable: enable)
    }
    
    public func checkIsConnected() -> Bool {
        BLEManager.shared.checkIsConnected()
    }
    
    public func connect() {
        BLEManager.shared.connectWatchRequest()
    }
}
