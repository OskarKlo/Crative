//
//  PostCell.swift
//  Crative
//
//  Created by Oskar on 5/9/17.
//  Copyright © 2017 Oskar Klonowski. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var unlikeBtn: UIButton!
    
    
    @IBAction func likePressed(_ sender: Any) {
    }
    
    @IBAction func unlikePressed(_ sender: Any) {
    }
    
    
}
