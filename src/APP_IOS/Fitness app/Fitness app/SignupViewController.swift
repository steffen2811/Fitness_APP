//
//  SignupViewController.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 01/12/2018.
//  Copyright © 2018 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var EmailTxtField: UITextField!
    @IBOutlet weak var PasswordTxtFIeld: UITextField!
    
    
    var base64SignupString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    @IBAction func Continue(_ sender: Any) {
        Continuestep()
        
    }
    
    func Continuestep() {
        let username = EmailTxtField.text!
        let password = PasswordTxtFIeld.text!
        let SignUpString = String(format: "%@:%@", username, password)
        let SignupData = SignUpString.data(using: String.Encoding.utf8)!
        base64SignupString = SignupData.base64EncodedString()
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "Continue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? Signup2Viewcontroller
        {
            vc.base64SignupString = base64SignupString
        }
    }
}
