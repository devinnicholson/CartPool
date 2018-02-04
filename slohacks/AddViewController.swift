//
//  AddViewController.swift
//  slohacks
//
//  Created by Devin Nicholson on 2/3/18.
//  Copyright © 2018 Devin Nicholson. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddViewController: UIViewController {
    var ref: DatabaseReference!

    
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var groceryTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    var user: LogHorizon.User!
    
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.user = LogHorizon.User.init("6508149260", "Devin Nicholson", "-L4VF570zfHx7pniTtK1")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addItem(_ sender: UIButton) {
        self.user.addItem(name: self.itemTextField.text!, store: self.groceryTextField.text!, notes: self.notesTextField.text!, then: { (item) in
            
        })
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
