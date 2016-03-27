//
//  LoadingViewController.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/26/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoadingViewController: UIViewController {

    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var loadingMessageLabel: UILabel! {
        didSet {
            loadingMessageLabel.textColor = WQ_HIGHLIGHT_COLOR
            
            if let string = self.labelString {
                loadingMessageLabel.text = string
            }
        }
    }
    
    @IBAction func unwindSegue(sender: UIStoryboardSegue) {
        self.loadingView.invalidateTimer()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var loadingState: LoadingState! {
        didSet {
            if loadingState! == .Entering {
                self.labelString = "Loading Your Game..."
            } else {
                self.labelString = "Submitting Scores..."
            }
        }
    }
    
    private var labelString: String! {
        didSet {
            if let label = self.loadingMessageLabel {
                label.text = labelString!
            }
        }
    }
    
    private var qCount: Int = 0
    
    var game: Game! {
        didSet {
            // We have the game, Now we must listen for async calls to finish
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(incrementQCount), name: ASYNC_QUESTION_FINISHED, object: nil)
        }
    }
    
    var target: Category! {
        didSet {
            print("Getter tripped")
            // Begin processing
            let URL = HOST + GAME
            print("Tagging \(URL)")
            Alamofire.request(.POST, URL, parameters: ["category": target.slug, "user": "testUser"])
                .responseJSON { response in
                    print("Gotten Initial Game Object")
                    if let value = response.result.value {
                        let json = JSON(value)
                        if let id = json["id"].string {
                            let gameURL = HOST + GAME + id
                            Alamofire.request(.GET, gameURL).responseJSON { response in
                                print("Gotten Full Game Object, making Game")
                                if let value = response.result.value {
                                    let gameJSON = JSON(value)
                                    self.game = Game(json: gameJSON)
                                }
                            }
                        }
                    }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = WQ_BACKGROUND_COLOR
        
//        _ = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(changeVC), userInfo: nil, repeats: false)
    }
    
    override func viewDidLayoutSubviews() {
        loadingView.fire()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ASYNC_QUESTION_FINISHED, object: nil)
    }
    
    func incrementQCount() {
        print("qCount is now at \(qCount)")
        if self.qCount == 3 {
            changeVC()
        } else {
            self.qCount += 1
        }
    }
    
    func changeVC() {
        print("Received Message to go through")
        self.loadingView.invalidateTimer()
        self.performSegueWithIdentifier(SEGUE_TO_GAME, sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == SEGUE_TO_GAME {
            let nav = segue.destinationViewController as! UINavigationController
            let destination = nav.topViewController as! QuizTableViewController
            destination.game = self.game
        }
    }

}
