//
//  ViewController.swift
//  Catalog
//
//  Created by Michael Rakowski on 11/4/16.
//  Copyright © 2016 Michael Rakowski. All rights reserved.
//

import UIKit
import AlamofireImage

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reloadButton: UIButton!
    var category: PBCategory?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.category != nil {
            self.title = self.category!.displayName
        }
        else {
            
            self.title = "Tops"
            self.loadFromServer()
        }
    }
    
    // MARK: Data
    
    func loadFromServer() {
    
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
        self.tableView.isHidden = true
        
        self.reloadButton.isHidden = true
        
        HTTPClient.getCategories() {
            (tmpCat: PBCategory?) in
            
            if tmpCat != nil {
                self.title = tmpCat!.displayName
                self.category = tmpCat!
                
                DispatchQueue.main.async {
                    
                    self.activityIndicator.stopAnimating()
                    
                    self.tableView?.reloadData()
                    self.tableView.isHidden = false
                    
                    // Fade in table view
                    self.tableView.alpha = 0
                    UIView.animate(withDuration: 0.3, animations: {
                        self.tableView.alpha = 1
                    })
                }
            }
            else {
                
                self.activityIndicator.stopAnimating()
                
                // Show the reload button
                self.reloadButton.isHidden = false
                self.reloadButton.addTarget(self, action: #selector(self.loadFromServer), for: .touchUpInside)
            }
        }
    }
    
    func showProducts() -> Bool {
    
        var tmpShowProducts = false
        if self.category != nil && self.category!.products.count > 0 {
            tmpShowProducts = true
        }
        
        return tmpShowProducts
    }

    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
        // Products
        if self.showProducts() == true {
        
            let productCell: ProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell
            cell = productCell
            
            if let product = self.category?.products[indexPath.row] {
                productCell.nameLabel.text = product.displayName
                productCell.descriptionLabel.text = product.displayDescription
                productCell.priceLabel.text = product.displayPrice
                
                productCell.displayImageView.image = nil
                if product.imageURL != nil {
                    productCell.displayImageView.af_setImage(withURL: product.imageURL!)
                }
            }
        }
            
        // Child Categories
        else {
            
            let categoryCell: CategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
            cell = categoryCell
            
            if let childCategory = self.category?.childCategories[indexPath.row] {
                
                categoryCell.categoryLabel?.text = childCategory.displayName
                categoryCell.descriptionLabel?.text = childCategory.displayDescription
                
                categoryCell.displayImageView.image = nil
                
                // Set image URL
                var tmpImageURL: URL? = nil
                if childCategory.imageURL != nil {
                    tmpImageURL = childCategory.imageURL!
                }
                else if self.category != nil && self.category?.imageURL != nil  {
                    tmpImageURL = self.category!.imageURL!
                }
                if tmpImageURL != nil {
                    let filter = CircleFilter()
                    categoryCell.displayImageView.af_setImage(withURL: tmpImageURL!, filter: filter, imageTransition: .crossDissolve(0.2))
                }
                
                // Show red circle if there is no content available
                let showRedCircle = childCategory.products.count == 0 && childCategory.childCategories.count == 0
                categoryCell.redCircleView.isHidden = !showRedCircle
                categoryCell.displayImageView.isHidden = showRedCircle
                
                categoryCell.setNeedsUpdateConstraints()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rows = 0
        
        if self.category != nil && self.category!.products.count > 0 {
            rows = self.category!.products.count
        }
        
        else if let childCategories = self.category?.childCategories {
            rows = childCategories.count
        }
        
        return rows
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height = CGFloat(130.0)
        
        if self.showProducts() == false {
            if let childCategory = self.category?.childCategories[indexPath.row] {
                if childCategory.displayDescription == "" {
                    height = CGFloat(110.0)
                }
            }
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselect cell
        self.tableView?.deselectRow(at: indexPath, animated: true)
        
        if self.showProducts() == true {
            return
        }
        
        let category = self.category?.childCategories[indexPath.row]
        
        // Show products (if there are any)
        if category != nil && category!.products.count > 0 {
            
            // Michael TODO: configure show products
            
            //self.performSegue(withIdentifier: "categoriesToProduct", sender: self)
            
            let childCategoryViewController = self.storyboard!.instantiateViewController(withIdentifier: "categoryViewController") as! CategoryViewController
            childCategoryViewController.category = category
            self.navigationController?.pushViewController(childCategoryViewController, animated: true)
            
        }
        
        // Show child categories (if there are any)
        else if let childCategories = category?.childCategories {
            if childCategories.count > 0 {
                let childCategoryViewController = self.storyboard!.instantiateViewController(withIdentifier: "categoryViewController") as! CategoryViewController
                childCategoryViewController.category = category
                self.navigationController?.pushViewController(childCategoryViewController, animated: true)
            }
        }
    }
}

