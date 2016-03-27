//
//  SelectionTableViewController.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/26/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import UIKit

class SelectionTableViewController: UITableViewController {
    
    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.backgroundColor = WQ_BACKGROUND_COLOR
        self.tableView.separatorStyle = .None
        
        self.navigationController?.navigationBar.topItem?.title = "WhoQuote"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "SignPainter-HouseScript", size: 32)!,  NSForegroundColorAttributeName: WQ_HIGHLIGHT_COLOR]
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
        return categories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_CATEGORY, forIndexPath: indexPath) as! CategoryTableViewCell

        // Configure the cell...
        cell.labelName = categories[indexPath.row].name
        cell.backgroundImage = categories[indexPath.row].image

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "CATEGORIES"
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView == self.tableView) {
            guard let indexPathsForVisiableRows = self.tableView.indexPathsForVisibleRows else { return }
            for indexPath in indexPathsForVisiableRows {
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let destination = storyboard?.instantiateViewControllerWithIdentifier(VIEW_CONTROLLER_LOADING) as! LoadingViewController
        destination.loadingState = .Entering
        destination.target = categories[indexPath.row]
        print("Passed \(destination.target) to target")
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(destination, animated: true, completion: nil)
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
