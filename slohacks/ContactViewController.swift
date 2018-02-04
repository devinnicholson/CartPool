//
//  ContactViewController.swift
//  slohacks
//
//  Created by Devin Nicholson on 2/3/18.
//  Copyright © 2018 Devin Nicholson. All rights reserved.
//

import UIKit
import Contacts

class ContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var contactStore = CNContactStore()
    
    var contacts = [
        ContactStruct(firstName: "Hi", lastName: "hi3", number: "12345"),        ContactStruct(firstName: "Hi3", lastName: "hi33", number: "123435")
    ]
    
    @IBOutlet weak var contactTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactTableView.delegate = self
        contactTableView.dataSource = self

        contactStore.requestAccess(for: . contacts) { (success, error) in
            if success {
                print("Authorization Successful")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchContacts() {
        let key = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        
        let request = CNContactFetchRequest(keysToFetch: key)
        try! contactStore.enumerateContacts(with: request) { (contact, stoppingPointer) in
            let firstName = contact.givenName
            let lastName = contact.familyName
            let number = contact.phoneNumbers.first?.value.stringValue
            let contactToAppend = ContactStruct(firstName: firstName, lastName: lastName, number: number!)
            
            self.contacts.append(contactToAppend)
        }
        contactTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        let contactToDisplay = contacts[indexPath.row]
        cell.textLabel?.text = contactToDisplay.firstName + " " + contactToDisplay.lastName
        cell.detailTextLabel?.text = contactToDisplay.number
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
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
