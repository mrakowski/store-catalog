//
//  PBCategory.swift
//  Catalog
//
//  Created by Michael Rakowski on 11/4/16.
//  Copyright © 2016 Michael Rakowski. All rights reserved.
//

import Foundation

class PBCategory: NSObject {

    var displayName = ""
    var displayDescription = ""
    var imageURL: URL?
    var childCategories = [PBCategory]()
    var products = [PBProduct]()
    
    override init() {
        super.init()
    }
    
    class func populate(dictionary: Dictionary<String, AnyObject>) -> PBCategory {
    
        let category = PBCategory.init()
        
        // Name
        if let name = dictionary["name"] as? String {
            category.displayName = name
        }
        
        // Description
        if let description = dictionary["description"] as? String {
            
            var trimmedString = description.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            trimmedString = trimmedString.replacingOccurrences(of: "\\", with: "",  options: NSString.CompareOptions.literal, range: nil)
            category.displayDescription = trimmedString
        }
        
        // Image URL
        if let imageDictionary = dictionary["primary_image"] as? Dictionary<String, AnyObject> {
            if let imageURLString = imageDictionary["original_url"] as? String {
                let mobileImageURL = imageURLString + "?fit=crop&w=400&max-h=200"
                category.imageURL = URL(string: mobileImageURL)
            }
        }
        
        // Products (category items)
        let items = dictionary["category_items"]
        if let itemArray = items as? Array<AnyObject> {
            for item in itemArray {
                if let itemD = item as? Dictionary<String, AnyObject> {
                    let tmpItem = PBProduct.populate(dictionary: itemD)
                    category.products.append(tmpItem)
                }
            }
        }
        
        // Get children categories
        let children = dictionary["children"]
        if let cArray = children as? Array<AnyObject> {
            for child in cArray {
                if let childD = child as? Dictionary<String, AnyObject> {
                    // Populate child categories
                    let childCategory = PBCategory.populate(dictionary: childD)
                    category.childCategories.append(childCategory)
                }
            }
        }
        
        return category
    }
}
