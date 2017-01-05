//
//  ManageItemViewController.swift
//  Yard2
//
//  Created by Caitlyn Chen on 1/4/17.
//  Copyright © 2017 Caitlyn Chen. All rights reserved.
//

import UIKit
import SDWebImage
import MapKit

class ManageItemViewController: UIViewController {
    
    @IBOutlet weak var navBAr: UINavigationBar!
    @IBOutlet weak var comment: UIButton!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var addressLabel: UIButton!
    @IBOutlet weak var conditionLabel: UILabel!
    var item: ItemObject?

    override func viewDidLoad() {
        super.viewDidLoad()

        navBAr.topItem!.title = ""
        navBAr.topItem!.title = item?.title
        addressLabel.setTitle(item?.addressStr, for: .normal)
        caption.text = item?.caption
        conditionLabel.text = item?.condition
        
        let prices = item?.price
        let priceString = String(format: "%.01f", prices!)
        
        price.text = priceString
        
        
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: (self.item?.imageUrl)!)
            self.imgView.sd_setImage(with: url)
            
            
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toCommView", sender: self)
    }
    
    
    @IBAction func addressButtonTapped(_ sender: Any) {
        
        let latitude:CLLocationDegrees =  (item?.latCoor)!
        let longitude:CLLocationDegrees =  (item?.longCoor)!
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(item?.title)"
        mapItem.openInMaps(launchOptions: options)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sellButtonTapped(_ sender: Any) {
        let actionSheetController: UIAlertController = UIAlertController()
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Sell", style: .default) { action -> Void in
            let deleteAlert: UIAlertController = UIAlertController(title: "Confirm Sale.", message: "Sell?", preferredStyle: .alert)
            
            let dontDeleteAction: UIAlertAction = UIAlertAction(title: "Don't Sell", style: .cancel) { action -> Void in
            }
            deleteAlert.addAction(dontDeleteAction)
            let deleteAction: UIAlertAction = UIAlertAction(title: "Sell", style: .default) { action -> Void in
                
                self.performSegue(withIdentifier: "unwindToManSold", sender: self)
                
                let itemOb = self.item
                itemOb?.ref?.removeValue()
            }
            deleteAlert.addAction(deleteAction)
            
            
            self.present(deleteAlert, animated: true, completion: nil)
        }
        actionSheetController.addAction(takePictureAction)
        self.present(actionSheetController, animated: true, completion: nil)
        

    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toCommView"{
            let dvc = segue.destination as! CommentViewController
            dvc.item = self.item
            //
            //            dvc.URLstr = newString
            //            print(newString)
            
            
            
        }
    }
 

}
