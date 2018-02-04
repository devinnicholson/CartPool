//
//  InvitesViewController.swift
//  slohacks
//
//  Created by Devin Nicholson on 2/4/18.
//  Copyright © 2018 Devin Nicholson. All rights reserved.
//

import UIKit
import FirebaseDatabase

class InvitesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var phoneNumber: String!
    var invites = [String]()
    
    @IBOutlet weak var invitesTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(phoneNumber)
        Globals.ref.child("invites/\(phoneNumber!)").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let groupKey = value?["groupKey"] as? String ?? ""
            let fromUserKey = value?["fromUserKey"] as? String ?? ""
            Globals.ref.child("users/\(fromUserKey)/name").observeSingleEvent(of: .value, with: { (snapshot) in
                let fromUserName = snapshot.value as? String ?? "IT'S A MYSTERY"
                let inviteStr = String(snapshot.value! as! String)
                self.invites.append(inviteStr)
                // display "You've been invited to \(fromUserName)'s group. Accept? [y/n]"
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = invites[indexPath.row]
        
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
