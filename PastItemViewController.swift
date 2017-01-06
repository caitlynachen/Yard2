//
//  BuyItemViewController.swift
//  YardSale
//
//  Created by Caitlyn Chen on 1/2/17.
//  Copyright © 2017 Caitlyn Chen. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

class PastItemViewController: UIViewController {
    
    var item: ItemObject?
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var address: UIButton!
    
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.topItem!.title = ""
        navBar.topItem!.title = item?.title
        address.setTitle(item?.addressStr, for: .normal)
        caption.text = item?.caption
        condition.text = item?.condition
        
        let prices = item?.price
        let priceString = String(format: "%.01f", prices!)
        
        price.text = priceString
        
        
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: (self.item?.imageUrl)!)
            self.imageView.sd_setImage(with: url)
            
            
        }
        

    }
    @IBAction func commentBut(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toPastCom", sender: self)
    }
    
    @IBAction func addressBut(_ sender: Any) {
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
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPastCom"{
            let dvc = segue.destination as! PastComViewController
            dvc.item = self.item
            
            
        }
    }
    @IBAction func unwindToPastItem(segue: UIStoryboardSegue){
        
    }
    
}
