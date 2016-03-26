//
//  QuizTableViewController.swift
//  
//
//  Created by Chris Martin on 3/26/16.
//
//

import UIKit

class QuizTableViewController: UITableViewController {
    
    var people: [Person] = {
        return [
            Person(image: UIImage(named: "hillary")!, name: "Hillary Clinton", twitterHandle: "@HillaryClinton"),
            Person(image: UIImage(named: "ted")!, name: "Ted Cruz", twitterHandle: "@tedcruz"),
            Person(image: UIImage(named: "bernie")!, name: "Bernie Sanders", twitterHandle: "@SenSanders"),
            Person(image: UIImage(named: "donald")!, name: "Donald Trump", twitterHandle: "@realDonaldTrump")
        ]
    }()
    
    var messages: [Person] = {
        return [
            Person(image: UIImage(named: "left")!, name: "Forfeit", twitterHandle: "You will lose the round!"),
            Person(image: UIImage(named: "right")!, name: "Submit", twitterHandle: "Choose carefully!"),
            Person(image: UIImage(named: "continue")!, name: "Continue", twitterHandle: "Go on to the next!")
        ]
    }()
    
    var stage: Int = 0 {
        didSet {
            if oldValue != stage {
                print(stage)
                if stage == 2 {
                    // Run submit scripts
                    self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
                }
                self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
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
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "SignPainter-HouseScript", size: 32)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
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
            cell.personView.person = messages[stage]
        }
            
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            for i in 0...people.count-1 {
                let newIndexPath = NSIndexPath(forRow: i, inSection: 0)
                let cell = tableView.cellForRowAtIndexPath(newIndexPath) as! PersonTableViewCell
                cell.personView.buttonStatus = .Inactive
            }
            
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! PersonTableViewCell
            self.selectedIndex = indexPath.row
            self.stage = 1
            cell.personView.buttonStatus = .Active
        }
        
        if indexPath.section == 1 {
            let indexPath = NSIndexPath(forRow: selectedIndex != -1 ? selectedIndex : 0, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! PersonTableViewCell
            cell.personView.buttonStatus = .Inactive
            
            self.selectedIndex = -1
            
            switch stage {
            case 0:
                // Exit out
                performSegueWithIdentifier(SEGUE_UNWIND_MENU, sender: self)
                break
            case 1:
                self.stage = 2
            case 2:
                // Go to next question
                self.stage = 0
                break
            default:
                break
            }
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
