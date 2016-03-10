//
//  PacketHandler.swift
//  SwiftTutorialCocoaAsync
//
//  Created by Nicky Huyskens on 10/03/16.
//  Copyright © 2016 nicky. All rights reserved.
//

import Foundation

public class PacketHandler {
    
    static func HandlePacket(packet: Packet) {
        switch packet.objectType! {
        case .Personpacket:
            let personPacket = packet.getObject() as PersonPacket
            let person = personPacket.person
            print("Person received, name: " + person.name + " age: \(person.age)")
            break
        }
    }
    
}