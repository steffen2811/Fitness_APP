//
//  Cell.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 15/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation


class Cell: NSObject {
    
    //properties
    var object: NSDictionary?
    
    
    //empty constructor
    override init()
    {
        
    }
    
    //construct with @name parameters
    init(object:NSDictionary) {
        
        self.object = object
        
    }
    
    
    //prints object's current state
    override var description: String {
        return "object: \(object)"
        
        
    }
    
    
}
