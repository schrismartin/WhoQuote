//
//  Constants.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/26/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import Foundation
import UIKit

// URL
//let HOST = "http://localhost:1337/api/" // Dev
let HOST = "http://159.203.146.240/api/" // Prod
let GAME = "game/"
let CATEGORY = "category/"
let QUESTION = "question/"


// View Controllers
let VIEW_CONTROLLER_SELECT_CATEGORY = "SelectCategoryViewController"
let VIEW_CONTROLLER_LOADING = "LoadingViewController"

// Navigation Controllers
let NAVIGATION_CONTROLLER_MAIN = "MainNavigationController"
let NAVIGATION_CONTROLLER_GAME = "GameNavigationController"

// Cell Identifiers
let CELL_CATEGORY = "CategoryCell"
let CELL_HIGHSCORES = "HighScoresCell"
let CELL_PERSON = "PersonCell"
let CELL_RESULT = "score_identifier"

// Segues
let SEGUE_UNWIND_FROM_GAME = "UnwindFromGame"
let SEGUE_TO_GAME = "ToGameSegue"
let SEGUE_TO_MAIN = "ToMainScene"
let SEGUE_TO_RESULTS = "ToResults"
let SEGUE_TO_MAIN_FROM_RESULTS = "unwindToMainFromResults"

// Notifications

let ASYNC_QUESTION_FINISHED = "ASYNC_QUESTION_FINISHED"
let ASYNC_QUESTION_COUNT_FINISHED = "ASYNC_QUESTION_COUNT_FINISHED"
let GAME_WON = "GAME_WON"
let GAME_LOST = "GAME_LOST"
let GAME_STATUS_UPDATE = "GAME_STATUS_UPDATE"

// Colors

// DARK THEME
//let WQ_BAR_COLOR = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
//let WQ_BACKGROUND_COLOR = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
//let WQ_BUTTON_COLOR = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
//let WQ_BUTTON_ACTIVE = UIColor(red: 90/255, green: 186/255, blue: 255/255, alpha: 1)
//let WQ_BUTTON_CORRECT = UIColor(red: 48/255, green: 221/255, blue: 94/255, alpha: 1)
//let WQ_BUTTON_INCORRECT = UIColor(red: 255/255, green: 70/255, blue: 70/255, alpha: 1)

// LIGHT THEME
let WQ_HIGHLIGHT_COLOR = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
let WQ_BAR_COLOR = UIColor(red: 245/255, green: 248/255, blue: 250/255, alpha: 1)
let WQ_BACKGROUND_COLOR = UIColor(red: 245/255, green: 248/255, blue: 250/255, alpha: 1)
let WQ_BUTTON_COLOR = UIColor(red: 225/255, green: 232/255, blue: 237/255, alpha: 1)
let WQ_BUTTON_DOWN = UIColor(red: 136/255, green: 153/255, blue: 166/255, alpha: 1)
let WQ_BUTTON_ACTIVE = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
let WQ_BUTTON_CORRECT = UIColor(red: 0.87, green: 0.94, blue: 0.85, alpha: 1)
let WQ_BUTTON_INCORRECT = UIColor(red: 0.95, green: 0.87, blue: 0.87, alpha: 1)
let WQ_TEXT_COLOR = UIColor(red: 41/255, green: 47/255, blue: 51/255, alpha: 1)
let WQ_DETAIL_TEXT_COLOR = UIColor(red: 102/255, green: 117/255, blue: 127/255, alpha: 1)

enum ButtonStatus {
    case Active
    case Inactive
    case Correct
    case Incorrect
}

enum LoadingState {
    case Entering
    case Exiting
    mutating func swap() {
        switch self {
        case .Entering:
            self = .Exiting
        case .Exiting:
            self = .Entering
        }
    }
}

enum QuizStage: Int {
    case Initial = 0
    case Continue = 1
}