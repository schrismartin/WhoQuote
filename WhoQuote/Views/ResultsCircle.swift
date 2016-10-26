//
//  ResultsCircle.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/27/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import UIKit


@IBDesignable class ResultsCircle: UIView {
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set(val) {
            self.layer.borderColor = val?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set(val) {
            self.layer.borderWidth = val
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set(val) {
            self.layer.cornerRadius = val
        }
    }
    
    @IBInspectable var text: String! {
        didSet {
            if let l = self.label {
                l.text = text
            }
        }
    }
    
    var label: UILabel! = {
        let l = UILabel()
        l.font = UIFont(name: "SignPainter-HouseScript", size: 70)!
        l.textColor = WQ_TEXT_COLOR
        l.textAlignment = .center
        return l
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
        self.clipsToBounds = true
        self.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(20, 20, 20, 20))
        }
    }

}
