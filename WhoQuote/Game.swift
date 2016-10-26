//
//  Game.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/26/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Game: NSObject {
    
    var questions: [Question]! {
        didSet {
            questions.sort { $0.id < $1.id }
        }
    }
    
    var category: Category!
    var _currentIndex: Int!
    var currentIndex: Int {
        return _currentIndex
    }
    
    var wins: Int = 0 {
        didSet {
            print("Wins: \(wins)")
        }
    }
    var losses: Int = 0 {
        didSet {
            print("Losses: \(losses)")
        }
    }
    
    override init() {
        super.init()
        self._currentIndex = 0
    }
    
    func listenForScore() {
        NotificationCenter.default.addObserver(self, selector: #selector(logWin), name: NSNotification.Name(rawValue: GAME_WON), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logLoss), name: NSNotification.Name(rawValue: GAME_LOST), object: nil)
    }
    
    func quitListeningForScore() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: GAME_WON), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: GAME_LOST), object: nil)
    }
    
    func logWin() {
        self.wins += 1
    }
    
    func logLoss() {
        self.losses += 1
    }
    
    convenience init(json: JSON) {
        self.init()
        
        if let id = json["id"].string {
            self.populateWithId(id)
        }
    }
    
    func populateWithId(_ id: String) {
        self.questions = [Question]()
        let gameURL = HOST + GAME + id
        
        Alamofire.request(gameURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
        .responseJSON { (response) in
            let gameJSON = JSON(response.result.value!)
            
            // Get Category
            self.category = Category(json: gameJSON["category"])
            
            // Create Questions
            let questionsJSON = gameJSON["questions"]
            for (_, question) in questionsJSON {
                self.questions.append(Question(json: question))
            }
        }
    }
    
    func continueToNextQuestion() -> Question {
        self._currentIndex! += 1
        let index = min(currentIndex, 4)
        return self.questions![index]
    }
    
    func getCurrentQuestion() -> Question {
        return self.questions![currentIndex]
    }
}
