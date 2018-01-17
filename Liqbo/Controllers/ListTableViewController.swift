//
//  ListTableViewController.swift
//  Liqbo
//
//  Created by Christopher Ho on 2018-01-07.
//  Copyright © 2018 chovo. All rights reserved.
//

import UIKit
import RealmSwift

class ListTableViewController: UITableViewController {

    let realm = try! Realm()
    
    var lists: Results<ListOfItems>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        loadLists()
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListTableViewCell
        
        //cell.textLabel?.text = lists?[indexPath.row].title ?? "No Categories Added"
        cell.titleOfList.text = lists?[indexPath.row].title ?? "No Categories Added"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewList", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLists(){
        
        lists = realm.objects(ListOfItems.self)
        tableView.reloadData()
        
    }


}
