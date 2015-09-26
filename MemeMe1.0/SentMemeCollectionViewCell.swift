//
//  SentMemesCollectionView.swift
//  MemeMe1.0
//
//  Created by Stella Su on 9/23/15.
//  Copyright (c) 2015 Million Stars, LLC. All rights reserved.
//

import UIKit

let reuseIdentifier = "MemeCollectionViewCell"

class SentMemesCollectionView: UICollectionViewController, UICollectionViewDataSource {
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
    }
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        collectionView!.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       
        // Configuring the cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        cell.backgroundView = UIImageView(image: meme.memedImage)
        
        return cell
    
    }
    
    
    @IBAction func addNewMeme(sender: AnyObject) {
        performSegueWithIdentifier("addMemeFromCollection", sender: nil)
    }

   
}
