//
//  FindStoreViewController.swift
//  Liqbo
//
//  Created by Christopher Ho on 2017-11-15.
//  Copyright © 2017 chovo. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class FindStoreViewController: UIViewController, CLLocationManagerDelegate {

    
    let ACCESS_KEY = "MDpmYjcyMDI5MC1jNjkwLTExZTctODFkNi01Nzk0MGZlMTcyMDE6a2ZTczF5ZXVnckEyMDgwZXBSeDVmZDNpYUVIYk5mTmo0azFC"
    
    var LCBO_SEARCH_ANY_STORE_URL = "https://lcboapi.com/stores?access_key=MDpmYjcyMDI5MC1jNjkwLTExZTctODFkNi01Nzk0MGZlMTcyMDE6a2ZTczF5ZXVnckEyMDgwZXBSeDVmZDNpYUVIYk5mTmo0azFC"
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
       
        
        //removes 1px line from bottom of navigation tab bar
        self.navigationController!.navigationBar.isTranslucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    func getStoreData (url: String, parameters: [String: String]){
        
        //making http request with alamofire
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            
            if response.result.isSuccess{
                
                print("Success, got the store data")
                
                //the JSON() cast comes from SWiftyJSON library
                let storesJSON : JSON = JSON(response.result.value!)
                print(storesJSON["result"].count)
                print(storesJSON["result"][0]["name"])
                //self.updateSearchItemsData(json: storesJSON)
                
            }else{
                print("Error \(response.result.error!)")
            }
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //access the last element of locations array which is usually the most accurate
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            
            print("longitude: \(location.coordinate.longitude), latitude: \(location.coordinate.latitude)")
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat": latitude, "lon" : longitude]
            getStoreData(url: LCBO_SEARCH_ANY_STORE_URL, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    


}
