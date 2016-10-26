//
//  QuizTableViewController.swift
//  
//
//  Created by Chris Martin on 3/26/16.
//
//

import UIKit

class QuizTableViewController: UITableViewController {
    
    var game: Game! {
        didSet {
            question = game.getCurrentQuestion()
            game.listenForScore()
        }
    }
    
    var gameIndex: Int {
        get {
            return game.currentIndex
        }
        set {
            print(gameIndex)
        }
    }
    
    var question: Question! {
        didSet {
            if gameIndex < 5 {
                self.quote = question.quote.text
                self.stage = .initial
                self.selectedIndex = -1
                self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
            } else {
                performSegue(withIdentifier: SEGUE_TO_RESULTS, sender: self)
            }
        }
    }
    
    var people: [Speaker] {
        return question.speakers
    }
    
    var messages: [Speaker] = {
        return [
            Speaker(id: "123", image: UIImage(named: "left")!, name: "Forfeit", twitterHandle: "You will be returned to the menu!"),
            Speaker(id: "123", image: UIImage(named: "continue")!, name: "Continue", twitterHandle: "Go on to the next!")
        ]
    }()
    
    var quote: String! {
        didSet {
            if let tw = self.tweetWindow {
                tw.quote = quote
            }
        }
    }
    
    @IBOutlet weak var tweetWindow: TweetWindow! {
        didSet {
            if let q = self.quote {
                tweetWindow.quote = q
            }
        }
    }
    
    var stage: QuizStage = .initial {
        didSet {
            if stage != oldValue {
                tableView.reloadSections(IndexSet(integer: 1), with: .none)
            }
        }
    }
    
    var selectedIndex: Int = -1{
        didSet {
            print(selectedIndex)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationController?.navigationBar.topItem?.title = "WhoQuote"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "SignPainter-HouseScript", size: 32)!,  NSForegroundColorAttributeName: WQ_HIGHLIGHT_COLOR]
        
        self.tableView.backgroundColor = WQ_BACKGROUND_COLOR
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.game.quitListeningForScore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_PERSON, for: indexPath) as! PersonTableViewCell

        // Configure the cell...
        if (indexPath as NSIndexPath).section == 0 {
            cell.personView.person = people[(indexPath as NSIndexPath).row]
        } else {
            cell.personView.person = messages[stage.rawValue]
        }
            
        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if (indexPath as NSIndexPath).section == 0 && self.stage == .continue { return false } else { return true }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PersonTableViewCell
        if (indexPath as NSIndexPath).section == 0 {
            switch stage {
            case .initial:
                // Exit out
                self.stage = .continue
                print("Selected Index \((indexPath as NSIndexPath).row)")
                question.submitIndex((indexPath as NSIndexPath).row, withCallback: { (correct) in
                    print("Correct: \(correct)")
                    if correct == true {
                        cell.personView.buttonStatus = .correct
                    } else {
                        cell.personView.buttonStatus = .incorrect
                        let speakerId = self.question.quote.speakerId
                        self.highlightCellWithSpeakerId(speakerId)
                    }
                })
            case .continue:
                // Go to next question
                break
            }
        }
        
        if (indexPath as NSIndexPath).section == 1 {
            let indexPath = IndexPath(row: selectedIndex != -1 ? selectedIndex : 0, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! PersonTableViewCell
            cell.personView.buttonStatus = .inactive
            
            self.selectedIndex = -1
            
            print(stage)
            
            switch stage {
            case .initial:
                // Exit out
                DispatchQueue.main.async(execute: { () -> Void in
                    self.performSegue(withIdentifier: SEGUE_UNWIND_FROM_GAME, sender: self)
                })
            case .continue:
                // Go to next question
                self.stage = .initial
                self.question = self.game.continueToNextQuestion()
                break
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func highlightCellWithSpeakerId(_ id: String) {
        for i in 0...3 {
            let indexPath = IndexPath(row: i, section: 0)
            if people[i].id == id {
                let cell = self.tableView.cellForRow(at: indexPath) as! PersonTableViewCell
                cell.personView.buttonStatus = .correct
            }
        }
    }
    
    func proceedToResults() {
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == SEGUE_UNWIND_FROM_GAME {
            let destination = segue.destination as! LoadingViewController
            destination.loadingState = .exiting
        }
        if segue.identifier == SEGUE_TO_RESULTS {
            let destination = segue.destination as! ResultsTableViewController
            destination.game = self.game
        }
    }

}
