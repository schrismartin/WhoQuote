//
//  Person.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/26/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import UIKit

class Person: NSObject {
    
    var image: UIImage!
    var name: String!
    var twitterHandle: String!
    
    override init() {
        super.init()
    }
    
    convenience init(image: UIImage, name: String, twitterHandle: String) {
        self.init()
        
        self.image = image
        self.name = name
        self.twitterHandle = twitterHandle
    }
}
