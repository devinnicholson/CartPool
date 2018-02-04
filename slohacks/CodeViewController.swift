//
//  CodeViewController.swift
//  slohacks
//
//  Created by Devin Nicholson on 2/3/18.
//  Copyright © 2018 Devin Nicholson. All rights reserved.
//

import UIKit

class CodeViewController: UIViewController {
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    var phoneNumber: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.phoneNumberTextField.text = self.phoneNumber
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func verifyCode(_ sender: UIButton) {
        print("verifyCode")
        LogHorizon.finishVerification(
            phone: self.phoneNumber,
            code: self.codeTextField.text!,
            onSuccess: { (user) in
                print(user)
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let newProfileViewController = storyboard.instantiateViewController(withIdentifier: "NewProfileViewController") as! NewProfileViewController
                newProfileViewController.user = user
                self.present(newProfileViewController, animated: true, completion: nil)
            },
            onFailure: {
                print("Failure")
            },
            onCreate: {
                print("create")
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let newProfileViewController = storyboard.instantiateViewController(withIdentifier: "NewProfileViewController")
                self.present(newProfileViewController, animated: true, completion: nil)
            }
        )
        /*
=======
    
        Globals.ref.child("verifications/\(self.phoneNumber!)").observeSingleEvent(of: .value, with: { (snapshot) in
            let remoteCode = String(snapshot.value! as! Int)
            if self.codeTextField.text != remoteCode {
                // goto phone number screen with error
            }
            
            Globals.ref.child("users/\(self.phoneNumber)").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? "IT'S A MYSTERY"
                if let groupKey = value?["groupKey"] as? String {
                    // go to group home page
                    //LogHorizon.finishVerification(phone: self.phoneNumber, code: self.codeTextField.text!, onSuccess: { _ in }, onFailure: {  }, onCreate: { })
                }
                else {
                    //
                }
            })
        })
>>>>>>> Stashed changes
        */
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newProfileViewController = segue.destination as! NewProfileViewController
        newProfileViewController.phoneNumber = self.phoneNumber
    }*/

}
