//
//  BLEManager.swift
//  ShareBluetooth
//
//  Created by Sam Leung on 24/2/2021.
//

import Foundation
import Swift_EventBus
import CoreBluetooth

class BLEManager: NSObject {

    static public let shared = BLEManager()
    private let TAG = "BLEManager ->"
    private let eventBus = EventBus()
    private var manager: CBPeripheralManager!
    var bluetoothState: CBManagerState {
        get {
            return manager.state
        }
    }
    
    private var restoreServices: [CBMutableService] = []
    private(set) var currentService: CBMutableService? {
        didSet {
            if currentService == nil {
                sdkCharacteristic = nil
            }
            self.eventBus.notify(BLEManagerListener.self) { (listener) in
                DispatchQueue.main.async { [self] in
                    listener.onServiceIsReady(ready: currentService != nil)
                }
            }
        }
    }
    var deviceSerialNo: String?
    private(set) var connectedCentral: CBCentral? {
        didSet {
            print("\(TAG) connectedCentral didSet: \(connectedCentral?.identifier.uuidString ?? "Nil")")
            
            if connectedCentral == nil {
                //when disconnect
            }
        }
    }
    private(set) var isDetectGesture = false {
        didSet {
            print("\(TAG) isDetectGesture = \(isDetectGesture)")
            self.eventBus.notify(BLEManagerListener.self) { (listener) in
                DispatchQueue.main.async { [self] in
                    listener.onWatchDetectionStateChanged(enable: isDetectGesture)
                }
            }
        }
    }
    private(set) var requiredGesture: [MGesture] = []
    private var untrained: [MGesture] = [] {
        didSet {
            print("\(TAG) untrained: \(untrained.count)")
            isGesturesReady = (untrained.count == 0)
        }
    }
    private(set) var isGesturesReady: Bool = true {
        didSet {
            print("\(TAG) isGesturesReady = \(isGesturesReady)")
            self.eventBus.notify(BLEManagerListener.self) { (listener) in
                DispatchQueue.main.async { [self] in
                    listener.onGesturesIsReady(ready: isGesturesReady)
                }
            }
        }
    }
    private(set) var sdkCharacteristic: CBMutableCharacteristic?
    
