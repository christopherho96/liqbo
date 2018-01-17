//
//  CategoryViewController.swift
//  Liqbo
//
//  Created by Christopher Ho on 2018-01-07.
//  Copyright © 2018 chovo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var apiUrl = "https://lcboapi.com/products?access_key=MDpmYjcyMDI5MC1jNjkwLTExZTctODFkNi01Nzk0MGZlMTcyMDE6a2ZTczF5ZXVnckEyMDgwZXBSeDVmZDNpYUVIYk5mTmo0azFC"
    var selectedCategory : String = ""
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CustomCategoryCell
        
        if indexPath.row == 0 {
            cell.categoryImage.image = UIImage(named: "greenbeers")
            cell.categoryLabel.text = "Beer"
            cell.categoryDescription.text = "Find a quick brew for the boys"
        }
        
        else if indexPath.row == 1 {
            cell.categoryImage.image = UIImage(named: "spirits")
            cell.categoryLabel.text = "Spirits"
            cell.categoryDescription.text = "Rums, vodkas and more"
        }
        
        else if indexPath.row == 2 {
            cell.categoryImage.image = UIImage(named: "wine")
            cell.categoryLabel.text = "Wine"
            cell.categoryDescription.text = "Pair it with the perfect steak"
        }
        
        else if indexPath.row == 3 {
            cell.categoryImage.image = UIImage(named: "ciders")
            cell.categoryLabel.text = "Cider"
            cell.categoryDescription.text = "A little more fruity"
        }
        
        else if indexPath.row == 4 {
            cell.categoryImage.image = UIImage(named: "seasonal")
            cell.categoryLabel.text = "Seasonal"
            cell.categoryDescription.text = "View the current in-season drinks"
        }
        
        cell.boxView.layer.masksToBounds = false
        cell.boxView.layer.shadowOpacity = 1
        cell.boxView.layer.shadowRadius = 1
        cell.boxView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.boxView.layer.shadowColor = UIColor.darkGray.cgColor
        cell.boxView.clipsToBounds = false
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = indexPath.row
        switch selectedCell{
        case 0:
            selectedCategory = "beer"
            
        case 1:
            selectedCategory = "spirit"
        case 2:
            selectedCategory = "wine"
        case 3:
            selectedCategory = "cider"
        case 4:
            selectedCategory = "seasonal"
        default:
            print("error, no category selected")
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "segueToCategoryTableView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCategoryTableView" {
            
            let secondVC = segue.destination as! ItemsOfSelectedCategoryTableViewController
            
            secondVC.selectedCategory = selectedCategory
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(250)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.estimatedRowHeight = categoryTableView.rowHeight
        categoryTableView.rowHeight = UITableViewAutomaticDimension
        categoryTableView.register(UINib(nibName: "CustomCategoryCell", bundle: nil), forCellReuseIdentifier: "categoryCell")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
