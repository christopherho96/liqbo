//
//  ViewController.swift
//  Liqbo
//
//  Created by Christopher Ho on 2017-11-10.
//  Copyright © 2017 chovo. All rights reserved.
//

//THIS IS THE SEARCH VIEW CONTROLLER, MESSED UP THE NAMING CONVENTION
//DONT WANT TO RENAME, AFRAID OF BREAKING APP

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD

class HomeViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    var arrayOfSearchItems: [ProductDataModel] = []
    var currentPage = 1
    var numberOfPages: Int = 0;
    var totalItemsToBeLoaded: Int = 0;

    let ACCESS_KEY = "MDpmYjcyMDI5MC1jNjkwLTExZTctODFkNi01Nzk0MGZlMTcyMDE6a2ZTczF5ZXVnckEyMDgwZXBSeDVmZDNpYUVIYk5mTmo0azFC"

    var LCBO_SEARCH_ANY_PRODUCT_URL = "https://lcboapi.com/products?access_key=MDpmYjcyMDI5MC1jNjkwLTExZTctODFkNi01Nzk0MGZlMTcyMDE6a2ZTczF5ZXVnckEyMDgwZXBSeDVmZDNpYUVIYk5mTmo0azFC"
    
    var userSearchText: String = ""
    
    var itemDataToSendToDetailedView : ProductDataModel?

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.estimatedRowHeight = searchTableView.rowHeight
        searchTableView.rowHeight = UITableViewAutomaticDimension
        searchTableView.register(UINib(nibName: "SaleItemCell", bundle: nil), forCellReuseIdentifier: "customSaleItemCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    func getProductData (url: String, parameters: [String: String]){
        
        if currentPage == 1{
            SVProgressHUD.show()
        }
        
        searchTableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //this will clear the search view
        currentPage = 1
        arrayOfSearchItems.removeAll()
        userSearchText = searchBar.text!
        getProductData(url: LCBO_SEARCH_ANY_PRODUCT_URL, parameters: ["q": userSearchText])
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.isUserInteractionEnabled = true
        dismissKeyboard()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchBar.isUserInteractionEnabled = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.isUserInteractionEnabled = true
        dismissKeyboard()
    }
    
    

    //MARK: - JSON Parsing
    /***************************************************************/

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
                    //end of for loop
                }
            
            self.searchTableView.reloadData()
            }else{
                print("error parsing the json stuff")
            }
            
        }else{
            print("Something went wrong updating search item data")
        }
        
        SVProgressHUD.dismiss()
    }
    
    //update UI
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return totalItemsToBeLoaded
  
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
      let cell = tableView.dequeueReusableCell(withIdentifier: "customSaleItemCell", for: indexPath) as! CustomSaleItemCell
        //this if statement ensures that the array element is not out of index
        if indexPath.row <= arrayOfSearchItems.count-1 {
            let item = arrayOfSearchItems[indexPath.row]
            
            cell.itemName.text = item.name
            
            cell.itemPackage.text = item.package
            cell.itemPackage.textColor = UIColor.lightGray

            
            cell.itemPrice.text = "Price: " + String(format: "%.2f", item.price_in_cents / 100)
            cell.itemPrice.textColor = UIColor.lightGray
            cell.itemPrice.sizeToFit()
            
            //set images here
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
                print("hidden")
            }
            
            cell.backgroundColor = .clear
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("This cell from the chat list was selected: \(indexPath.row)")
        itemDataToSendToDetailedView = arrayOfSearchItems[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    
        performSegue(withIdentifier: "segueToDetailedItemView", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = arrayOfSearchItems.count - 10
        if indexPath.row == lastElement {
            getProductData(url: LCBO_SEARCH_ANY_PRODUCT_URL, parameters: ["q": userSearchText, "page" : String(currentPage)])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetailedItemView" {
            
            let secondVC = segue.destination as! DetailedItemViewController
            secondVC.recivedItemData = itemDataToSendToDetailedView
            
        }
    }
}

//extension to help use HEX value colors in UIColor("ff00000")
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}






