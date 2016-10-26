//
//  PersonButton.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/26/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import UIKit
import SnapKit

@IBDesignable class PersonButton: UIView {
    
    // MARK: Public Properties
    @IBInspectable var person: Speaker! {
        didSet {
            if let personImage = person.image {
                image = personImage
            }
            if let personName = person.name {
               name = personName
            }
            if let personTwitterHandle = person.twitterHandle {
                twitterHandle = personTwitterHandle
            }
        }
    }
    
    @IBInspectable var image: UIImage! {
        didSet {
            personImageView.image = image
        }
    }
    
    @IBInspectable var name: String! {
        didSet {
            if let label = self.nameLabel { label.text = name }
        }
    }
    
    @IBInspectable var twitterHandle: String! {
        didSet {
            if let label = self.twitterHandleLabel { label.text = twitterHandle }
        }
    }
    
    var buttonStatus: ButtonStatus = .inactive {
        didSet {
            switch buttonStatus {
            case .active:
                self.backgroundColor = WQ_BUTTON_ACTIVE
            case .inactive:
                self.backgroundColor = WQ_BUTTON_COLOR
            case .correct:
                self.backgroundColor = WQ_BUTTON_CORRECT
            case .incorrect:
                self.backgroundColor = WQ_BUTTON_INCORRECT
            }
        }
    }
    
    // MARK: UI Elements
    
    var personImageView: UIImageView! = {
        let frame = CGRect(x: 4, y: 4, width: 42, height: 42)
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var nameLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = WQ_TEXT_COLOR
        return label
    }()
    
    var twitterHandleLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = WQ_DETAIL_TEXT_COLOR
        return label
    }()
    
    // MARK: Initializers
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
    
    // MARK: UI Setup
    func setUpView() {
        self.layer.cornerRadius = 8
        self.backgroundColor = WQ_BUTTON_COLOR
        
        if let imageView = personImageView { self.addSubview(imageView) }
        if let label = nameLabel { self.addSubview(label) }
        if let label = twitterHandleLabel { self.addSubview(label) }
        
        // Adjust autolayout constraints
        self.personImageView.snp_makeConstraints({ (make) in
            make.top.equalTo(self).offset(4)
            make.left.equalTo(self).offset(4)
            make.bottom.equalTo(self).offset(-4)
            make.width.equalTo(personImageView.snp_height)
        })
        self.nameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(7)
            make.left.equalTo(personImageView.snp_right).offset(10)
            make.right.equalTo(self).offset(-7)
        }
        self.twitterHandleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp_bottom).offset(0)
            make.left.equalTo(personImageView.snp_right).offset(10)
            make.right.equalTo(self).offset(-7)
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
