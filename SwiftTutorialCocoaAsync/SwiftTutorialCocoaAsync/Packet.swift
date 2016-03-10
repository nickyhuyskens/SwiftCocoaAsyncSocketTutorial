//
//  Packet.swift
//  SwiftTutorialCocoaAsync
//
//  Created by Nicky Huyskens on 10/03/16.
//  Copyright © 2016 nicky. All rights reserved.
//

import Foundation

@objc(Packet)
class Packet: NSObject, NSCoding {
    var objectType: ObjectType!
    var object: AnyObject!
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        objectType = ObjectType(rawValue: decoder.decodeObjectForKey("objectType") as! Int)
        object = decoder.decodeObjectForKey("object") as! NSObject
    }
    
    convenience init(objectType: ObjectType, object: AnyObject) {
        self.init()
        self.objectType = objectType
        self.object = object
    }
    
    func encodeWithCoder(coder: NSCoder) {
        if let objectType = objectType { coder.encodeObject(objectType.rawValue, forKey: "objectType") }
        if let object = object { coder.encodeObject(object, forKey: "object") }
    }
    
    func getObject<Element>() -> Element {
        return object as! Element
    }
}

enum ObjectType: Int {
    case Personpacket = 1
}