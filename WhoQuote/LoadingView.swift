//
//  LoadingView.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/26/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    var timer: NSTimer!
    
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
            item.font = UIFont.systemFontOfSize(50)
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
        timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(LoadingView.setOffDots), userInfo: nil, repeats: true)
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
            moveDotWithOffset(labels[i], offset: (CGFloat(i)-2) * separation, time: NSTimeInterval(4-i)/7)
        }
    }
    
    func moveDotWithOffset(dot: UILabel, offset: CGFloat, time: NSTimeInterval) {
        let centerX = self.bounds.width/2
        let centerY = self.bounds.height/2
        let left = self.bounds.origin.x
        let right = self.bounds.width
        let dotHeight = dot.bounds.height
        let dotWidth = dot.bounds.width
        
        dot.frame.origin = CGPoint(x: left - dotWidth/2 + offset, y: centerY - dotHeight/2)
        dot.alpha = 0
        
        UIView.animateWithDuration(0.75, delay: time, options: .CurveEaseInOut, animations: {
            dot.frame.origin = CGPoint(x: centerX-dotWidth/2 + offset, y: centerY-dotHeight/2)
            dot.alpha = 1
        }) { (success) in
            UIView.animateWithDuration(0.75, delay: 1, options: .CurveEaseInOut, animations: {
                dot.frame.origin = CGPoint(x: right-dotWidth/2 + offset, y: centerY-dotHeight/2)
                dot.alpha = 0
                }, completion: nil)
        }
    }
}