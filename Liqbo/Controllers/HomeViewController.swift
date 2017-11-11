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

    @IBOutlet weak var searchBar: UISearchBar!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBar.delegate = self
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

    }

    //MARK: - JSON Parsing
    /***************************************************************/



}

