//
//  DARCartListAPI.swift
//  DARCartList
//
//  Created by Alessio Roberto on 16/02/15.
//  Copyright (c) 2015 Alessio Roberto. All rights reserved.
//

import UIKit

class DARCartListAPI: NSObject {
    class var sharedInstance: DARCartListAPI {
        struct Singleton {
            static let instance = DARCartListAPI()
        }
        return Singleton.instance
    }
    
    func requestCartItems() -> BFTask {
        var task = BFTaskCompletionSource()
        
        NetworkManager.sharedInstance.getCartList().continueWithSuccessBlock {
            (result) -> AnyObject! in
            
            var list = result.result() as! [AnyObject]
            var listResult = [Product]()
            
            // TODO: improve Product init
            
            for prod in list {
                var newProd = Product(
                    prodID: prod["product_id"] as! String,
                    name: prod["name"] as! String,
                    price: prod["price"] as! Float32,
                    image: prod["image"] as! String
                )
                
                listResult.append(newProd)
            }
            
            task.setResult(listResult)
            
            return nil
        }
        
        return task.task
    }
    
    func requestItemDetail() -> BFTask {
        var task = BFTaskCompletionSource()
        
        NetworkManager.sharedInstance.getCartList().continueWithSuccessBlock {
            (result) -> AnyObject! in
            
            var list = result.result() as! [AnyObject]
            var listResult = [Product]()
            
            // TODO: improve Product init
            
            for prod in list {
                var newProd = Product(
                    prodID: prod["product_id"] as! String,
                    name: prod["name"] as! String,
                    price: prod["price"] as! Float32,
                    image: prod["image"] as! String
                )
                
                newProd.description = prod["description"] as? String
                
                listResult.append(newProd)
            }
            
            task.setResult(listResult)
            
            return nil
        }
        
        return task.task
    }
}
