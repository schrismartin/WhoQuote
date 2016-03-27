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
    
    private var _id: String!
    private var _quote: Quote!
    private var _speakers: [Speaker]!
    private var _correct: Bool?
    
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
            Alamofire.request(.GET, questionURL).responseJSON { response in
                let questionJSON = JSON(response.result.value!)
                self.getQuote(questionJSON)
                
                let speakersJSON = questionJSON["multipleChoiceSpeakers"]
                self.getSpeakers(speakersJSON)
                
                self.submitDoneAlert()
            }
        }
    }
    
    func getQuote(json: JSON) {
        self._quote = Quote(json: json["quote"])
    }
    
    func getSpeakers(json: JSON) {
        for (_, speakerJSON) in json {
            let speaker = Speaker(json: speakerJSON)
            self._speakers.append(speaker)
        }
    }
    
    func submitIndex(index: Int, withCallback callback: (correct: Bool)->()) {
        let URL = HOST + QUESTION + _id
        print(speakers[index].id)
        Alamofire.request(.PUT, URL, parameters: ["selectedSpeaker": speakers[index].id])
            .responseJSON { response in
                if let value = response.result.value {
                    let questionJSON = JSON(value)
                    if let correct = questionJSON["isCorrect"].bool {
                        self._correct = correct
                        if correct == true { self.submitWinAlert() } else { self.submitLossAlert() }
                        callback(correct: correct)
                    } else {
                        print("PROBLEM")
                    }
                }
        }
    }
    
    private func submitDoneAlert() {
        let notification = NSNotification(name: ASYNC_QUESTION_FINISHED, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    
    private func submitWinAlert() {
        let notification = NSNotification(name: GAME_WON, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    
    private func submitLossAlert() {
        let notification = NSNotification(name: GAME_LOST, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
}
