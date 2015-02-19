//
//  DARNetworkManager.swift
//  DARCartList
//
//  Created by Alessio Roberto on 16/02/15.
//  Copyright (c) 2015 Alessio Roberto. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    private let baseUrl = "https://s3-eu-west-1.amazonaws.com/developer-application-test/cart/"
    private let cartListPath = "list"
    private let detailPath = "detail"
    
    class var sharedInstance: NetworkManager {
        struct Singleton {
            static let instance = NetworkManager()
        }
        return Singleton.instance
    }
    
    func getCartList() -> BFTask {
        var task = BFTaskCompletionSource()
        
        // TODO: connection check
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET(baseUrl+cartListPath, parameters: nil, success: {
            (operation, responseObject) -> Void in
            task.setResult(responseObject["products"])
            }) { (operation, error) -> Void in
                task.setError(error)
        }
        
        return task.task
    }
    
    func getProductDetail(productID: String) -> BFTask {
        var task = BFTaskCompletionSource()
        
        // TODO: connection check
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET(baseUrl+productID+detailPath,
            parameters: nil,
            success: { (operation, responseObject) -> Void in
                task.setResult(responseObject)
        }) { (operation, error) -> Void in
            task.setError(error)
        }
        
        return task.task
    }
   
}
