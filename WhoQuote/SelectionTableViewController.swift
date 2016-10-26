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
        self.tableView.separatorStyle = .none
        
        self.navigationController?.navigationBar.topItem?.title = "WhoQuote"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "SignPainter-HouseScript", size: 32)!,  NSForegroundColorAttributeName: WQ_HIGHLIGHT_COLOR]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_CATEGORY, for: indexPath) as! CategoryTableViewCell

        // Configure the cell...
        cell.labelName = categories[(indexPath as NSIndexPath).row].name
        cell.backgroundImage = categories[(indexPath as NSIndexPath).row].image

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "CATEGORIES"
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == self.tableView) {
            guard let indexPathsForVisiableRows = self.tableView.indexPathsForVisibleRows else { return }
            for indexPath in indexPathsForVisiableRows {
                self.setCellImageOffset(self.tableView.cellForRow(at: indexPath) as! CategoryTableViewCell, indexPath: indexPath)
            }
        }
    }
    
    func setCellImageOffset(_ cell: CategoryTableViewCell, indexPath: IndexPath) {
        let cellFrame = self.tableView.rectForRow(at: indexPath)
        let cellFrameInTable = self.tableView.convert(cellFrame, to:self.tableView.superview)
        let cellOffset = cellFrameInTable.origin.y + cellFrameInTable.size.height
        let tableHeight = self.tableView.bounds.size.height + cellFrameInTable.size.height
        let cellOffsetFactor = cellOffset / tableHeight
        cell.setBackgroundOffset(cellOffsetFactor)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = storyboard?.instantiateViewController(withIdentifier: VIEW_CONTROLLER_LOADING) as! LoadingViewController
        destination.loadingState = .entering
        destination.target = categories[(indexPath as NSIndexPath).row]
        print("Passed \(destination.target) to target")
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.present(destination, animated: true, completion: nil)
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
