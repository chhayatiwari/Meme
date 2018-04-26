//
//  MemeEditorViewController.swift
//  Meme
//
//  Created by Chhaya Tiwari on 4/1/18.
//  Copyright © 2018 ChhayaTiwari. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraPicker: UIBarButtonItem!
    @IBOutlet weak var navButton: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    var memedImage: UIImage!
   
    var isBottomActive = false
    var memes: [Meme]!
    var memeToEdit: Meme? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startPage()
        configure(textField: topText, withText: "TOP")
        configure(textField: bottomText, withText: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraPicker.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        if (memeToEdit != nil) {
            
            imagePicker.image = memeToEdit?.image
            topText.text = memeToEdit?.toptext
            bottomText.text = memeToEdit?.bottomtext
            
            shareButton.isEnabled = true
            topText.isHidden = false
            bottomText.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    func startPage() {
        self.shareButton.isEnabled = false
        imagePicker.image = UIImage()
    }
    
   func configure(textField: UITextField, withText text: String)
    {
        textField.delegate = self
        let memeTextAttributes:[String: Any] =
            [NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
             NSAttributedStringKey.foregroundColor.rawValue: UIColor.white, NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,NSAttributedStringKey.strokeWidth.rawValue: -3]
        textField.text = text
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.isHidden = true
    }
    
    func hideTopAndBottomBars(_ hide: Bool) {
        self.toolBar.isHidden = hide
        self.navButton.isHidden = hide
    }
    
    func generateMemedImage() -> UIImage {
       hideTopAndBottomBars(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        if let mmedImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            memedImage = mmedImage
        }
        else {
            let alert = UIAlertController(title: "Alert", message: "Empty data", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
       hideTopAndBottomBars(false)
        return memedImage
    }
    
    func save()  {
        let meme1 = Meme(toptext: topText.text!, bottomtext: bottomText.text!, image: imagePicker.image!, meme: generateMemedImage())
        
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme1)
         dismiss(animated: true, completion: nil)
    
    }
    
    func alerthandler(msg: String, tit: String) {
        let ac = UIAlertController(title: tit, message: msg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if let error = error {
                self.alerthandler(msg: error.localizedDescription, tit: "Share not Completed")
                   }
            else
            if completed {
                self.save()
                 }
               }
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = sourceType
        present(myPickerController, animated: true, completion: nil)
    }
    
    @IBAction func albumSelected(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            presentImagePickerWith(sourceType: .photoLibrary)
        }
    }
    
    @IBAction func cameraSelected(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
           presentImagePickerWith(sourceType: .camera)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePicker.image = image
            dismiss(animated: true, completion: nil)
        }
        shareButton.isEnabled = true
        topText.isHidden = false
        bottomText.isHidden = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func topTouch(_ sender: Any) {
        isBottomActive = false
    }
    
    @IBAction func bottomTouch(_ sender: Any) {
        isBottomActive = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if topText.text == "TOP" {
            topText.text = ""
        } else
            if bottomText.text == "BOTTOM" {
                bottomText.text = ""
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if isBottomActive {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

