//
//  CartViewController.swift
//  Liqbo
//
//  Created by Christopher Ho on 2017-11-15.
//  Copyright © 2017 chovo. All rights reserved.
//

import UIKit


var arrayOfItemsAddedToCart = ItemsAddedToCart()


class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var itemDataToSendToDetailedView : ProductDataModel?
    var totalPriceInCart: Float = 0
    var stringTotalPriceInCart = ""
    
    @IBOutlet weak var cartTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.estimatedRowHeight = cartTableView.rowHeight
        cartTableView.rowHeight = UITableViewAutomaticDimension
        cartTableView.register(UINib(nibName: "CustomShoppingCartItemCell", bundle: nil), forCellReuseIdentifier: "ShoppingCartItem")
        
        print(arrayOfItemsAddedToCart.addedItemsToCart.count)

        self.navigationController!.navigationBar.isTranslucent = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartTableView.reloadData()
        for item in arrayOfItemsAddedToCart.addedItemsToCart{
        totalPriceInCart = totalPriceInCart + (item.price_in_cents * Float(item.numberAddedToCart))
        }
        
        stringTotalPriceInCart = convertPriceFromCentsToDollars(price: totalPriceInCart)
        print(stringTotalPriceInCart)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfItemsAddedToCart.addedItemsToCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartItem", for: indexPath) as! CustomShoppingCartItemCell
        cell.itemImage.af_setImage(withURL: arrayOfItemsAddedToCart.addedItemsToCart[indexPath.row].image_url)
        cell.itemImage.clipsToBounds = true
        cell.nameOfItem.text = "\(arrayOfItemsAddedToCart.addedItemsToCart[indexPath.row].name) x \(arrayOfItemsAddedToCart.addedItemsToCart[indexPath.row].numberAddedToCart)"
        cell.itemDescription.text = arrayOfItemsAddedToCart.addedItemsToCart[indexPath.row].package
        
        let price = convertPriceFromCentsToDollars(price: arrayOfItemsAddedToCart.addedItemsToCart[indexPath.row].currentPriceOfTotalCount)
        cell.itemPrice.text = "$"+price
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            arrayOfItemsAddedToCart.addedItemsToCart[indexPath.row].numberAddedToCart = 1
            arrayOfItemsAddedToCart.addedItemsToCart.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("This cell from the chat list was selected: \(indexPath.row)")
        itemDataToSendToDetailedView = arrayOfItemsAddedToCart.addedItemsToCart[indexPath.row]
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

func convertPriceFromCentsToDollars(price: Float) -> String{
    let priceInDollars = price/100
    return String(format: "%.2f", priceInDollars)
}

