//
//  LoginViewController.swift
//  slohacks
//
//  Created by Devin Nicholson on 2/3/18.
//  Copyright © 2018 Devin Nicholson. All rights reserved.
//

import UIKit
import FirebaseDatabase

class LoginViewController: UIViewController {
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        Globals.ref.child("verifications/\(phoneNumber.text!)").setValue("new");
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let codeViewController = segue.destination as! CodeViewController
        codeViewController.phoneNumber = self.phoneNumber.text
    }
    

}
