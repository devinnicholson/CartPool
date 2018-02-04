//
//  LogHorizon.swift
//  slohacks
//
//  Created by Devin Nicholson on 2/4/18.
//  Copyright © 2018 Devin Nicholson. All rights reserved.
//

import os.log
import FirebaseDatabase

class LogHorizon {
    static let ref = Database.database().reference()
    static let log = OSLog(subsystem: "com.cartpool.LogHorizon", category: "firebase")

    // Inserts a verification record, sending a text message.
    //
    static func sendVerification(phone: String) {
        ref.child("verifications/\(phone)").setValue("new");
    }

    class User {
        let phone, name, groupKey: String

        init(_ phone: String, _ name: String, _ groupKey: String) {
            self.phone = phone
            self.name = name
            self.groupKey = groupKey
        }
    }

    static func fetchUserBy(phone: String, _ callback: @escaping (User?) -> Void) {
        ref.child("users/\(phone)").observeSingleEvent(of: .value, with: { (snapshot) in
            if let userValue = snapshot.value as! [String: Any?]?,
                let name = userValue["name"] as! String?,
                let groupKey = userValue["groupKey"] as! String? {
                callback(User(phone, name, groupKey))
            }
            else {
                callback(nil)
            }
        })
    }

    // Checks and clears the verification code. On success, calls back with name and groupKey.
    //
    static func checkVerification(phone: String, code: String,
                                  onSuccess: @escaping (User) -> Void,
                                  onFailure: @escaping () -> Void,
                                  onCreate: @escaping (() -> Void)) {
        ref.child("verifications/\(phone)").observeSingleEvent(of: .value, with: {(snapshot) in
            guard let savedCode = snapshot.value as! String? else{
                return onFailure()
            }

            ref.child("verifications/\(phone)").removeValue()

            guard code == savedCode else {
                return onFailure()
            }

            fetchUserBy(phone: phone, { (user) in
                if user != nil {
                    onSuccess(user!)
                }
                else {
                    onCreate()
                }
            })
        })
    }

    // Fetches current invites for user. On success, calls back with
    //

    class Item {
        let name, notes, userPhone, addedAt: String

        init(name: String, notes: String, userPhone: String, addedAt: String) {
            self.name = name
            self.notes = notes
            self.userPhone = userPhone
            self.addedAt = addedAt
        }

        func user(_ callback: @escaping (User?) -> Void) {
            return fetchUserBy(phone: userPhone, callback)
        }
    }
    class StorePtr {
        let key: String
        let name: String

        init(_ key: String, _ name: String) {
            self.key = key
            self.name = name
        }

        func store(_ callback: (Store?) -> Void) {
            callback(nil)
            // TODO(devin): fetchStoreBy(key: self.key, callback)
        }
    }

    class Store {
        // TODO(devin)
    }
    /* TODO(devin)
    static func fetchStoreBy(key: String, _ callback: (Store?) -> Void) {
        ref.child("stores/\(key)").observeSingleEvent(of: .value, with: { (snapshot) in
            if let storeValue = snapshot.value as! [String: Any?]?,
                let name = storeValue["name"] as! String?,
                let groupKey = storeValue["groupKey"] as! String? {
                callback(Store(phone, name, groupKey))
            }
            else {
                callback(nil)
            }
        })
    }
 */

    // Fetches list of stores from a group.
    //
    static func listStoresFrom(group groupKey: String, _ callback: @escaping ([StorePtr]?) -> Void) {
        ref.child("groups/\(groupKey)/stores").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let storeValues = snapshot.value as! [String: String]? else {
                return callback(nil)
            }

            var storePtrs = [StorePtr]()
            for (name, key) in storeValues {
                storePtrs.append(StorePtr(key, name))
            }
            callback(storePtrs)
        })
    }
}
/*

// when you type in a phone number for the first time
ref.child(“verifications/\(phoneNumber)”).setValue(“new”);
// goto confirmation code screen, save phoneNumber
// when you enter confirm code
ref.child(“verifications/\(phoneNumber)“).observeSingleEvent(of: .value, with: { (snapshot) in
    let remoteCode = snapshot.value as? Integer
    if enteredCode != remoteCode {
        // goto phone number screen with error
    }

    ref.child("users/\(phoneNumber)").observeSingleEvent(of: .value, with: { (snapshot) in
        let value = snapshot.value as? NSDictionary
        let name = value?["name"] as? String ?? "IT'S A MYSTERY"
        if let groupKey = value?["groupKey"] as? String {
            // go to group home page
        }
        else {
            // go to create / invites page
        }
    })
})


// when you check invites:
ref.child(“invites/\(phoneNumber)“).observeSingleEvent(of: .value, with: { (snapshot) in
    let value = snapshot.value as? NSDictionary
    let groupKey = value?[“groupKey”] as? String ?? “”
    let fromUserKey = value?[“fromUserKey”] as? String ?? “”
    ref.child(“users/\(fromUserKey)/name“).observeSingleEvent(of: .value, with: { (snapshot) in
    let fromUserName = snapshot.value as? String ?? "IT'S A MYSTERY"

    // display "You've been invited to \(fromUserName)'s group. Accept? [y/n]"
    })
})

// when you accept an invite:
let updates = ["users/\(phoneNumber)/group": groupKey,
               "groups/\(groupKey)/members/\(userName)": phoneNumber,
               "invites/\(phoneNumber)": nil]
ref.updateChildValues(updates, withCompletionBlock: { (error, ref) -> Void in
    if (error) {
        // idk man
    }
    // goto group home page
}
 */
