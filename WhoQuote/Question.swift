//
//  Question.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/26/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Question: NSObject {
    
    fileprivate var _id: String!
    fileprivate var _quote: Quote!
    fileprivate var _speakers: [Speaker]!
    fileprivate var _correct: Bool?
    
    var id: String {
        return _id
    }
    var quote: Quote {
        return _quote
    }
    var speakers: [Speaker] {
        return _speakers
    }
    
    var correct: Bool? {
        return _correct
    }
    
    override init() {
        super.init()
    }
    
    convenience init(json: JSON) {
        self.init()
        
        self._speakers = [Speaker]()
        
        if let id = json["id"].string {
            self._id = id
            let questionURL = HOST + QUESTION + id
            Alamofire.request(questionURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                let questionJSON = JSON(response.result.value!)
                self.getQuote(questionJSON)
                
                let speakersJSON = questionJSON["multipleChoiceSpeakers"]
                self.getSpeakers(speakersJSON)
                
                self.submitDoneAlert()
            })
        }
    }
    
    func getQuote(_ json: JSON) {
        self._quote = Quote(json: json["quote"])
    }
    
    func getSpeakers(_ json: JSON) {
        for (_, speakerJSON) in json {
            let speaker = Speaker(json: speakerJSON)
            self._speakers.append(speaker)
        }
    }
    
    func submitIndex(_ index: Int, withCallback callback: @escaping (_ correct: Bool)->()) {
        let url = HOST + QUESTION + _id
        let parameters = ["selectedSpeaker": speakers[index].id]
        print(speakers[index].id)
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let questionJSON = JSON(value)
                if let correct = questionJSON["isCorrect"].bool {
                    self._correct = correct
                    
                    if correct == true {
                        self.submitWinAlert()
                    } else {
                        self.submitLossAlert()
                    }
                    callback(correct)
                } else {
                    print("PROBLEM")
                }
            }
        }
    }
    
    fileprivate func submitDoneAlert() {
        let notification = Notification(name: Notification.Name(rawValue: ASYNC_QUESTION_FINISHED), object: nil)
        NotificationCenter.default.post(notification)
    }
    
    fileprivate func submitWinAlert() {
        let notification = Notification(name: Notification.Name(rawValue: GAME_WON), object: nil)
        NotificationCenter.default.post(notification)
    }
    
    fileprivate func submitLossAlert() {
        let notification = Notification(name: Notification.Name(rawValue: GAME_LOST), object: nil)
        NotificationCenter.default.post(notification)
    }
}
