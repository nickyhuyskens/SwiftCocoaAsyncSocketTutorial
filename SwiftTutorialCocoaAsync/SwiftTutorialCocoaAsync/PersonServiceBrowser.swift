//
//  PersonServiceBrowser.swift
//  SwiftTutorialCocoaAsync
//
//  Created by Nicky Huyskens on 10/03/16.
//  Copyright © 2016 nicky. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class PersonServiceBrowser: NSObject, NSNetServiceDelegate, NSNetServiceBrowserDelegate, GCDAsyncSocketDelegate {
    var socket: GCDAsyncSocket!
    var services: NSMutableArray!
    var serviceBrowser: NSNetServiceBrowser!
    var service: NSNetService!
    
    func startBrowsing() {
        if (services != nil) {
            services.removeAllObjects()
        } else {
            services = NSMutableArray()
        }
        
        serviceBrowser = NSNetServiceBrowser()
        serviceBrowser.delegate = self
        serviceBrowser.searchForServicesOfType("_tutorial._tcp", inDomain: "")
        
    }
    
    func netServiceBrowser(browser: NSNetServiceBrowser, didFindService service: NSNetService, moreComing: Bool) {
        services.addObject(service)
        connect()
    }
    
    func connect() {
        service = services.firstObject! as! NSNetService
        service.delegate = self
        service.resolveWithTimeout(30.0)
    }
    
    func netServiceDidResolveAddress(sender: NSNetService) {
        if connectWithService(sender) {
            print("Did connect with service")
        } else {
            print("Error connecting with service")
        }
    }
    
    func netService(sender: NSNetService, didNotResolve errorDict: [String : NSNumber]) {
        service.delegate = nil
    }
    
    func connectWithService(service: NSNetService) -> Bool {
        var isConnected = false
        
        let addresses: NSArray = service.addresses!
        
        if (socket == nil || !socket.isConnected) {
            socket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
            //Connect
            var count = 0
            while (!isConnected && addresses.count >= count) {
                let address = addresses.objectAtIndex(count) as! NSData
                count += 1
                do {
                    try socket.connectToAddress(address)
                    isConnected = true
                } catch {
                    print("Failed to connect")
                }
            }
        } else {
            isConnected = socket.isConnected
        }
        
        return isConnected
    }
    
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        print("Socket connected to host")
        
        var person = Person(name: "Nicky", age: 20)
        var personPacket = PersonPacket(person: person)
        var packet = Packet(objectType: ObjectType.Personpacket, object: personPacket)
        sendPacket(packet)
        print("Test packet sent")
    }
    
    func sendPacket(packet: Packet) {
        let packetData = NSKeyedArchiver.archivedDataWithRootObject(packet)
        var packetDataLength = packetData.length
        var buffer = NSMutableData(bytes: &packetDataLength, length: sizeof(Int16))
        buffer.appendData(packetData)
        socket.writeData(buffer, withTimeout: -1, tag: 0)
    }
    
}