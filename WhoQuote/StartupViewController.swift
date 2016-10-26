//
//  StartupViewController.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/26/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class StartupViewController: UIViewController {
    
    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let URL = HOST + CATEGORY
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value {
                let json = JSON(value)
                for (_, item) in json {
                    self.categories.append(Category(json: item))
                }
                print(self.categories.map { $0.name })
                self.performSegue(withIdentifier: SEGUE_TO_MAIN, sender: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as! UINavigationController
        let destination = nav.topViewController as! SelectionTableViewController
        
        destination.categories = self.categories
    }
}
