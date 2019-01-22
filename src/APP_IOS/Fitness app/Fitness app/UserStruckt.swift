//
//  UserStruckt.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 20/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation

class User: Decodable{
    var name: String
    var id_users: Int
    var gender: String
    var age: Int
    var primarySports: String
    var profileImgPath: String
    var timeSpendPerWeek: Int
    var sportLevel: Int
    
    
    
    init(name: String, id_users: Int, gender: String, age: Int, primarySports: String, profileImgPath: String, timeSpendPerWeek: Int, sportLevel: Int) {
        self.name = name
        self.id_users = id_users
        self.gender = gender
        self.age = age
        self.primarySports = primarySports
        self.profileImgPath = profileImgPath
        self.timeSpendPerWeek = timeSpendPerWeek
        self.sportLevel = sportLevel
        print("User \(name) is initialized")
    }
    
    deinit {
        print("User \(name) is being deallocated")
    }
}
