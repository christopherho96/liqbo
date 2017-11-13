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

class HomeViewController: UIViewController, UISearchBarDelegate {
    
    
    let ACCESS_KEY = "MDpmYjcyMDI5MC1jNjkwLTExZTctODFkNi01Nzk0MGZlMTcyMDE6a2ZTczF5ZXVnckEyMDgwZXBSeDVmZDNpYUVIYk5mTmo0azFC"

    var LCBO_SEARCH_ANY_PRODUCT_URL = "https://lcboapi.com/products?access_key=MDpmYjcyMDI5MC1jNjkwLTExZTctODFkNi01Nzk0MGZlMTcyMDE6a2ZTczF5ZXVnckEyMDgwZXBSeDVmZDNpYUVIYk5mTmo0azFC"
    
    var userSearchText: String = ""

    @IBOutlet weak var searchBar: UISearchBar!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBar.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    
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
        
        //making http request with alamofire
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            
            if response.result.isSuccess{
                
                print("Success, got the products data")
                
                //the JSON() cast comes from SWiftyJSON library
                let productsJSON : JSON = JSON(response.result.value!)
                print(productsJSON["result"][0]["name"])
                
            }else{
                print("Error \(response.result.error!)")
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        userSearchText = searchBar.text!
        getProductData(url: LCBO_SEARCH_ANY_PRODUCT_URL, parameters: ["q": userSearchText])
        dismissKeyboard()
    }
    
    

    //MARK: - JSON Parsing
    /***************************************************************/



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


