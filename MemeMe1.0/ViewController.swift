//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Stella Su on 9/1/15.
//  Copyright (c) 2015 Million Stars, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var actionBotton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imagePickView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // Attributes for styling the text in the text fields
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : NSNumber(float: -3.0)
        
    ]

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Setup the top text input
        setupTextField(topTextField, text: "TOP", delegate: self, attributes: memeTextAttributes, alignment: NSTextAlignment.Center)
        setupTextField(bottomTextField, text: "BOTTOM", delegate: self, attributes: memeTextAttributes, alignment: NSTextAlignment.Center)
 
    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        subscribeToKeyboardNotifications()
        
        // Disable the camera button if the device doesn't have a camera
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
    }
    
    // Unsubscribe
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Move the view when the keyboard covers the text field
    // NSNotification is announcing the keyboard is showing or disappearing
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

    // Allows the user to use the return key to escape from the text input
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    // Removes this ViewController as an observer for keyboard notifications
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    
    // Let the user to pick an image from either the photo library or from the camera
    @IBAction func pickAnImage(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if sender.title == "Album"{
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            presentViewController(imagePicker, animated: true, completion: nil)
        } else{
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }

    // Passes the image selected by the user to the imagePickView
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //imagePickView.contentMode = UIViewContentMode.ScaleAspectFit
            imagePickView.image = image
        } else {
            println("No image was picked")
        }
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    // Setup the textFields in the memeEditor
    func setupTextField (textField: UITextField, text: String, delegate: UITextFieldDelegate, attributes: [String : NSObject], alignment: NSTextAlignment) {
        textField.text = text
        textField.delegate = delegate
        textField.defaultTextAttributes = attributes
        textField.textAlignment = alignment
    }
   
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        toolBar.hidden = true
        navBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        toolBar.hidden = false
        navBar.hidden = false
       
        return memedImage
    }

    
    // Shares and saves a MemedImage
    @IBAction func shareMemedImage(sender: UIBarButtonItem) {
        
        // Generated a memed image
        let memedImage = generateMemedImage()
        
        // Creates a new ActivityViewController
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        // Closure for handling the users action with the ActivityViewController
        activityViewController.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                
                // Save the meme
                self.save()
                
                // Dismiss the Activity View
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }
        }
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    // Create a meme object and add it to the memes array
    func save() {
        
        // Create the meme
        let memeImage = generateMemedImage()
        var meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, imageView: imagePickView, memedImage: memeImage)
        
        // Add to the memes array on the Application Delegate.      
        //(UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }

    
    @IBAction func cancelAction(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}


    


