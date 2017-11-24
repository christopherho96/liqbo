//
//  DetailedItemViewController.swift
//  Liqbo
//
//  Created by Christopher Ho on 2017-11-23.
//  Copyright © 2017 chovo. All rights reserved.
//

import UIKit

protocol CanRecieveItemData {
    func dataItemDataRecieved(data: ProductDataModel)
}

class DetailedItemViewController: UIViewController {

    var recivedItemData: ProductDataModel?
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var itemStyle: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemPricePerPackage: UILabel!
    
    
    
    @IBAction func dismissDetailedViewTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        itemImage.af_setImage(withURL: recivedItemData!.image_url)
        itemImage.clipsToBounds = true
        itemName.text = recivedItemData!.name
        itemStyle.text = recivedItemData!.style
    
     

        
        let price = convertPriceFromCentsToDollars(price: recivedItemData!.price_in_cents)
        
        let combinedString = "$" + price + "/" + recivedItemData!.package
        let amountText = NSMutableAttributedString.init(string: combinedString)
        let numberOfCharInPrice = price.count + 1
        
        amountText.setAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 50),
                                  NSAttributedStringKey.foregroundColor: UIColor.black],  range: NSMakeRange(0, numberOfCharInPrice ))
        
        itemPricePerPackage.attributedText = amountText
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func convertPriceFromCentsToDollars(price: Float) -> String{
        let priceInDollars = price/100
        return String(format: "%.2f", priceInDollars)
    }

    //cell.productPrice.text = "Price: " + String(format: "%.2f", arrayOfSearchItems[indexPath.row].price_in_cents / 100)
}
