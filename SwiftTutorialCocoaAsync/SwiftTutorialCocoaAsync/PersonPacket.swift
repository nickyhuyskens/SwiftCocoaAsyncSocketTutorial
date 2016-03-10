//
//  PersonPacket.swift
//  SwiftTutorialCocoaAsync
//
//  Created by Nicky Huyskens on 10/03/16.
//  Copyright © 2016 nicky. All rights reserved.
//

import Foundation

@objc(PersonPacket)
class PersonPacket: NSObject, NSCoding {
    var person: Person!
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        let name = decoder.decodeObjectForKey("name") as! String
        let age = decoder.decodeObjectForKey("age") as! Int
        person = Person(name: name, age: age)
    }
    
    convenience init(person: Person) {
        self.init()
        self.person = person
    }
    
    func encodeWithCoder(coder: NSCoder) {
        if let name = person.name { coder.encodeObject(name, forKey: "name") }
        if let age = person.age { coder.encodeObject(age, forKey: "age") }
    }
    
}