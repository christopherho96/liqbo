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

class SalesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    
    var itemDataToSendToDetailedView : ProductDataModel?
    
    var LCBO_SALES_URL = "https://lcboapi.com/products?access_key=MDpmYjcyMDI5MC1jNjkwLTExZTctODFkNi01Nzk0MGZlMTcyMDE6a2ZTczF5ZXVnckEyMDgwZXBSeDVmZDNpYUVIYk5mTmo0azFC&where=has_limited_time_offer"
    
    @IBOutlet weak var salesTableView: UITableView!
    

    
    
    var numberOfSaleItems = 0
    var allSaleItems: [ProductDataModel] = []
    


    override func viewDidLoad() {
        super.viewDidLoad()
        

        salesTableView.delegate = self
        salesTableView.dataSource = self
        salesTableView.register(UINib(nibName: "SaleItemCell", bundle: nil), forCellReuseIdentifier: "customSaleItemCell")
        salesTableView.separatorStyle = .singleLine
        
                getSalesData(url: LCBO_SALES_URL)
        
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
            
            for saleItem in saleItems{
                
                let productDataModel = ProductDataModel()
                
                productDataModel.name = saleItem["name"].stringValue
                productDataModel.id = saleItem["id"].intValue
                productDataModel.price_in_cents = saleItem["price_in_cents"].floatValue
                productDataModel.primary_category = saleItem["primary_category"].stringValue
                productDataModel.has_limited_time_offer = saleItem["has_limited_time_offer"].boolValue
                productDataModel.limited_time_offer_savings_in_cents = saleItem["limited_time_offer_savings_in_cents"].floatValue
                productDataModel.limited_time_offer_ends_on = saleItem["limited_time_offer_ends_on"].stringValue
                productDataModel.package = saleItem["package"].stringValue
                productDataModel.total_package_units = saleItem["total_package_units"].intValue
                productDataModel.volume_in_milliliters = saleItem["volume_in_milliliters"].intValue
                productDataModel.alcohol_content = saleItem["alcohol_content"].floatValue
                productDataModel.style = saleItem["style"].stringValue
                productDataModel.description = saleItem["description"].stringValue
                productDataModel.origin = saleItem["origin"].stringValue
                
                if saleItem["image_thumb_url"] != JSON.null{
                    productDataModel.image_thumb_url = saleItem["image_thumb_url"].url!
                }
                
                if saleItem["image_url"] != JSON.null {
                    productDataModel.image_url = saleItem["image_url"].url!
                }
                allSaleItems.append(productDataModel)
            }
            self.salesTableView.reloadData()
        }else{
            print("error parsing the json stuff")
        }
        
        SVProgressHUD.dismiss()
    }
    
    //update UI here
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return(allSaleItems.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customSaleItemCell", for: indexPath) as! CustomSaleItemCell
        
        cell.itemName.text = allSaleItems[indexPath.row].name

        cell.itemPackage.text = allSaleItems[indexPath.row].package

        cell.itemPrice.text = "Price: " + String(format: "%.2f", allSaleItems[indexPath.row].price_in_cents / 100)
        
        cell.itemSaleUntil.text = "Sale ends: \(allSaleItems[indexPath.row].limited_time_offer_ends_on)"
        
        cell.itemSave.applyDesign()
        cell.itemSave.text =  "-" + String(format: "%.2f", allSaleItems[indexPath.row].limited_time_offer_savings_in_cents / 100)
        cell.itemSave.layer.borderWidth = 1
        cell.itemSave.layer.borderColor = UIColor.red.cgColor

        
        cell.itemThumbnail.af_setImage(withURL: allSaleItems[indexPath.row].image_thumb_url)
        cell.itemThumbnail.clipsToBounds = true
        cell.itemThumbnail.layer.cornerRadius = 8;
        
        cell.backgroundColor = .clear
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemDataToSendToDetailedView = allSaleItems[indexPath.row]
        print("This cell from the chat list was selected: \(indexPath.row)")
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




