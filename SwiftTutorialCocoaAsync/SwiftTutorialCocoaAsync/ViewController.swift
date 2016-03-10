//
//  ViewController.swift
//  SwiftTutorialCocoaAsync
//
//  Created by Nicky Huyskens on 10/03/16.
//  Copyright © 2016 nicky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var personService: PersonService!
    var personServiceBrowser = PersonServiceBrowser()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personService = PersonService()
        personService.startBroadcast()
        
        personServiceBrowser.startBrowsing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

