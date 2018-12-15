//
//  UserViewController.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 07/12/2018.
//  Copyright © 2018 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit
import SideMenu
import FBSDKCoreKit
import FBSDKLoginKit

class UserViewController: UIViewController {
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var AgeLabel: UILabel!
    @IBOutlet weak var SportLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var LevelLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var MobileLabel: UILabel!
    @IBOutlet weak var CityLabel: UILabel!
    
    @IBAction func LogudButton(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.synchronize()
        
        FBSDKLoginManager().logOut()
    }
    
    @IBAction func Menu(_ sender: Any) {
        // open menu
        //present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Getuser()
        
    }
    
    func Getuser() {
        
    }
    
}
