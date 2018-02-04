//
//  PlacesViewController.swift
//  slohacks
//
//  Created by Devin Nicholson on 2/3/18.
//  Copyright © 2018 Devin Nicholson. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PlacesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var ref: DatabaseReference?
    var storesData = [LogHorizon.StorePtr]()
    
    @IBOutlet weak var storesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storesTable.delegate = self
        storesTable.dataSource = self
        
        LogHorizon.fetchUserBy(phone: "6508149260", { (user) in
            user!.groupStores({ (stores) in
                self.storesData = stores!
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoresTableViewCell", for: indexPath)
        let storeItem = storesData[indexPath.row]
        cell.textLabel!.text = storeItem.name
        //cell.detailTextLabel!.text = ""
            
        return cell
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
