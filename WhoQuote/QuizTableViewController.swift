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
                self.stage = .Initial
                self.selectedIndex = -1
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
            } else {
                performSegueWithIdentifier(SEGUE_TO_RESULTS, sender: self)
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
    
    var stage: QuizStage = .Initial {
        didSet {
            if stage != oldValue {
                tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
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
    
    override func viewDidDisappear(animated: Bool) {
        self.game.quitListeningForScore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_PERSON, forIndexPath: indexPath) as! PersonTableViewCell

        // Configure the cell...
        if indexPath.section == 0 {
            cell.personView.person = people[indexPath.row]
        } else {
            cell.personView.person = messages[stage.rawValue]
        }
            
        return cell
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 && self.stage == .Continue { return false } else { return true }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PersonTableViewCell
        if indexPath.section == 0 {
            switch stage {
            case .Initial:
                // Exit out
                self.stage = .Continue
                print("Selected Index \(indexPath.row)")
                question.submitIndex(indexPath.row, withCallback: { (correct) in
                    print("Correct: \(correct)")
                    if correct == true {
                        cell.personView.buttonStatus = .Correct
                    } else {
                        cell.personView.buttonStatus = .Incorrect
                        let speakerId = self.question.quote.speakerId
                        self.highlightCellWithSpeakerId(speakerId)
                    }
                })
            case .Continue:
                // Go to next question
                break
            }
        }
        
        if indexPath.section == 1 {
            let indexPath = NSIndexPath(forRow: selectedIndex != -1 ? selectedIndex : 0, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! PersonTableViewCell
            cell.personView.buttonStatus = .Inactive
            
            self.selectedIndex = -1
            
            print(stage)
            
            switch stage {
            case .Initial:
                // Exit out
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.performSegueWithIdentifier(SEGUE_UNWIND_FROM_GAME, sender: self)
                })
            case .Continue:
                // Go to next question
                self.stage = .Initial
                self.question = self.game.continueToNextQuestion()
                break
            }
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func highlightCellWithSpeakerId(id: String) {
        for i in 0...3 {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            if people[i].id == id {
                let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! PersonTableViewCell
                cell.personView.buttonStatus = .Correct
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == SEGUE_UNWIND_FROM_GAME {
            let destination = segue.destinationViewController as! LoadingViewController
            destination.loadingState = .Exiting
        }
        if segue.identifier == SEGUE_TO_RESULTS {
            let destination = segue.destinationViewController as! ResultsTableViewController
            destination.game = self.game
        }
    }

}
