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
        // Do any additional setup after loading the view, typically from a nib.
        
        
        searchBar.delegate = self
        searchTableView.tableHeaderView = searchBar
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UINib(nibName: "ProductItemCell", bundle: nil), forCellReuseIdentifier: "customProductItemCell")
        
        
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //view.addGestureRecognizer(tap)
        
        //self.navigationController!.navigationBar.isTranslucent = false
    
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
        
        if let saleItems = json["result"].array {
            
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

                
                
                //there may be an error here since it might unwrap a nil
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
        
      let cell = tableView.dequeueReusableCell(withIdentifier: "customProductItemCell", for: indexPath) as! CustomProductItemCell
        
        cell.productName.text = arrayOfSearchItems[indexPath.row].name
        cell.productName.sizeToFit()
        
        cell.productPackage.text = arrayOfSearchItems[indexPath.row].package
        cell.productPackage.textColor = UIColor.lightGray
        cell.productPackage.sizeToFit()
        
        cell.productPrice.text = "Price: " + String(format: "%.2f", arrayOfSearchItems[indexPath.row].price_in_cents / 100)
        cell.productPrice.textColor = UIColor.lightGray
        cell.productPrice.sizeToFit()
        
        cell.productImage.af_setImage(withURL: arrayOfSearchItems[indexPath.row].image_thumb_url)
        cell.productImage.clipsToBounds = true
        cell.productImage.layer.cornerRadius = 8;

        cell.backgroundColor = .clear
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("This cell from the chat list was selected: \(indexPath.row)")
        itemDataToSendToDetailedView = arrayOfSearchItems[indexPath.row]
    
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




