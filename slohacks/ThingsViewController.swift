//
//  ThingsViewController.swift
//  slohacks
//
//  Created by Devin Nicholson on 2/3/18.
//  Copyright © 2018 Devin Nicholson. All rights reserved.
//

import UIKit

class ThingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var itemList: UITableView!
    
    
    var items = [
        ItemStruct(itemName: "Milk", groceryName: "Safeway", notes: "2% lactose free"),
        ItemStruct(itemName: "Eggs", groceryName: "Safeway", notes: "2 dozen"),
        ItemStruct(itemName: "Chicken Breast", groceryName: "Safeway", notes: ""),
        ItemStruct(itemName: "Pasta Sauce", groceryName: "Ralphs", notes: "red sauce"),
        ItemStruct(itemName: "Mac & Cheese", groceryName: "Ralphs", notes: "qty: 5"),
        ItemStruct(itemName: "Orange Chicken", groceryName: "Trader Joes", notes: ""),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemList.delegate = self
        itemList.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell: UITableViewCell
        tableViewCell = tableView.dequeueReusableCell(withIdentifier: "ItemStoreCell")!
        tableViewCell.textLabel?.text = self.items[indexPath.row].itemName + " | " + self.items[indexPath.row].groceryName
        return tableViewCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
