//
//  CategoryTableViewCell.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/26/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    internal let internalTintColor = UIColor.black.withAlphaComponent(0.25)
    
    var backgroundImage: UIImage? {
        didSet {
            if let backgroundImageView = self.backgroundImageView {
                if let image = self.backgroundImage {
                    self.backgroundImage = image.applyBlurWithRadius(0, tintColor: internalTintColor, saturationDeltaFactor: 0)
                    backgroundImageView.image = self.backgroundImage
                }
                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: { () -> Void in
                    // Perform this in background
                    if let image = self.backgroundImage {
                        self.blurredImage = image.applyLightEffect()
                    }
                })
            }
        }
    }
    
    fileprivate var blurredImage: UIImage!
    
    var labelName: String! {
        didSet {
            if let label = mainLabel {
                label.text = labelName
            }
        }
    }
    
    var yPosition: CGFloat! {
        didSet {
            yAxisConstraint.constant = yPosition
        }
    }
    
    @IBOutlet weak var yAxisConstraint: NSLayoutConstraint!

    @IBOutlet weak var backgroundImageView: UIImageView! {
        didSet {
            if let backgroundImage = self.backgroundImage {
                backgroundImageView.image = backgroundImage.applyBlurWithRadius(0, tintColor: internalTintColor, saturationDeltaFactor: 0)
            }
        }
    }

    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 8
            containerView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var mainLabel: UILabel!
    
    let parallaxFactor: CGFloat = -40
    var imagePositionInitial: CGFloat!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        yPosition = 2 * parallaxFactor
        imagePositionInitial = yPosition
    }
    
    func setBackgroundOffset(_ offset:CGFloat) {
        let boundOffset = max(0, min(1, offset))
        let pixelOffset = (1-boundOffset)*2*parallaxFactor
        self.yPosition = imagePositionInitial - pixelOffset
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected == true {
            if let image = self.blurredImage {
                self.backgroundImageView.image = image
            }
        } else {
            if let image = self.backgroundImage {
                self.backgroundImageView.image = image
            }
        }
    }


}
