//
//  HTTPClient.swift
//  Catalog
//
//  Created by Michael Rakowski on 11/4/16.
//  Copyright © 2016 Michael Rakowski. All rights reserved.
//

import Foundation

class HTTPClient: NSObject {
    
    class func getCategories(completion: @escaping (PBCategory?) -> Void) {
    
        let urlString = ""
        let url : URL! = URL(string: urlString)
        //print(url)
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil )
        session.dataTask(with: request) {(data, response, error) -> Void in
            
            if let data = data {
                
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    
                    if let jsonResult = json as? Dictionary<String, AnyObject> {
                        
                        let tmpCategory = PBCategory.populate(dictionary: jsonResult)
                        completion(tmpCategory)
                    }
                }
                else {
                    completion(nil)
                }
            }
            else {
                completion(nil)
            }
        }.resume()
    }

}
