//
//  LogHorizon.swift
//  slohacks
//
//  Created by Devin Nicholson on 2/4/18.
//  Copyright © 2018 Devin Nicholson. All rights reserved.
//

import FirebaseDatabase

class LogHorizon {
    static let ref = Database.database().reference()

    // MARK: verification

    static func startVerification(phone: String) {
        ref.child("verifications/\(phone)").setValue("new");
    }

    static func finishVerification(phone: String, code: String,
                                   onSuccess: @escaping (User) -> Void,
                                   onFailure: @escaping () -> Void,
                                   onCreate: @escaping (() -> Void)) {
        ref.child("verifications/\(phone)").observeSingleEvent(of: .value, with: {(snapshot) in
            guard let savedCode = snapshot.value as? String else {
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

    static func sendInvite(from: User, to: String) {
        ref.child("invites/\(to)").updateChildValues([
            "fromUserPhone": from.phone,
            "fromUserName": from.name,
            "groupKey": from.groupKey!
        ])
    }

    // MARK: users

    class User {
        let phone, name: String
        var groupKey: String?

        init(_ phone: String, _ name: String, _ groupKey: String?) {
            self.phone = phone
            self.name = name
            self.groupKey = groupKey
        }

        func setGroup(_ groupKey: String) {
            self.groupKey = groupKey
            ref.updateChildValues([
                "users/\(self.phone)/groupKey": groupKey,
                "groups/\(groupKey)/members/\(self.name)": self.phone,
            ])
        }

        func groupStores(_ callback: @escaping ([StorePtr]) -> Void) {
            if self.groupKey != nil {
                listStoresFrom(group: self.groupKey!, callback)
            }
            else {
                callback([])
            }
        }

        func groupMembers(_ callback: @escaping ([UserPtr]) -> Void) {
            if self.groupKey != nil {
                listUsersFrom(group: self.groupKey!, callback)
            }
            else {
                callback([])
            }
        }


        func addItem(name: String, store storeName: String, notes: String?, then callback: @escaping (Item) -> Void) {
            let groupKey = self.groupKey!
            ref.child("groups/\(groupKey)/stores/\(storeName)").observeSingleEvent(of: .value, with: { (snapshot) in
                 if (snapshot.exists()) {
                    let storeKey = snapshot.value as! String
                    return self.addItemHelper(name, notes, storeKey, storeName, callback)
                }

                let newStore = ref.child("stores").childByAutoId()

                ref.child("groups/\(groupKey)/stores/\(storeName)").runTransactionBlock({ (data) -> TransactionResult in
                    if (data.value as? String) != nil {
                        return TransactionResult.abort()
                    }
                    data.value = newStore.key
                    return TransactionResult.success(withValue: data)
                }, andCompletionBlock: { (error, success, data) in
                    if success {
                        newStore.child("name").setValue(storeName)
                    }
                    else {
                        newStore.removeValue()
                    }
                    let storeKey = data!.value as! String
                    self.addItemHelper(name, notes, storeKey, storeName, callback)
                })
            })
        }
        // DO NOT CALL
        private func addItemHelper(_ name: String, _ notes: String?, _ storeKey: String, _ storeName: String, _ callback: (Item) -> Void) {
            ref.child("stores/\(storeKey)/name").setValue(storeName) 
            let item = ref.child("stores/\(storeKey)/items").childByAutoId()
            item.updateChildValues([
                "name": name,
                "notes": notes ?? "",
                "userPhone": self.phone,
                "addedAt": "2018",
            ])
            callback(Item(item.key, name, notes, self.phone, "2018", storeKey, storeName))
        }
    }

    class UserPtr {
        let phone, name: String

        init(_ phone: String, _ name: String) {
            self.phone = phone
            self.name = name
        }

        func user(_ callback: @escaping (User?) -> Void) {
            fetchUserBy(phone: self.phone, callback)
        }
    }

    static func fetchUserBy(phone: String, _ callback: @escaping (User?) -> Void) {
        ref.child("users/\(phone)").observeSingleEvent(of: .value, with: { (snapshot) in
            if let userValue = snapshot.value as? [String: String] {
                callback(User(phone, userValue["name"]!, userValue["groupKey"]))
            }
            else {
                callback(nil)
            }
        })
    }

    static func listUsersFrom(group groupKey: String, _ callback: @escaping ([UserPtr]) -> Void) {
        ref.child("groups/\(groupKey)/members").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userValues = snapshot.value as? [String: String] else {
                return callback([])
            }

            var userPtrs = [UserPtr]()
            for (name, phone) in userValues {
                userPtrs.append(UserPtr(phone, name))
            }
            callback(userPtrs)
        })
    }

    static func createUser(phone: String, name: String, groupKey: String?) -> User {
        ref.child("users/\(phone)/name").setValue(name)
        let user = User(phone, name, nil)
        if groupKey != nil {
            user.setGroup(groupKey!)
        }
        return user
    }

    // MARK: items

    class Item {
        let key, name, userPhone, addedAt, storeKey, storeName: String
        let notes: String?

        init(_ key: String, _ name: String, _ notes: String?, _ userPhone: String, _ addedAt: String, _ storeKey: String, _ storeName: String) {
            self.key = key
            self.name = name
            self.notes = notes
            self.userPhone = userPhone
            self.addedAt = addedAt
            self.storeKey = storeKey
            self.storeName = storeName
        }

        func user(_ callback: @escaping (User?) -> Void) {
            return fetchUserBy(phone: userPhone, callback)
        }
    }

    static func listItemsFrom(store: String, _ callback: @escaping ([Item]) -> Void) {
        ref.child("stores/\(store)").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let storeValue = snapshot.value as? [String: Any],
                let itemValues = storeValue["items"] as? [String: [String: String]] else {
                return callback([])
            }

            let storeName = storeValue["name"] as! String
            var items = [Item]()
            for (key, values) in itemValues {
                items.append(Item(key, values["name"]!, values["notes"], values["userPhone"]!, values["addedAt"]!, store, storeName))
            }
            callback(items)
        })
    }

    // MARK: stores

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

        func storeItems(_ callback: @escaping ([Item]) -> Void) {
            listItemsFrom(store: self.key, callback)
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
    static func listStoresFrom(group groupKey: String, _ callback: @escaping ([StorePtr]) -> Void) {
        ref.child("groups/\(groupKey)/stores").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let storeValues = snapshot.value as? [String: String] else {
                return callback([])
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
