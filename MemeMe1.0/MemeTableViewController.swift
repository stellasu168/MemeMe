//
//  MemeTableViewController.swift
//  MemeMe1.0
//
//  Created by Stella Su on 9/23/15.
//  Copyright (c) 2015 Million Stars, LLC. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme]!

    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set memes from AppDelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        tableView!.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Jump to addNewMeme if the array is nil
        if memes == nil {
            performSegueWithIdentifier("isEmpty", sender: nil)
            print("memes array is nil")
        }
    }
    


    // MARK: - Meme table view data source

    // Return the number of rows in the array.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
        
    }

      // Create the table view custom cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell") as! MemeTableViewCell
        
        let data = memes[indexPath.row]
        cell.imageView?.image = data.memedImage
        cell.textLabel?.text = data.topText
        
        return cell
        
    }
        
    @IBAction func addNewMeme(sender: AnyObject) {
        performSegueWithIdentifier("isEmpty", sender: nil)
    }
    
}