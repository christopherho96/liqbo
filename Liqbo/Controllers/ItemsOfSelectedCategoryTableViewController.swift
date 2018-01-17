//
//  ItemsOfSelectedCategoryTableViewController.swift
//  Liqbo
//
//  Created by Christopher Ho on 2018-01-08.
//  Copyright © 2018 chovo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ItemsOfSelectedCategoryTableViewController: UITableViewController {
    
    var selectedCategory: String = ""
    var previousSelectedCategory: String = ""
    var apiUrl = "https://lcboapi.com/products?access_key=MDpmYjcyMDI5MC1jNjkwLTExZTctODFkNi01Nzk0MGZlMTcyMDE6a2ZTczF5ZXVnckEyMDgwZXBSeDVmZDNpYUVIYk5mTmo0azFC"
    var arrayOfSearchItems: [ProductDataModel] = []
    var itemToSendToDetailedView: ProductDataModel?
    
    var currentPage = 1
    var numberOfPages: Int = 0;
    var totalItemsToBeLoaded: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        print(selectedCategory)
        tableView.register(UINib(nibName: "SaleItemCell", bundle: nil), forCellReuseIdentifier: "customSaleItemCell")
        if selectedCategory != previousSelectedCategory  {
            print(previousSelectedCategory)
            previousSelectedCategory = selectedCategory
            print("getting product data")
            getProductData(url: apiUrl, parameters: ["q": selectedCategory])
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return totalItemsToBeLoaded
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("This cell from the chat list was selected: \(indexPath.row)")
        itemToSendToDetailedView = arrayOfSearchItems[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "segueToDetailedItemView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetailedItemView" {
            
            let secondVC = segue.destination as! DetailedItemViewController
            secondVC.recivedItemData = itemToSendToDetailedView
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customSaleItemCell", for: indexPath) as! CustomSaleItemCell
        
        if indexPath.row <= arrayOfSearchItems.count-1 {
        
            let item = arrayOfSearchItems[indexPath.row]
            
            cell.itemName.text = item.name
            
            cell.itemPackage.text = item.package
            cell.itemPackage.textColor = UIColor.lightGray
            
            
            cell.itemPrice.text = "Price: " + String(format: "%.2f", item.price_in_cents / 100)
            cell.itemPrice.textColor = UIColor.lightGray
            cell.itemPrice.sizeToFit()
            
            let url : URL?
            if item.image_thumb_url != nil {
                url = URL(string: item.image_thumb_url!)
            }else{
                url = URL(string: "https://s3.amazonaws.com/woof.nextglass.co/custom_item_type_images_production/af7e5a9d2a54837d65cae5637975ba8dfa05311f-custom-item-type-image.png?1476365129")
            }
            cell.itemThumbnail.af_setImage(withURL: url!)
            
            cell.itemThumbnail.clipsToBounds = true
            cell.itemThumbnail.layer.cornerRadius = 8;
            
            let onSale = item.has_limited_time_offer
            
            if onSale == true{
                cell.itemSaleUntil.text = "Sale ends: \(item.limited_time_offer_ends_on)"
                cell.itemSave.text = "Sale!"
                cell.itemSave.isHidden = false
            }
            else{
                cell.itemSaleUntil.text = "Currently no promotion"
                cell.itemSave.isHidden = true
            }
            
            cell.backgroundColor = .clear
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = arrayOfSearchItems.count - 10
        if indexPath.row == lastElement {
            getProductData(url: apiUrl, parameters: ["q": selectedCategory, "page" : String(currentPage)])
        }
    }
    
    func getProductData (url: String, parameters: [String: String]){
        
        if currentPage == 1{
            SVProgressHUD.show()
        }
        
        //making http request with alamofire
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            
            if response.result.isSuccess{
                
                print("Success, got the products data")
                
                //the JSON() cast comes from SWiftyJSON library
                let productsJSON : JSON = JSON(response.result.value!)
                print(productsJSON["result"].count)
                print(productsJSON["result"][0]["name"])
                self.updateSearchItemsData(json: productsJSON)
                
            }else{
                print("Error getting product data \(response.result.error!)")
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func updateSearchItemsData(json: JSON){
        
        let totalItemsReturned = json["pager"]
        numberOfPages = totalItemsReturned["total_pages"].intValue
        totalItemsToBeLoaded = totalItemsReturned["total_record_count"].intValue
        print(totalItemsToBeLoaded)
        
        if currentPage != numberOfPages || currentPage == 1{
            
            currentPage = currentPage + 1
            print(currentPage)
        
            if let productItems = json["result"].array {
                
                for productItem in productItems{
                    
                    let productDataModel = ProductDataModel()
                    
                    productDataModel.name = productItem["name"].stringValue
                    productDataModel.price_in_cents = productItem["price_in_cents"].floatValue
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
                    
                    if productItem["image_url"] != JSON.null {
                        productDataModel.image_url = productItem["image_url"].stringValue
                    }
                    
                    arrayOfSearchItems.append(productDataModel)
                }//end of for loop
             
                print("reload")
            self.tableView.reloadData()
                
            }else{
                print("error parsing the json stuff")
            }
        }else{
            print("Something went wrong updating search item data")
        }
        SVProgressHUD.dismiss()
    }

}