    var MADGAZE_SERVICE: String  {
        get {
            UserDefaults.standard.string(forKey: USERDEFATUL_UUID) ?? ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: USERDEFATUL_UUID)
        }
    } //watch device service UUID
    var MADGAZE_IOS_CHARACTERISTIC = "00000004-57B1-4A8A-B8DF-0E56F7CA5131"
    
    var USERDEFATUL_UUID = "MadGaze Watch uuId"

    private var responseTimer: Timer?
    
    private override init() {
        super.init()
        manager = CBPeripheralManager.init(delegate: self, queue: nil, options: [CBPeripheralManagerOptionRestoreIdentifierKey: "MG Watch"])
    }
    
    func addListener(listener: BLEManagerListener) {
        self.eventBus.add(subscriber: listener, for: BLEManagerListener.self)
    }
    
    func removeListener(listener: BLEManagerListener) {
        self.eventBus.remove(subscriber: listener, for: BLEManagerListener.self)
    }
    
    func addCharacteristicListener(listener: BLECharacteristicListener) {
        self.eventBus.add(subscriber: listener, for: BLECharacteristicListener.self)
    }
    
    func removeListener(listener: BLECharacteristicListener) {
        self.eventBus.remove(subscriber: listener, for: BLECharacteristicListener.self)
    }
    
    
    func sendSignalToWatch(cmd: Data, signal: Data, characteristic: CBMutableCharacteristic?) {
        guard let char = characteristic else {
            return
        }
        var data = Data()
        data.append(cmd)
        data.append(signal)
        manager.updateValue(data, for: char, onSubscribedCentrals: char.subscribedCentrals)
    }
    
    func checkIsConnected() -> Bool {
        guard let characteristic = sdkCharacteristic else {
            return false
        }
        
        if (characteristic.subscribedCentrals?.count ?? 0 > 0){
            if characteristic.subscribedCentrals![0] != connectedCentral {
                connectedCentral = characteristic.subscribedCentrals![0]
            }
        }
        return characteristic.subscribedCentrals?.count ?? 0 > 0
    }
    
    func connectWatchRequest() {
        UIApplication.shared.open(URL(string: "mgwatch://sdk")!)
    }
    
    func SDKregister() {
        UIApplication.shared.open(URL(string: "mgwatch://sdk?uuId=\(MGWatchSDKManager.uuId)&request=\(Int(MadSignal.NORMAL_SIGNAL_APP_REGISTER_REQUEST[0]))")!)
    }
    
    func SDKUnregister() {
        UIApplication.shared.open(URL(string: "mgwatch://sdk?uuId=\(MGWatchSDKManager.uuId)&request=\(Int(MadSignal.NORMAL_SIGNAL_APP_UNREGISTER_REQUEST[0]))")!)
    }

    func createService(uuId: String) {
        reset()
        MADGAZE_SERVICE = uuId
        
        createService()
    }
    
    func reset() {
        print("\(TAG) reset")
        manager.removeAllServices()
        currentService = nil
        restoreServices = []
    }
    
    private func recoverService() -> Bool {
        var tempService: CBMutableService?
        if restoreServices.count == 1 {
            if restoreServices[0].uuid.uuidString.lowercased() == MADGAZE_SERVICE.lowercased() {
                tempService = restoreServices[0]
            }else{
                manager.remove(restoreServices[0])
            }
        }else{
            for service in restoreServices {
                if service.uuid.uuidString.lowercased() == MADGAZE_SERVICE.lowercased() {
                    if ((service.characteristics ?? []) as! [CBMutableCharacteristic]).contains(where: { (characteristic) -> Bool in
                        return characteristic.subscribedCentrals?.count ?? 0 > 0
                    }) {
                        if tempService == nil {
                            tempService = service
                        }else{
                            manager.remove(service)
                        }
                    }else{
                        manager.remove(service)
                    }
                }else{
                    manager.remove(service)
                }
            }
        }
        
        guard let foundService = tempService else {
            print("can not found Service")
            return false
        }
        
        let tempSDK = (foundService.characteristics ?? []).first { (characteristic) -> Bool in
            return characteristic.uuid == CBUUID(string: MADGAZE_IOS_CHARACTERISTIC)
        }
        
        if tempSDK != nil {
            sdkCharacteristic = tempSDK as? CBMutableCharacteristic
            //檢查係咪已經連左線
            if checkIsConnected() {
                print("found already connected device")
                self.eventBus.notify(BLEManagerListener.self) { (listener) in
                    DispatchQueue.main.async {
//                        listener.onSubcribeChanged(sub: true)
                        listener.onWatchConnected()
                    }
                }
            }else{
                print("found Service")
            }
            currentService = foundService
            return true
        }else{
            print("need update service")
            reset()
            return false
        }
    }
    
    private func createService() {
        sdkCharacteristic = CBMutableCharacteristic.init(type: CBUUID(string: MADGAZE_IOS_CHARACTERISTIC), properties: [.read, .write, .notify], value: nil, permissions: [.readable, .writeable])
        
        let service = CBMutableService.init(type: CBUUID(string: MADGAZE_SERVICE), primary: true)
        service.characteristics = [sdkCharacteristic!]
        manager.add(service)
    }
    
    func requiredWatchGesture(gesture: [MGesture]) {
        requiredGesture = gesture
        isGesturesTrained()
    }
    
    func trainRequiredGesture() {
        var curl = URLComponents(string: "mgwatch://sdk?request=\(Int(MadSignal.SDK_TRAIN_GESTURE_REQUEST[0]))")!
        let queryItems = untrained.map { URLQueryItem(name: "signal", value: "\($0.signal)") }
        curl.queryItems?.append(contentsOf: queryItems)
        UIApplication.shared.open(curl.url!)
    }
    
    func detectionCheck() {
        sendSignalToWatch(cmd: MadSignal.SDK_GESTURE_DETECT_CHECK, signal: Data(), characteristic: sdkCharacteristic)
    }
    
    func detectionRequest(enable: Bool) {
        sendSignalToWatch(cmd: MadSignal.SDK_GESTURE_DETECT_REQUEST, signal: Data(bytes: [UInt((enable) ? 1 : 0)], count: 1), characteristic: sdkCharacteristic)
    }
    
    private func isGesturesTrained() {
        var data = Data()
        requiredGesture.forEach { (f) in
            data.append(UInt8(f.gestureId))
        }
        
        var result: [Data] = []
        let maxMTU = connectedCentral?.maximumUpdateValueLength ?? 20 - 2
        let parts = Int(ceil(Double(data.count) / Double(maxMTU)))
        
        for i in 0..<parts {
            var final = Data()
            let start = maxMTU * i
            let end   = ((maxMTU + (maxMTU * i)) > data.count) ? data.count : (maxMTU + (maxMTU * i))
            
            final.append(MadSignal.SDK_REQUIRED_GESTURE)
            final.append(Data(bytes: [UInt8(parts - i - 1)], count: 1))
            final.append(data.subdata(in: start..<end))
            result.append(final)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) { [self] in
                sendSignalToWatch(cmd: final, signal: Data(), characteristic: sdkCharacteristic)
            }
        }
    }
    
    private func onSDKCharacteristicReceivedData(data: Data) {
        switch Int(data[0]) {
        case Int(MadSignal.SDK_REQUIRED_GESTURE[0]):
            var unTrainedSignal = Data()
            var unTrainedGesture: [MGesture] = []
            if data.count > 1 {
                unTrainedSignal.append(data.subdata(in: 1..<data.count))
            }
            unTrainedSignal.forEach { (signal) in
                unTrainedGesture.append(contentsOf: requiredGesture.filter({ $0.signal == signal}))
            }
            untrained = unTrainedGesture
        case Int(MadSignal.SDK_GESTURE_DETECT_CHECK[0]):
            let result = Int(data[1])
            isDetectGesture = (result == 1)
        default:
            if data.count == 3 {
//                let mode = Int(data[0])
                let gestureSignal = Int(data[1])
                let count = Int(data[2])
                if let gesture = Gesture.ALL.first(where: { (g) -> Bool in
                    let s = Int(g.signal) == gestureSignal
                    let c = g.time == count
                    return s && c
                }) {
                    self.eventBus.notify(BLEManagerListener.self) { (listener) in
                        DispatchQueue.main.async {
                            listener.onWatchGestureReceived(gesture: gesture)
                        }
                    }
                }
            }
            break
        }
    }
}

