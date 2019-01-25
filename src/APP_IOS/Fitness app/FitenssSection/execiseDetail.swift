//
//  execiseDetail.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 24/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class execiseDetail: UIViewController{

    @IBOutlet var webView: WKWebView!
    
    @IBOutlet var NameLabel: UILabel!
    
    @IBOutlet var repeatsLabel: UILabel!
    @IBOutlet var SetsLabel: UILabel!
    
    var user: Exercise?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        
    }
    
    
    private func configureView() {
        if let user = user {
            NameLabel.text = user.execiseName
            
            var repeats = "Repeats: \(user.repeats as! Int)"
            repeatsLabel.text = String(repeats)
            
//            var Sets = "Sets: \(user.sets as! Int)"
//            SetsLabel.text = String(Sets)
            
            let request = URLRequest(url: NSURL(string: "https://www.youtube.com/embed/XkwuBMNUgzs")! as URL)
            webView.load(request)
        }
        
    }
}

