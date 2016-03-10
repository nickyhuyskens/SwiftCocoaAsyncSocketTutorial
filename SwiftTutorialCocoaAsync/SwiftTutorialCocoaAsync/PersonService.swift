//
//  PersonService.swift
//  SwiftTutorialCocoaAsync
//
//  Created by Nicky Huyskens on 10/03/16.
//  Copyright © 2016 nicky. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class PersonService: NSObject, NSNetServiceDelegate, GCDAsyncSocketDelegate {
    var service: NSNetService?
    var services = [NSNetService]()
    var socket: GCDAsyncSocket!
    
    func startBroadcast() {
        socket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        do {
            try socket.acceptOnPort(0)
            service = NSNetService(domain: "", type: "_Tutorial._tcp", name: "SwiftTutorial", port: Int32(socket.localPort))
        } catch {
            print("error listening on port")
        }
        if let service = service {
            service.delegate = self
            service.publish()
        }
        
    }
    
    func netServiceDidPublish(sender: NSNetService) {
        guard let service = service else {
            return
        }
        print("published succesfully on port \(service.port) / domain: \(service.domain) / \(service.type) / \(service.name)")
    }
    
    func socket(sock: GCDAsyncSocket!, didAcceptNewSocket newSocket: GCDAsyncSocket!) {
        print("Socket accepted")
        socket = newSocket
        socket.delegate = self
        //socket.readDataWithTimeout(5, tag: 0)
        socket.readDataToLength(UInt(sizeof(Int16)), withTimeout: -1, tag: 1)
    }
    
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        if tag == 1 {
            var bodyLength: Int16 = 0
            data.getBytes(&bodyLength, length: sizeof(Int16))
            print("Header received with bodylength: \(bodyLength)")
            socket.readDataToLength(UInt(bodyLength), withTimeout: -1, tag: 2)
        } else if tag == 2 {
            let packet = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Packet
            PacketHandler.HandlePacket(packet)
            socket.readDataToLength(UInt(sizeof(Int16)), withTimeout: -1, tag: 1)
        }
    }
    
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        guard let sock = sock else {
            return
        }
        if (socket == sock) {
            print("Socket disconnected")
            socket.delegate = nil
            socket = nil
        }
    }
}