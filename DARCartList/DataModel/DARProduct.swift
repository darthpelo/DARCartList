//
//  DARProduct.swift
//  DARCartList
//
//  Created by Alessio Roberto on 17/02/15.
//  Copyright (c) 2015 Alessio Roberto. All rights reserved.
//

import UIKit

class Product: Equatable {
    var name: String
    var price: Float32
    var prodId: String
    var imageURL: String
    var image: UIImage?
    var description: String?
    
    init (prodID:String, name: String, price: Float32, image: String) {
        self.prodId = prodID
        self.name = name
        self.price = price
        self.imageURL = image
    }
    
    func prodImageURL() -> NSURL {
        return NSURL(string: imageURL)!
    }
    
    func loadImage(completion: (productPhoto:Product, error: NSError?) -> Void) {
        let loadURL = prodImageURL()
        
        let loadRequest = NSURLRequest(URL:loadURL)
        NSURLConnection.sendAsynchronousRequest(loadRequest,
            queue: NSOperationQueue.mainQueue()) {
                response, data, error in
                
                if error != nil {
                    completion(productPhoto: self, error: error)
                    return
                }
                
                if data != nil {
                    let returnedImage = UIImage(data: data)
                    self.image = returnedImage
                    completion(productPhoto: self, error: nil)
                    return
                }
                
                completion(productPhoto: self, error: nil)
        }
    }
}

func == (lhs: Product, rhs: Product) -> Bool {
    return lhs.prodId == rhs.prodId
}