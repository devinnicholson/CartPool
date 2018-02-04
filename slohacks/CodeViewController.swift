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
        LogHorizon.finishVerification(
            phone: self.phoneNumber,
            code: self.codeTextField.text!,
            onSuccess: { (user) in
            },
            onFailure: {
            },
            onCreate: {
            }
        )
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newProfileViewController = segue.destination as! NewProfileViewController
        newProfileViewController.phoneNumber = self.phoneNumber
    }*/

}
