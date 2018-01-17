//
//  CartViewController.swift
//  Liqbo
//
//  Created by Christopher Ho on 2017-11-15.
//  Copyright © 2017 chovo. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

var arrayOfItemsAddedToCart = ItemsAddedToCart()


class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()
    
    var listOfItems : Results<ListOfItems>?
    
    var itemDataToSendToDetailedView : ProductDataModel?
    var totalPriceInCart: Float = 0
    var stringTotalPriceInCart = ""
    
    let arrayOfBools = [true, false, true, false]
    
    //var listArray = [List]()
    
    @IBOutlet weak var cartTableView: UITableView!
    
    @IBOutlet weak var totalCartCostLabel: UILabel!
    
    @IBOutlet weak var saveListButton: UIButton!
    
    //save data to coreData
    @IBAction func tappedSaveListButton(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Give your list a name.", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Save List", style: .default) { (action) in
            // create the new list
            let newList = ListOfItems()
            newList.title = textField.text!
            newList.date = Date()
            
            for product in arrayOfItemsAddedToCart.addedItemsToCart{
                newList.itemsArray.append(product)
            }
            
            self.saveList(list: newList)
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.estimatedRowHeight = cartTableView.rowHeight
        cartTableView.rowHeight = UITableViewAutomaticDimension
        cartTableView.register(UINib(nibName: "CustomShoppingCartItemCell", bundle: nil), forCellReuseIdentifier: "ShoppingCartItem")
        
        print(arrayOfItemsAddedToCart.addedItemsToCart.count)

        //self.navigationController!.navigationBar.isTranslucent = false
        
        //loadItems()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartTableView.reloadData()
        totalPriceInCart = 0
        for item in arrayOfItemsAddedToCart.addedItemsToCart{
        totalPriceInCart = totalPriceInCart + (item.price_in_cents * Float(item.numberAddedToCart))
        }
        
        stringTotalPriceInCart =  convertPriceFromCentsToDollars(price: totalPriceInCart)
        print(stringTotalPriceInCart)
        totalCartCostLabel.text = "$" + stringTotalPriceInCart
    }
    
    //MARK - update tableview stuff

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfItemsAddedToCart.addedItemsToCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartItem", for: indexPath) as! CustomShoppingCartItemCell
        
        let item = arrayOfItemsAddedToCart.addedItemsToCart[indexPath.row]
        
        //set iamge here
        let url : URL?
        if item.image_thumb_url != nil {
            url = URL(string: item.image_thumb_url!)
        }else{
            url = URL(string: "https://s3.amazonaws.com/woof.nextglass.co/custom_item_type_images_production/af7e5a9d2a54837d65cae5637975ba8dfa05311f-custom-item-type-image.png?1476365129")
        }
        cell.itemImage.af_setImage(withURL: url!)
        
        cell.itemImage.clipsToBounds = true

        cell.nameOfItem.text = "\(item.name) x \(item.numberAddedToCart)"
        cell.itemDescription.text = item.package
        cell.currentCount.text = String(item.numberAddedToCart)
        cell.currentCount.clipsToBounds = true
        cell.currentCount.layer.cornerRadius = 10
        
        let price = convertPriceFromCentsToDollars(price: item.currentPriceOfTotalCount)
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
    
    //MARK - if a cell is selected, this stuff
    
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
    
    //MARK - save list of items
    func saveList(list: ListOfItems){
        do{
            try realm.write {
                realm.add(list)
                print("succesfully saved list")
            }
            
        } catch{
            print("Error saving list of items \(error)")
        }
    }
    
//    //decoding to plist file
//    func loadItems(){
//        let request : NSFetchRequest<List> = List.fetchRequest()
//        do{
//           listArray = try context.fetch(request)
//            print(listArray[13].itemsArray as! Array<ProductDataModel>)
//        }catch{
//            print("Error fetching data from context \(error)")
//        }
//    }

}

func convertPriceFromCentsToDollars(price: Float) -> String{
    let priceInDollars = price/100
    return String(format: "%.2f", priceInDollars)
}

