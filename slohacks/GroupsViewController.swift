//
//  GroupsViewController.swift
//  slohacks
//
//  Created by Devin Nicholson on 2/3/18.
//  Copyright © 2018 Devin Nicholson. All rights reserved.
//

import UIKit

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var groupList: UITableView!
    
    var members = [
        ContactStruct(firstName: "Joe", lastName: "Wijoyo", number: "7142134513"),
        ContactStruct(firstName: "Karen", lastName: "Kauffman", number: "5369324443"),
        ContactStruct(firstName: "Barrett", lastName: "Lo", number: "7143059942"),
        ContactStruct(firstName: "Cidney", lastName: "Lee", number: "6930032324"),
        ContactStruct(firstName: "Hanna", lastName: "Trejo", number: "3105560012"),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        groupList.dataSource = self
        groupList.delegate = self
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell: UITableViewCell
        tableViewCell = tableView.dequeueReusableCell(withIdentifier: "MemberCell")!
        tableViewCell.textLabel?.text = self.members[indexPath.row].firstName + " | " + self.members[indexPath.row].lastName
        return tableViewCell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }

}
