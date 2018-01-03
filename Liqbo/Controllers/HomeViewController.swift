//
//  ViewController.swift
//  Liqbo
//
//  Created by Christopher Ho on 2017-11-10.
//  Copyright © 2017 chovo. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD

class HomeViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    var arrayOfSearchItems: [ProductDataModel] = []

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
        
        SVProgressHUD.show()
        
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
                print("Error \(response.result.error!)")
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //this will clear the search view

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
        
        if let productItems = json["result"].array {
            
            for productItem in productItems{
                
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

                arrayOfSearchItems.append(productDataModel)
            }
            self.searchTableView.reloadData()
            
        }else{
            print("error parsing the json stuff")
        }
        
        SVProgressHUD.dismiss()
    }
    
    //update UI
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrayOfSearchItems.count
  
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      let cell = tableView.dequeueReusableCell(withIdentifier: "customSaleItemCell", for: indexPath) as! CustomSaleItemCell
        
        let item = arrayOfSearchItems[indexPath.row]
        
        cell.itemName.text = item.name
        
        cell.itemPackage.text = item.package
        cell.itemPackage.textColor = UIColor.lightGray

        
        cell.itemPrice.text = "Price: " + String(format: "%.2f", item.price_in_cents / 100)
        cell.itemPrice.textColor = UIColor.lightGray
        cell.itemPrice.sizeToFit()
        
        cell.itemThumbnail.af_setImage(withURL: item.image_thumb_url)
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
        return cell
    }
    
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("This cell from the chat list was selected: \(indexPath.row)")
        itemDataToSendToDetailedView = arrayOfSearchItems[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    
        performSegue(withIdentifier: "segueToDetailedItemView", sender: self)
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




