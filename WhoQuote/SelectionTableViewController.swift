//
//  SelectionTableViewController.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/26/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import UIKit

class SelectionTableViewController: UITableViewController {
    
    var images: [UIImage] = {
        return [
            UIImage(named: "flag")!,
            UIImage(named: "soccer")!,
            UIImage(named: "guitar")!,
            UIImage(named: "actor")!,
            UIImage(named: "ellen")!
        ]
    }()
    
    var captions: [String] = {
        return [
            "Politicians",
            "Athletes",
            "Musicians",
            "Movie Stars",
            "TV Personalities"
        ]
    }()
    
    @IBAction func unwindToSelectionVC(segue: UIStoryboardSegue) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.backgroundColor = WQ_BACKGROUND_COLOR
        self.tableView.separatorStyle = .None
        
        self.navigationController?.navigationBar.topItem?.title = "WhoQuote"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "SignPainter-HouseScript", size: 32)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        
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
        return images.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_CATEGORY, forIndexPath: indexPath) as! CategoryTableViewCell

        // Configure the cell...
        cell.labelName = captions[indexPath.row]
        cell.backgroundImage = images[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "CATEGORIES"
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView == self.tableView) {
            for indexPath in self.tableView.indexPathsForVisibleRows! {
                self.setCellImageOffset(self.tableView.cellForRowAtIndexPath(indexPath) as! CategoryTableViewCell, indexPath: indexPath)
            }
        }
    }
    
    func setCellImageOffset(cell: CategoryTableViewCell, indexPath: NSIndexPath) {
        let cellFrame = self.tableView.rectForRowAtIndexPath(indexPath)
        let cellFrameInTable = self.tableView.convertRect(cellFrame, toView:self.tableView.superview)
        let cellOffset = cellFrameInTable.origin.y + cellFrameInTable.size.height
        let tableHeight = self.tableView.bounds.size.height + cellFrameInTable.size.height
        let cellOffsetFactor = cellOffset / tableHeight
        cell.setBackgroundOffset(cellOffsetFactor)
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
