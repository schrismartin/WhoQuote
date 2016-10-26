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
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        self.loadingView.invalidateTimer()
        self.dismiss(animated: true, completion: nil)
    }
    
    var loadingState: LoadingState! {
        didSet {
            if loadingState! == .entering {
                self.labelString = "Loading Your Game..."
            } else {
                self.labelString = "Submitting Scores..."
            }
        }
    }
    
    fileprivate var labelString: String! {
        didSet {
            if let label = self.loadingMessageLabel {
                label.text = labelString!
            }
        }
    }
    
    fileprivate var qCount: Int = 0
    
    var game: Game! {
        didSet {
            // We have the game, Now we must listen for async calls to finish
            NotificationCenter.default.addObserver(self, selector: #selector(incrementQCount), name: NSNotification.Name(rawValue: ASYNC_QUESTION_FINISHED), object: nil)
        }
    }
    
    var target: Category! {
        didSet {
            print("Getter tripped")
            // Begin processing
            let URL = HOST + GAME
            print("Tagging \(URL)")
            
            Alamofire.request(URL, method: .post,
                              parameters: ["category": target.slug, "user": "testUser"],
                              encoding: JSONEncoding.default, headers: nil)
            .responseJSON { (response) in
                print("Gotten Initial Game Object")
                if let value = response.result.value {
                    let json = JSON(value)
                    if let id = json["id"].string {
                        let gameURL = HOST + GAME + id
                        
                        Alamofire.request(gameURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
                        .responseJSON(completionHandler: { (response) in
                            print("Gotten Full Game Object, making Game")
                            if let value = response.result.value {
                                let gameJSON = JSON(value)
                                self.game = Game(json: gameJSON)
                            }
                        })
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
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: ASYNC_QUESTION_FINISHED), object: nil)
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
        self.performSegue(withIdentifier: SEGUE_TO_GAME, sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == SEGUE_TO_GAME {
            let nav = segue.destination as! UINavigationController
            let destination = nav.topViewController as! QuizTableViewController
            destination.game = self.game
        }
    }

}
