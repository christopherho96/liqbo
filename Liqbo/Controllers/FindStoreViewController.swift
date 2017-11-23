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

class FindStoreViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    var arrayOfSearchStores: [StoreDateModel] = []
    
    @IBOutlet weak var storeTableView: UITableView!
    
    @IBOutlet weak var storeSearchBar: UISearchBar!
    

    @IBOutlet weak var findStoresInMyLocationButton: UIButton!
    
    @IBAction func findStoresInMyLocationTapped(_ sender: Any) {
        arrayOfSearchStores.removeAll()
        currentSearchState = false
        changeButtonProperties(currentState: false)
        getStoreData(url: LCBO_SEARCH_ANY_STORE_URL, parameters: params)
    }
    
    var currentSearchState = false
    
    var dayOfTheWeek = ""
    var openingHours = ""
    var closingHours = ""
    
    let ACCESS_KEY = "MDpmYjcyMDI5MC1jNjkwLTExZTctODFkNi01Nzk0MGZlMTcyMDE6a2ZTczF5ZXVnckEyMDgwZXBSeDVmZDNpYUVIYk5mTmo0azFC"
    
    var LCBO_SEARCH_ANY_STORE_URL = "https://lcboapi.com/stores?access_key=MDpmYjcyMDI5MC1jNjkwLTExZTctODFkNi01Nzk0MGZlMTcyMDE6a2ZTczF5ZXVnckEyMDgwZXBSeDVmZDNpYUVIYk5mTmo0azFC"
    
    let locationManager = CLLocationManager()
    var params = [String : String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setOpenAndCloseHoursToday()
        
        findStoresInMyLocationButton.isEnabled = false
        findStoresInMyLocationButton.backgroundColor = UIColor(hex: "0096c1")
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        storeTableView.delegate = self
        storeSearchBar.delegate = self
        storeTableView.dataSource = self
        storeTableView.register(UINib(nibName: "StoreCell", bundle: nil), forCellReuseIdentifier: "customStoreCell")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
       // storeTableView.rowHeight = UITableViewAutomaticDimension
       // storeTableView.estimatedRowHeight = 100

        //removes 1px line from bottom of navigation tab bar
        self.navigationController!.navigationBar.isTranslucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        currentSearchState = true
        changeButtonProperties(currentState: currentSearchState)
        
        //this will clear the search view
        arrayOfSearchStores.removeAll()
        let userSearchText = storeSearchBar.text!
        getStoreData(url: LCBO_SEARCH_ANY_STORE_URL, parameters: ["geo": userSearchText])
        dismissKeyboard()
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
                self.updateStoreData(json: storesJSON)
                
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
            
            params  = ["lat": latitude, "lon" : longitude]
            getStoreData(url: LCBO_SEARCH_ANY_STORE_URL, parameters: params)
        }
    }
    
    func updateStoreData(json: JSON){
        
        if let stores = json["result"].array {
            
            let numberOfStores = json["result"].count
            print(" Number of stores found: \(numberOfStores)")
            
            for store in stores{
                
                let storeDataModel = StoreDateModel()
                
                storeDataModel.address_line_1 = store["address_line_1"].stringValue
                storeDataModel.city = store["city"].stringValue
                storeDataModel.openingHours = convertMinutesToTime(timeInMintues: store[openingHours].floatValue)
                storeDataModel.closingHours = convertMinutesToTime(timeInMintues: store[closingHours].floatValue)
                storeDataModel.distance_in_meters = store["distance_in_meters"].floatValue
                
                arrayOfSearchStores.append(storeDataModel)
                
            }
            self.storeTableView.reloadData()
        }else{
            print("error parsing the json stuff")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfSearchStores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customStoreCell", for: indexPath) as! CustomStoreCell
        
        cell.storeAddress.text = arrayOfSearchStores[indexPath.row].address_line_1
        cell.storeCity.text = arrayOfSearchStores[indexPath.row].city
        cell.storeHours.text = "\(arrayOfSearchStores[indexPath.row].openingHours)AM to \(arrayOfSearchStores[indexPath.row].closingHours)PM"
        cell.storeDistance.text = String(format: "%.1f", arrayOfSearchStores[indexPath.row].distance_in_meters / 1000) + " km"
        
        return cell
    }
    
    func setOpenAndCloseHoursToday(){
        
       if let todaysDayOfTheWeek = Date().dayNumberOfWeek()
       {
            switch todaysDayOfTheWeek {
                
                //sunday
                case  1:
                    openingHours = "sunday_open"
                    closingHours = "sunday_close"
            
                //monday
                case 2:
                
                    openingHours = "monday_open"
                    closingHours = "monday_close"
                
                //tuesday
                case 3:
                
                    openingHours = "tuesday_open"
                    closingHours = "tuesday_close"
                
                //wednesday
                case 4:
                
                    openingHours = "wednesday_open"
                    closingHours = "wednesday_close"
                
                //thursday
                case 5:
                
                    openingHours = "thursday_open"
                    closingHours = "thursday_close"
                
                //friday
                case 6:
                
                    openingHours = "friday_open"
                    closingHours = "friday_close"
                
                //saturday
                case 7:
                
                    openingHours = "saturday_open"
                    closingHours = "saturday_close"
                
            
                default:
                   print ("wtf, no day was set today")
            }
        }
    }
    
    func convertMinutesToTime(timeInMintues: Float) -> String {
        
        
        var convHour = timeInMintues/60
        var hourValue = Int(convHour / 1)
        
        if hourValue >= 13 {
           hourValue =  hourValue - 12
            convHour = convHour - 12
        }
        
        let minValue = (convHour - Float(hourValue)) * 60
        
        if minValue == 0{
            return "\(hourValue):00"
        }
        
        return "\(hourValue):\(Int(minValue))"
    }
    
    func changeButtonProperties(currentState: Bool){
        if currentState == false {
            findStoresInMyLocationButton.isEnabled = false
            findStoresInMyLocationButton.backgroundColor = UIColor.darkGray
            findStoresInMyLocationButton.setTitle("Current Stores in My Location", for: .normal)
        }
        
        else{
            findStoresInMyLocationButton.isEnabled = true
            findStoresInMyLocationButton.backgroundColor = UIColor(hex: "0096c1")
            findStoresInMyLocationButton.setTitle("Find Stores in My Location", for: .normal)
        }
    }
}



extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
