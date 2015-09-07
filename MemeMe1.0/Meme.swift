//
//  Meme.swift
//  MemeMe1.0
//
//  Created by Stella Su on 9/2/15.
//  Copyright (c) 2015 Million Stars, LLC. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    
    var topText : String
    var bottomText : String
    var imageView: UIImageView
    var memedImage : UIImage
    
    
    // Initialiser
    init (topText: String, bottomText: String, imageView: UIImageView, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.imageView = imageView
        self.memedImage = memedImage
    }
}