//
//  MemeDetailViewController.swift
//  MemeMe1.0
//
//  Created by Stella Su on 9/25/15.
//  Copyright (c) 2015 Million Stars, LLC. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme : Meme!
    var memeIndex : Int!
    
    @IBOutlet weak var memeImage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the tab bar to have extra space
        tabBarController?.tabBar.hidden = true
        
        // Display the memed Image
        memeImage.image = meme.memedImage
        
    }
    

}
