//
//  SellViewController.swift
//  YardSale
//
//  Created by Caitlyn Chen on 12/21/16.
//  Copyright © 2016 Caitlyn Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import GooglePlaces
import GoogleMaps
import FirebaseAuth

class SellViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var chooseLocLabel: UILabel!
    @IBOutlet weak var search: UISearchBar!
//    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView?
    var imagePicker = UIImagePickerController()
    
    var conStr: String?
    
    var place: GMSPlace?
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var captionTextView: UITextView!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var conditionTextField: UITextField!
    var items: [ItemObject] = []
    
    override func viewDidAppear(_ animated: Bool) {
        if place != nil{
//            locationLabel.text = place?.formattedAddress
            search.text = place?.formattedAddress
            chooseLocLabel.isHidden = true
        }
        if conStr != nil {
            conditionTextField.text = conStr
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)
        
        conditionTextField.isEnabled = false
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraButtonTapped(sender: AnyObject) {
        //println("hi")
        
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Only show camera option if rear camera is available
        if (UIImagePickerController.isCameraDeviceAvailable(.rear)) {
            let cameraAction = UIAlertAction(title: "Photo from Camera", style: .default) { (action) in
                //                imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            
            alertController.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .default) { (action) in
            //            let imagePicker = UIImagePickerController()
            //            imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        
        alertController.addAction(photoLibraryAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        cameraButton.isHidden = true
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imageView?.contentMode = .scaleAspectFit //3
        imageView?.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
    }
    @IBAction func conditionButtonTapped(_ sender: Any) {
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToManage", sender: self)
    }

    func dismissKeyboard(){
        view.endEditing(true)
    }
    

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "unwindToManage"{
            
            if(titleTextField.text == ""){
                
                let alertUpdate = UIAlertController(title: "Please enter a title!", message: "A title is required to post an item.", preferredStyle: .alert)
                let alert = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                alertUpdate.addAction(alert)
                self.present(alertUpdate, animated: true, completion: nil)
                
                return false
                
            } else if(captionTextView.text == ""){
                
                let alertUpdate = UIAlertController(title: "Please enter a caption!", message: "A caption is required to post an item.", preferredStyle: .alert)
                let alert = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                alertUpdate.addAction(alert)
                self.present(alertUpdate, animated: true, completion: nil)
                
                return false
                
                
            } else if(priceTextField.text == ""){
                
                let alertUpdate = UIAlertController(title: "Please enter a price!", message: "A price is required to post an item.", preferredStyle: .alert)
                let alert = UIAlertAction(title: "OL", style: UIAlertActionStyle.default)
                alertUpdate.addAction(alert)
                self.present(alertUpdate, animated: true, completion: nil)
                
                return false

                
            }else if(conditionTextField.text == ""){
                
                let alertUpdate = UIAlertController(title: "Please choose a condition!", message: "The condition is required to post an item.", preferredStyle: .alert)
                let alert = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                alertUpdate.addAction(alert)
                self.present(alertUpdate, animated: true, completion: nil)
                
                return false

                
            }else if (imageView?.image == nil){
                
                let alertUpdate = UIAlertController(title: "Please choose an image!", message: "An image is required to post an item!", preferredStyle: .alert)
                let alert = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                alertUpdate.addAction(alert)
                self.present(alertUpdate, animated: true, completion: nil)
                
                return false
                
            } else if (place == nil){
                
                let alertUpdate = UIAlertController(title: "Please choose an location!", message: "An location is required to post an item!", preferredStyle: .alert)
                let alert = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                alertUpdate.addAction(alert)
                self.present(alertUpdate, animated: true, completion: nil)
                
                return false
                
            }
            else{
                
                let storage = FIRStorage.storage()
                
                let storageRef = storage.reference(forURL: "gs://yardsale-cd99c.appspot.com")
                
                
                let ref = FIRDatabase.database().reference(withPath: "item-name")
                let itemRef = ref.child(titleTextField.text!)
                
                let imageData: NSData = UIImagePNGRepresentation((imageView?.image)!)! as NSData
                
                let imageRef = storageRef.child(titleTextField.text!)
                
                let uploadTask = imageRef.put(imageData as Data, metadata: nil) { metadata, error in
                    if error != nil {
                    } else {
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        let downloadURL = metadata!.downloadURL()
                        
                        let price = round(Double(self.priceTextField.text!)!*100)/100
                        let items = ItemObject(title: self.titleTextField.text!, price: Double(price), condition: self.conditionTextField.text!, caption: self.captionTextView.text, imageUrl: String(describing: downloadURL!), createdAt: String(describing: NSDate()), addressStr: self.search.text!, latCoor: (self.place?.coordinate.latitude)!, longCoor: (self.place?.coordinate.longitude)!, addedByUser: (FIRAuth.auth()?.currentUser?.email)!)
                        itemRef.setValue(items.toAnyObject())
                        
                        
                    }
                    
                }

            }
            

        }
        
        return true
        
    }
    
    @IBAction func unwindToSell(segue: UIStoryboardSegue){
        
    }
    @IBAction func unwindToSellFromCon(segue: UIStoryboardSegue){
        
    }
    

}

