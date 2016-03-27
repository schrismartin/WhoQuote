//
//  TweetWindow.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/26/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import UIKit

@IBDesignable class TweetWindow: UIView {
    
    var logoImageView: UIImageView! = {
        let imageView = UIImageView()
        if let image = UIImage(named: "twitter_logo") {
            imageView.image = image
        }
        imageView.alpha = 0.5
        return imageView
    }()
    
    @IBInspectable var quote: String! {
        didSet {
            if let label = self.quoteLabel {
                label.text = quote
            }
        }
    }
    
    var quoteLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(18)
        label.textColor = WQ_TEXT_COLOR
        label.numberOfLines = 0
        return label
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
        // Set Up View
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.backgroundColor = WQ_BUTTON_COLOR
        
        // Add Labels
        self.addSubview(logoImageView)
        self.addSubview(quoteLabel)
        
        // Make AutoLayout Constraints
        self.logoImageView.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(-40)
            make.bottom.equalTo(self).offset(40)
            make.left.equalTo(self).offset(-40)
            make.width.equalTo(logoImageView.snp_height)
        }
        
        self.quoteLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(38)
            make.left.equalTo(self).offset(15)
            make.bottom.equalTo(self).offset(-38)
            make.right.equalTo(self).offset(-15)
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
