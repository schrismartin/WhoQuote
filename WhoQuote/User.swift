//
//  User.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/26/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import UIKit

class User : NSObject{
    
    static let usr = User()
    
    private var _email: String!
    private var _id: String!
    private var _name: String!
    private var _twitterHandle: String!
    
    var email: String {
        return _email
    }
    
    var id: String {
        return _id
    }
    
    var name: String {
        return _name
    }
    
    var twitterHandle: String {
        return _twitterHandle
    }
    
    override init() {
        super.init()
    }
    
    convenience init(email: String, id: String, name: String, handle: String) {
        self.init()
        
        _email = email
        _id = id
        _name = name
        _twitterHandle = handle
    }
    
    convenience init(id: String, name: String, handle: String) {
        self.init()

        _id = id
        _name = name
        _twitterHandle = handle
    }
}