//
//  PBProduct.swift
//  Catalog
//
//  Created by Michael Rakowski on 11/5/16.
//  Copyright © 2016 Michael Rakowski. All rights reserved.
//

import Foundation

class PBProduct: NSObject {

    var displayName = ""
    var displayPrice: String?
    var displayDescription: String?
    var imageURL: URL?
    
    
    class func populate(dictionary: Dictionary<String, AnyObject>) -> PBProduct {
        
        let product = PBProduct.init()
        
        // Name
        if let name = dictionary["name"] as? String {
            product.displayName = name
        }
        
        // Display price
        if let displayPrice = dictionary["display_price"] as? String {
            product.displayPrice = displayPrice
        }
        
        // Description
        if let optionsArray = dictionary["flat_preselected_options"] as? Array<AnyObject> {
            if let optionsDictionary = optionsArray.first as? Dictionary<String, AnyObject> {
                if let presentationName = optionsDictionary["option_value_presentation"] as? String {
                    product.displayDescription = presentationName
                }
            }
        }
        
        // Image
        if let imageDictionary = dictionary["primary_image"] as? Dictionary<String, AnyObject> {
            if let imageURLString = imageDictionary["original_url"] as? String {
                let mobileImageURL = imageURLString + "?fit=crop&w=200&max-h=200"
                product.imageURL = URL(string: mobileImageURL)
            }
        }
        
        return product
    }
    
    
}
