//
//  LoadingView.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/26/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    var timer: Timer!
    
    var labels: [UILabel] = {
        let labelArray = [
            UILabel(),
            UILabel(),
            UILabel(),
            UILabel(),
            UILabel()
        ]
        
        for item in labelArray {
            item.text = "●"
            item.alpha = 0
            item.textColor = WQ_HIGHLIGHT_COLOR
            item.font = UIFont.systemFont(ofSize: 50)
        }
        
        return labelArray
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    func setUpView() {
        self.backgroundColor = WQ_BACKGROUND_COLOR
        self.clipsToBounds = true
        
        for label in labels {
            self.addSubview(label)
            label.sizeToFit()
        }
    }
    
    func fire() {
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(LoadingView.setOffDots), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func invalidateTimer() {
        if timer != nil {
            timer.invalidate()
        }
    }
    
    func setOffDots() {
        let separation: CGFloat = 50
        for i in 0...4 {
            moveDotWithOffset(labels[i], offset: (CGFloat(i)-2) * separation, time: TimeInterval(4-i)/7)
        }
    }
    
    func moveDotWithOffset(_ dot: UILabel, offset: CGFloat, time: TimeInterval) {
        let centerX = self.bounds.width/2
        let centerY = self.bounds.height/2
        let left = self.bounds.origin.x
        let right = self.bounds.width
        let dotHeight = dot.bounds.height
        let dotWidth = dot.bounds.width
        
        dot.frame.origin = CGPoint(x: left - dotWidth/2 + offset, y: centerY - dotHeight/2)
        dot.alpha = 0
        
        UIView.animate(withDuration: 0.75, delay: time, options: UIViewAnimationOptions(), animations: {
            dot.frame.origin = CGPoint(x: centerX-dotWidth/2 + offset, y: centerY-dotHeight/2)
            dot.alpha = 1
        }) { (success) in
            UIView.animate(withDuration: 0.75, delay: 1, options: UIViewAnimationOptions(), animations: {
                dot.frame.origin = CGPoint(x: right-dotWidth/2 + offset, y: centerY-dotHeight/2)
                dot.alpha = 0
                }, completion: nil)
        }
    }
}
