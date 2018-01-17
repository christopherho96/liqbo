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
    var currentPage = 1
    var numberOfPages: Int = 0;
    var totalItemsToBeLoaded: Int = 0;
    
    var LCBO_SALES_URL = "https://lcboapi.com/products?access_key=MDpmYjcyMDI5MC1jNjkwLTExZTctODFkNi01Nzk0MGZlMTcyMDE6a2ZTczF5ZXVnckEyMDgwZXBSeDVmZDNpYUVIYk5mTmo0azFC&where=has_limited_time_offer"
    
    @IBOutlet weak var salesCollectionView: UICollectionView!
    
    var allSaleItems: [ProductDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSalesData(url: LCBO_SALES_URL, parameters: ["page": String(currentPage)])
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
    
    func getSalesData (url: String, parameters: [String: String] ){
        
        if currentPage == 1{
            SVProgressHUD.show()
        }
        //making http request with alamofire
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{ (response) in
            
            if response.result.isSuccess{
                
                print("Success, got the products data")
                
                //the JSON() cast comes from SWiftyJSON library
                let salesJSON : JSON = JSON(response.result.value!)
                self.updateSalesData(json: salesJSON)
                
            }else{
                print("Error could not get sales data \(response.result.error!)")
                SVProgressHUD.dismiss()
            }
        }
    }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateSalesData(json: JSON){
       
        let totalItemsReturned = json["pager"]
        numberOfPages = totalItemsReturned["total_pages"].intValue
        totalItemsToBeLoaded = totalItemsReturned["total_record_count"].intValue
        
        if currentPage != numberOfPages{
            
            currentPage = currentPage + 1
            print(currentPage)
            
            if let saleItems = json["result"].array {

                
                for productItem in saleItems{
                    
                    let productDataModel = ProductDataModel()
                    
                    productDataModel.name = productItem["name"].stringValue
                    productDataModel.price_in_cents = productItem["price_in_cents"].floatValue
                    productDataModel.regular_price_in_cents = productItem["regular_price_in_cents"].floatValue
                    productDataModel.origin = productItem["origin"].stringValue
                    productDataModel.has_limited_time_offer = productItem["has_limited_time_offer"].boolValue
                    productDataModel.limited_time_offer_savings_in_cents = productItem["limited_time_offer_savings_in_cents"].floatValue
                    productDataModel.limited_time_offer_ends_on = productItem["limited_time_offer_ends_on"].stringValue
                    productDataModel.package = productItem["package"].stringValue
                    productDataModel.volume_in_milliliters = productItem["volume_in_milliliters"].intValue
                    productDataModel.alcohol_content = productItem["alcohol_content"].floatValue
                    
                    if productItem["image_thumb_url"] != JSON.null{
                        productDataModel.image_thumb_url = productItem["image_thumb_url"].stringValue
                    }
                    
                    if productItem["image_url"] != JSON.null{
                        productDataModel.image_url = productItem["image_url"].stringValue
                    }
                    allSaleItems.append(productDataModel)
                }
                print("items have been added to array")
                self.salesCollectionView.reloadData()
            }else{
                print("error parsing the json stuff")
            }
            
            SVProgressHUD.dismiss()
        }else{
            print("no more pages to load")
        }

    }
    
    //update UI here
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return(totalItemsToBeLoaded)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        //this if statement ensures that the array element is not out of index
        if indexPath.row <= allSaleItems.count-1 {
            let item  = allSaleItems[indexPath.row]
            
            print("\(indexPath.row) and \(item.name)" )

            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "$"+String(format: "%.2f", item.regular_price_in_cents / 100))
        
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
       
            //set image
            let url : URL?
            if item.image_thumb_url != nil {
                url = URL(string: item.image_thumb_url!)
            }else{
                url = URL(string: "https://s3.amazonaws.com/woof.nextglass.co/custom_item_type_images_production/af7e5a9d2a54837d65cae5637975ba8dfa05311f-custom-item-type-image.png?1476365129")
            }
            cell.itemImage.af_setImage(withURL: url!)

            cell.itemDiscount.text = "-$" + String(format: "%.2f", item.limited_time_offer_savings_in_cents / 100)
            cell.itemName.text = item.name
            cell.itemPackage.text = item.package
        
            let currentPrice = "$" + String(format: "%.2f", item.price_in_cents / 100) + " "
            let regularPrice = "$"+String(format: "%.2f", item.regular_price_in_cents / 100)
            let combinedString = currentPrice+regularPrice
            let amountText = NSMutableAttributedString.init(string: combinedString)
            let numberOfCharInPrice = currentPrice.count
        
            amountText.addAttribute(NSAttributedStringKey.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.styleThick.rawValue),  range: NSMakeRange(numberOfCharInPrice, regularPrice.count))
            amountText.addAttribute(NSAttributedStringKey.strikethroughColor, value: UIColor.lightGray, range: NSMakeRange(numberOfCharInPrice, regularPrice.count))
            amountText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray , range: NSMakeRange(numberOfCharInPrice, regularPrice.count))
            cell.itemPrice.attributedText = amountText
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemDataToSendToDetailedView = allSaleItems[indexPath.row]
        print("This cell from the chat list was selected: \(indexPath.row)")
        collectionView.deselectItem(at: indexPath, animated: true)
        performSegue(withIdentifier: "segueSaleItem", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastElement = allSaleItems.count - 10
        if indexPath.row == lastElement {
            getSalesData(url: LCBO_SALES_URL, parameters: ["page" : String(currentPage)])
        }
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




