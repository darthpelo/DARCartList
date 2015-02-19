//
//  ViewController.swift
//  DARCartList
//
//  Created by Alessio Roberto on 19/02/15.
//  Copyright (c) 2015 Alessio Roberto. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let reuseIdentifier = "ProductCell"
    private var listResult = [Product]()
    private var selectedProduct: Product?
    
    func productForIndexPath(indexPath: NSIndexPath) -> Product {
        return listResult[indexPath.row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Cart"
        
        requestCartList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Attention", message: "Connection error occurred", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            println(action)
        }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: { () -> Void in
            
        })
    }
    
    private func requestCartList() {
        DARCartListAPI.sharedInstance.requestCartItems().continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock: {
            (task) -> AnyObject! in
            if (task.error() != nil) {
                self.showAlert()
            } else {
                self.listResult = task.result() as! [(Product)]
                
                self.collectionView?.reloadData()
            }
            
            return nil
        })
    }
    
    @IBAction func refreshList(sender: UIBarButtonItem) {
        // TODO: add pull to refresh function to the CollectionView
        
        requestCartList()
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ProductDetailSegue" {
            let detail = segue.destinationViewController as! DARProductDetailViewController
            detail.product = selectedProduct
        }
    }
    
    // MARK: UICollectionView
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listResult.count
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            var cellSize: CGSize;
            let collectionViewWidth = collectionView.frame.size.width;
            
            let newCellWidth = collectionViewWidth / 2
            cellSize = CGSizeMake(newCellWidth - 1.0, newCellWidth - 1.0);
            return cellSize;
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // TODO: improve CollectionViewCell cache managment
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ProductCell
        
        let product = productForIndexPath(indexPath)
        
        cell.activityIndicator.stopAnimating()
        
        cell.productNameLabel.text = product.name
        
        let price = product.price / 100
        
        cell.productPriceLabel.text = "\(price)€"
        
        if product.image != nil {
            cell.productImage.image = product.image
            return cell
        }
        
        cell.activityIndicator.startAnimating()
        
        product.loadImage { (productPhoto, error) -> Void in
            
            cell.activityIndicator.stopAnimating()
            
            if error != nil {
                return
            }
            
            if productPhoto.image == nil {
                return
            }
            
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ProductCell {
                cell.productImage.image = product.image
            }
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedProduct = self.productForIndexPath(indexPath)
        self.performSegueWithIdentifier("ProductDetailSegue", sender: self)
    }

}

