//
//  FindPotentielleUsersCell.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 15/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import UIKit
import AvatarImageView

struct TableAvatarImageConfig: AvatarImageViewConfiguration {
    let shape: Shape = .circle
}

class FindPotentielleUsersCell: UITableViewCell {
    @IBOutlet var Profilepic: AvatarImageView!{
        didSet{
            Profilepic.configuration = TableAvatarImageConfig()
        }
    }
    
    
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var Age: UILabel!
    
}
