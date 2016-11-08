//
//  CategoryTableViewCell.swift
//  Catalog
//
//  Created by Michael Rakowski on 11/4/16.
//  Copyright © 2016 Michael Rakowski. All rights reserved.
//

import Foundation
import UIKit


class CategoryTableViewCell : UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var categoryLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var redCircleView: UIView!
    
    // MARK:
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        
        let attrString = NSAttributedString.init(string: text, attributes: [NSFontAttributeName:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width: rect.size.width, height: rect.size.height)
        
        return size
    }
    
    override func updateConstraints() {
        
        if self.descriptionLabel.text != nil && self.descriptionLabel.text != "" {
            
            self.categoryLabelTopConstraint.constant = 14.0
            
            // Adjust height of description label to fit text
            let estimatedSize = rectForText(text: self.descriptionLabel.text!,
                                            font: self.descriptionLabel.font,
                                            maxSize: CGSize(width: self.descriptionLabel.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            var tmpHeight = min(estimatedSize.height, CGFloat(76))
            
            // Adjust height to account for under-estimation (workaround for issue where estimated heights are not accurate)
            if tmpHeight < 35 {
                tmpHeight = tmpHeight * 1.7
            }
            else if tmpHeight < 51 {
                tmpHeight = tmpHeight * 1.2
            }
            
            self.descriptionLabelHeightConstraint.constant = tmpHeight
        }
        else {
            
            self.categoryLabelTopConstraint.constant = 44.0
            
            // Make height of description label 0
            self.descriptionLabelHeightConstraint.constant = 0.0
        }
        
        super.updateConstraints()
    }
}


