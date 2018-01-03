//
//  SalesViewController.swift
//  Liqbo
//
//  Created by Christopher Ho on 2017-11-11.
//  Copyright © 2017 chovo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import SVProgressHUD

class SalesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    var itemDataToSendToDetailedView : ProductDataModel?
    
    var LCBO_SALES_URL = "https://lcboapi.com/products?access_key=MDpmYjcyMDI5MC1jNjkwLTExZTctODFkNi01Nzk0MGZlMTcyMDE6a2ZTczF5ZXVnckEyMDgwZXBSeDVmZDNpYUVIYk5mTmo0azFC&where=has_limited_time_offer"
    
    @IBOutlet weak var salesCollectionView: UICollectionView!
    
    var numberOfSaleItems = 0
    var allSaleItems: [ProductDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSalesData(url: LCBO_SALES_URL)
        
        let itemSize = UIScreen.main.bounds.width/2 - 35
        
        let sectionInset = (UIScreen.main.bounds.width/2) / 8

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize, height: 185)
        layout.sectionInset.top = sectionInset
        layout.sectionInset.left = sectionInset
        layout.sectionInset.right = sectionInset
        layout.sectionInset.bottom = sectionInset
        layout.minimumLineSpacing = 25
        
        salesCollectionView.collectionViewLayout = layout
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    func getSalesData (url: String){
        SVProgressHUD.show()
        //making http request with alamofire
        
        Alamofire.request(url).responseJSON { (response) in
            
            if response.result.isSuccess{
                
                print("Success, got the products data")
                
                //the JSON() cast comes from SWiftyJSON library
                let salesJSON : JSON = JSON(response.result.value!)
                self.updateSalesData(json: salesJSON)
                
            }else{
                print("Error \(response.result.error!)")
            }
        }
    }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateSalesData(json: JSON){
       
        if let saleItems = json["result"].array {
            
            numberOfSaleItems = json["result"].count
            print(" Number of items on sale: \(numberOfSaleItems)")
            
            for productItem in saleItems{
                
                let productDataModel = ProductDataModel(name: productItem["name"].stringValue,
                                                        price_in_cents: productItem["price_in_cents"].floatValue,
                                                        primary_category: productItem["primary_category"].stringValue,
                                                        origin: productItem["origin"].stringValue,
                                                        has_limited_time_offer: productItem["has_limited_time_offer"].boolValue,
                                                        limited_time_offer_savings_in_cents: productItem["limited_time_offer_savings_in_cents"].floatValue,
                                                        limited_time_offer_ends_on: productItem["limited_time_offer_ends_on"].stringValue,
                                                        description: productItem["description"].stringValue,
                                                        package: productItem["package"].stringValue,
                                                        total_package_units: productItem["total_package_units"].intValue,
                                                        volume_in_milliliters: productItem["volume_in_milliliters"].intValue,
                                                        alcohol_content: productItem["alcohol_content"].floatValue,
                                                        style: productItem["style"].stringValue)
                
                
                if productItem["image_thumb_url"] != JSON.null{
                    productDataModel.image_thumb_url = productItem["image_thumb_url"].url!
                }
                
                if productItem["image_url"] != JSON.null {
                    productDataModel.image_url = productItem["image_url"].url!
                }
                
                productDataModel.regular_price_in_cents = productItem["regular_price_in_cents"].floatValue
                
                allSaleItems.append(productDataModel)
            }
            self.salesCollectionView.reloadData()
        }else{
            print("error parsing the json stuff")
        }
        
        SVProgressHUD.dismiss()
    }
    
    //update UI here
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return(allSaleItems.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "$"+String(format: "%.2f", allSaleItems[indexPath.row].regular_price_in_cents / 100))
        
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
       
        
        cell.itemImage.af_setImage(withURL: allSaleItems[indexPath.row].image_thumb_url)
        cell.itemDiscount.text = "-$" + String(format: "%.2f", allSaleItems[indexPath.row].limited_time_offer_savings_in_cents / 100)
        cell.itemName.text = allSaleItems[indexPath.row].name
        cell.itemPackage.text = allSaleItems[indexPath.row].package
        
        let currentPrice = "$" + String(format: "%.2f", allSaleItems[indexPath.row].price_in_cents / 100) + " "
        let regularPrice = "$"+String(format: "%.2f", allSaleItems[indexPath.row].regular_price_in_cents / 100)
        let combinedString = currentPrice+regularPrice
        let amountText = NSMutableAttributedString.init(string: combinedString)
        let numberOfCharInPrice = currentPrice.count
        print(numberOfCharInPrice)
        
        amountText.addAttribute(NSAttributedStringKey.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.styleThick.rawValue),  range: NSMakeRange(numberOfCharInPrice, regularPrice.count))
        amountText.addAttribute(NSAttributedStringKey.strikethroughColor, value: UIColor.lightGray, range: NSMakeRange(numberOfCharInPrice, regularPrice.count))
        amountText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray , range: NSMakeRange(numberOfCharInPrice, regularPrice.count))
        cell.itemPrice.attributedText = amountText
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemDataToSendToDetailedView = allSaleItems[indexPath.row]
        print("This cell from the chat list was selected: \(indexPath.row)")
        collectionView.deselectItem(at: indexPath, animated: true)
        performSegue(withIdentifier: "segueSaleItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueSaleItem" {
            
            let secondVC = segue.destination as! DetailedItemViewController
            secondVC.recivedItemData = itemDataToSendToDetailedView
            
        }
    }
}

extension UILabel{
    func applyDesign(){
        self.layer.cornerRadius = self.frame.height/2
    }
}




