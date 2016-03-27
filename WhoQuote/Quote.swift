//
//  Quote.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/26/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Quote: NSObject {
    
    private var _text: String!
    var text: String {
        return _text
    }
    
    private var _source: String!
    var source: String {
        return _source
    }
    
    private var _speakerId: String!
    var speakerId: String {
        return _speakerId
    }
    
    override init() {
        super.init()
    }
    
    convenience init(json: JSON) {
        self.init()
        if let str = json["text"].string {
            _text = str
        }
        if let str = json["sourceURL"].string {
            _source = str
        }
        if let str = json["speaker"].string {
            _speakerId = str
        }
        
    }
}
