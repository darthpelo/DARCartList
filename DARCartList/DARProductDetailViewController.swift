//
//  DARProductDetailViewController.swift
//  DARCartList
//
//  Created by Alessio Roberto on 17/02/15.
//  Copyright (c) 2015 Alessio Roberto. All rights reserved.
//

import UIKit

class DARProductDetailViewController: UIViewController {
    var product: Product?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = product?.name
        
        imageView.image = product?.image
        
        if (product?.prodId != nil) {
            DARCartListAPI.sharedInstance.requestItemDetail().continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock: { (task) -> AnyObject! in
                if task.error() != nil {
                    let result = task.result() as! Product
                    
                    self.descriptionText.text = result.description
                }
                
                return nil
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