extension BLEManager: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state != .poweredOn {
            //can not turn on bluetooth
            self.eventBus.notify(BLEManagerListener.self) { (listener) in
                DispatchQueue.main.async {
                    listener.onBluetoothStateChanged(state: false)
                }
            }
            return
        }

        self.eventBus.notify(BLEManagerListener.self) { (listener) in
            DispatchQueue.main.async {
                listener.onBluetoothStateChanged(state: true)
            }
        }

        if recoverService() {
            
        }else{
            if !MADGAZE_SERVICE.isEmpty {
                createService()
            }else{
                self.eventBus.notify(BLEManagerListener.self) { (listner) in
                    DispatchQueue.main.async {
                        listner.onServiceIsReady(ready: false)
                    }
                }
            }
        }

    }

    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("\(TAG) didStartAdvertising")
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        print("\(TAG) didAdd Service")
        currentService = service as? CBMutableService
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {
        if (dict.keys.contains("kCBRestoredServices")) {
            print("\(TAG) willRestoreState: \(dict)")
            restoreServices = dict["kCBRestoredServices"] as! [CBMutableService]
        }
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        //only check normalSignalCharacteristic
        switch characteristic.uuid {
        case sdkCharacteristic?.uuid:
            print("\(TAG) didSubscribeTo sdkCharacteristic")
        default:
            print("\(TAG) didSubscribeTo unknow")
        }


        if characteristic.uuid == sdkCharacteristic?.uuid {
            connectedCentral = central
            self.eventBus.notify(BLEManagerListener.self) { (listener) in
                DispatchQueue.main.async {
                    listener.onWatchConnected()
                }
            }
        }
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {

        if characteristic.uuid == sdkCharacteristic?.uuid {
            print("\(TAG) didUnsubscribeFrom")
            connectedCentral = nil
            self.eventBus.notify(BLEManagerListener.self) { (listener) in
                DispatchQueue.main.async {
                    listener.onWatchDisconnected()
                }
            }
        }
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("\(TAG) didReceiveWrite: \(requests.count)")
        for request in requests {
            if request.value != nil {
                switch request.characteristic.uuid {
                case CBUUID(string: MADGAZE_IOS_CHARACTERISTIC):
                    onSDKCharacteristicReceivedData(data: request.value!)
                default:
                    break
                }
            }
            peripheral.respond(to: request, withResult: .success)
        }

    }
}
