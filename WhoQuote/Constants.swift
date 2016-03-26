//
//  Constants.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/26/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import Foundation
import UIKit

// View Controllers
let VIEW_CONTROLLER_SELECT_CATEGORY = "SelectCategoryViewController"

// Navigation Controllers
let NAVIGATION_CONTROLLER_MAIN = "MainNavigationController"

// Cell Identifiers
let CELL_CATEGORY = "CategoryCell"
let CELL_HIGHSCORES = "HighScoresCell"
let CELL_PERSON = "PersonCell"

// Segues
let SEGUE_UNWIND_MENU = "UnwindToMenu"

// Colors
let WQ_BACKGROUND_COLOR = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
let WQ_BUTTON_COLOR = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
let WQ_BUTTON_ACTIVE = UIColor(red: 90/255, green: 186/255, blue: 255/255, alpha: 1)
let WQ_BUTTON_CORRECT = UIColor(red: 48/255, green: 221/255, blue: 94/255, alpha: 1)
let WQ_BUTTON_INCORRECT = UIColor(red: 255/255, green: 70/255, blue: 70/255, alpha: 1)

enum ButtonStatus {
    case Active
    case Inactive
}