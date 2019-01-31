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
    
    var exercise: Exercise?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        
    }
    
    
    private func configureView() {
        if let exercise = exercise {
            NameLabel.text = exercise.execiseName
            
            var repeats = "Repeats: \(exercise.repeats as! Int)"
            repeatsLabel.text = String(repeats)
            
            var Sets = "Sets: \(exercise.sets as! Int)"
            SetsLabel.text = String(Sets)
            
            let request = URLRequest(url: NSURL(string: "https://www.youtube.com/embed/\(exercise.howToVideo)")! as URL)
            webView.load(request)
        }
        
    }
}

