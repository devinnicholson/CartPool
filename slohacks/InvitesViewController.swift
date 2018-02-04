//
//  InvitesViewController.swift
//  slohacks
//
//  Created by Devin Nicholson on 2/4/18.
//  Copyright © 2018 Devin Nicholson. All rights reserved.
//

import UIKit

class InvitesViewController: UIViewController {

    var phoneNumber: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Globals.ref.child("invites/\(phoneNumber)").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let groupKey = value?["groupKey"] as? String ?? ""
            let fromUserKey = value?["fromUserKey"] as? String ?? ""
            Globals.ref.child("users/\(fromUserKey)/name").observeSingleEvent(of: .value, with: { (snapshot) in
                let fromUserName = snapshot.value as? String ?? "IT'S A MYSTERY"
                
                // display "You've been invited to \(fromUserName)'s group. Accept? [y/n]"
            })
        })
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

}
