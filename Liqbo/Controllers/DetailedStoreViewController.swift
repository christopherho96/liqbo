//
//  DetailedStoreViewController.swift
//  Liqbo
//
//  Created by Christopher Ho on 2017-11-27.
//  Copyright © 2017 chovo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class DetailedStoreViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var recievedItemData: StoreDateModel?
    
    @IBOutlet weak var sundayHours: UILabel!
    @IBOutlet weak var mondayHours: UILabel!
    @IBOutlet weak var tuesdayHours: UILabel!
    @IBOutlet weak var wednesdayHours: UILabel!
    @IBOutlet weak var thursdayHours: UILabel!
    @IBOutlet weak var fridayHours: UILabel!
    @IBOutlet weak var saturdayHours: UILabel!
    
    
    @IBOutlet weak var Map: MKMapView!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var storeCity: UILabel!
    @IBOutlet weak var showInMapsButton: UIButton!
    @IBAction func showInMapsButtonPressed(_ sender: Any) {
        
        let location = CLLocationCoordinate2DMake(CLLocationDegrees(recievedItemData!.latitude), CLLocationDegrees(recievedItemData!.longitude))
        let placemark = MKPlacemark(coordinate: location)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = recievedItemData!.address_line_1
        mapItem.openInMaps(launchOptions: nil)
        
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Map.delegate = self
        
        showInMapsButton.layer.cornerRadius = showInMapsButton.frame.height/2
        
        let location = CLLocationCoordinate2DMake(CLLocationDegrees(recievedItemData!.latitude), CLLocationDegrees(recievedItemData!.longitude))
        
        //this span controls how zoomed in the view is
        let span = MKCoordinateSpanMake(0.002, 0.002)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        Map.setRegion(region, animated: true)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "LCBO"
        annotation.subtitle = recievedItemData!.address_line_1
        Map.addAnnotation(annotation)
        
        
        storeAddress.text = recievedItemData!.address_line_1
        storeCity.text = recievedItemData!.city
        
        sundayHours.text = "Sun: " + recievedItemData!.sundayHours
        mondayHours.text = "Mon: " + recievedItemData!.mondayHours
        tuesdayHours.text = "Tue: " +  recievedItemData!.tuesdayHours
        wednesdayHours.text = "Wed: " +  recievedItemData!.wednesdayHours
        thursdayHours.text = "Thu: " +  recievedItemData!.thursdayHours
        fridayHours.text = "Fri: " +  recievedItemData!.fridayHours
        saturdayHours.text = "Sat: " +  recievedItemData!.saturdayHours
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
