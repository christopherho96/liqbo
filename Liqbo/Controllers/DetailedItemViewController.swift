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
    
    @IBOutlet weak var itemOrigin: UILabel!
    
    @IBOutlet weak var itemAlchoholContent: UILabel!
    @IBOutlet weak var itemIsOnSale: UILabel!
    
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var currentCount = 1;
    
    var currentTotalPrice: Float = 0
    
    
    @IBAction func decrementCount(_ sender: Any) {
        
        if currentCount > 0 {
            currentCount = currentCount - 1
        }
        
        countLabel.text = String(currentCount)
    }
    
    @IBAction func incrementCount(_ sender: Any) {
        
        if currentCount < 20 {
            currentCount = currentCount + 1
        }
        
        countLabel.text = String(currentCount)
        
    }
    
    @IBAction func dismissDetailedViewTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addToCartButtonTapped(_ sender: Any) {
    
        currentTotalPrice = (recivedItemData!.price_in_cents)/100 * Float(currentCount)
        
        if currentCount != 0{
        
            let alert = UIAlertController(title: "Added to Cart", message: "\(currentCount) \(recivedItemData!.name) with a total cost of $\(String(format:"%.2f",currentTotalPrice)) has been added.", preferredStyle: .alert)
            
            let continueShopping = UIAlertAction(title: "Continue Shopping" , style: .default, handler: { (UIAlertAction) in
                alert.dismiss(animated: true, completion: nil)
            })
            
            let goToCart =  UIAlertAction(title: "Go To Cart" , style: .default, handler: { (UIAlertAction) in
                
            })
            
            alert.addAction(continueShopping)
            alert.addAction(goToCart)
            present(alert, animated: true, completion: nil)

        }
        
        else{
            let alert = UIAlertController(title: "Whoops!", message: "You have 0 items selected", preferredStyle: .alert)
            
            let dismiss = UIAlertAction(title: "OK" , style: .default, handler: { (UIAlertAction) in
                alert.dismiss(animated: true, completion: nil)
            })
            
            alert.addAction(dismiss)
            present(alert, animated: true, completion: nil)
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        itemImage.af_setImage(withURL: recivedItemData!.image_url)
        itemImage.clipsToBounds = true
        
        
        itemName.text = recivedItemData!.name
        print(itemName.text!)
        //itemStyle.text = recivedItemData!.style
        itemOrigin.text = "\(recivedItemData!.origin)"
        itemAlchoholContent.text = "\(String(format:"%.1f", recivedItemData!.alcohol_content / 100))%"
        
        let onSale = recivedItemData!.has_limited_time_offer
        
        if onSale == true{
            itemIsOnSale.text = "Save $\(String(format: "%.2f", recivedItemData!.limited_time_offer_savings_in_cents/100)) until \(recivedItemData!.limited_time_offer_ends_on)"
        }
        else{
            itemIsOnSale.text = "Currently no promotion"
        }
        
       let price = convertPriceFromCentsToDollars(price: recivedItemData!.price_in_cents)
        
        let combinedString = "$" + price + "/" + recivedItemData!.package
        let amountText = NSMutableAttributedString.init(string: combinedString)
        let numberOfCharInPrice = price.count + 1
        
        amountText.setAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 40),
                                  NSAttributedStringKey.foregroundColor: UIColor.black],  range: NSMakeRange(0, numberOfCharInPrice ))
        
        itemPricePerPackage.attributedText = amountText
        
        
        decrementButton.layer.masksToBounds = true
        decrementButton.layer.cornerRadius = decrementButton.frame.width/2
        decrementButton.layer.borderColor = UIColor.white.cgColor
        decrementButton.layer.borderWidth = 2
        
        incrementButton.layer.masksToBounds = true
        incrementButton.layer.cornerRadius = decrementButton.frame.width/2
        incrementButton.layer.borderColor = UIColor.white.cgColor
        incrementButton.layer.borderWidth = 2
        
        addToCartButton.layer.cornerRadius = addToCartButton.frame.height/2
        addToCartButton.layer.borderColor = UIColor.white.cgColor
        addToCartButton.layer.borderWidth = 2
 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func convertPriceFromCentsToDollars(price: Float) -> String{
        let priceInDollars = price/100
        return String(format: "%.2f", priceInDollars)
    }
    
}
