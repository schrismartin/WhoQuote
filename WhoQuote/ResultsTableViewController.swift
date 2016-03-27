//
//  ResultsTableViewController.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/27/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController {
    
    @IBOutlet weak var gameMessage: UILabel!
    
    @IBAction func continueAction(sender: AnyObject) {
        self.performSegueWithIdentifier(SEGUE_TO_MAIN_FROM_RESULTS, sender: self)
    }
    
    var game: Game! {
        didSet {
            if let success = successCircle {
                success.text = String(game.wins)
            }
            if let failure = failureCircle {
                failure.text = String(game.losses)
            }
        }
    }

    @IBOutlet weak var successCircle: ResultsCircle! {
        didSet {
            if let g = game {
                successCircle.text = String(g.wins)
            }
        }
    }
    
    @IBOutlet weak var failureCircle: ResultsCircle! {
        didSet {
            if let g = game {
                failureCircle.text = String(g.losses)
            }
        }
    }
    
    var gameType = ["Politics", "Politics", "Politics", "Politics", "Politics", "Politics", "Politics"]
    var score = ["4/5", "3/5", "5/5", "5/5", "4/5", "5/5", "4/5"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let score = "\(game.wins)/\(game.losses)"
        
        switch (game.wins, game.losses) {
        case (0, 5):
            print(score)
            self.gameMessage.text = "Twitter More!"
        case (1, 4):
            print(score)
            self.gameMessage.text = "You got 1!"
        case (2, 3):
            print(score)
            self.gameMessage.text = "That's ight."
        case (3, 2):
            print(score)
            self.gameMessage.text = "Pretty Good"
        case (4, 1):
            print(score)
            self.gameMessage.text = "Well Done!"
        case (5, 0):
            print(score)
            self.gameMessage.text = "You're Perfect!"
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gameType.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_RESULT, forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = gameType[indexPath.row]
        cell.detailTextLabel!.text = score[indexPath.row]

        return cell
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
        if segue.identifier == SEGUE_TO_MAIN_FROM_RESULTS {
            let destination = segue.destinationViewController as! LoadingViewController
            destination.loadingState = .Exiting
        }
    }

}
