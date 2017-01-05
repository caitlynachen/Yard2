//
//  BuyViewController.swift
//  YardSale
//
//  Created by Caitlyn Chen on 12/23/16.
//  Copyright © 2016 Caitlyn Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage
import MapKit

class BuyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{
    
    var storageRef: FIRStorageReference?
    
    var items: [ItemObject] = []

    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var estcurrentLoc : CLLocation?


//    var dict: [CLLocationDistance:ItemObject] = [:]
    override func viewDidAppear(_ animated: Bool) {
        estcurrentLoc = currentLoc

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

        
        storageRef = FIRStorage.storage().reference(forURL: "gs://yardsale-cd99c.appspot.com")
        
        tableView.delegate = self
        tableView.dataSource = self
        let ref = FIRDatabase.database().reference(withPath: "item-name")

        ref.observe(.value, with: { snapshot in
            var newItems: [ItemObject] = []
            
            var dictionary: [CLLocationDistance:ItemObject] = [:]

            for item in snapshot.children {
                let itemOb = ItemObject(snapshot: item as! FIRDataSnapshot)
                dictionary.updateValue(itemOb, forKey: itemOb.calculateDistance(fromLocation: self.currentLoc))
            }


            let sorteddict = dictionary.sorted(by: { $0.key < $1.key })
            for i in sorteddict {
                newItems.append(i.value)
            }
            self.items = newItems
//            self.dict = dictionary
            self.tableView.reloadData()
        })
        

        // Do any additional setup after loading the view.
    }
    
    var currentLoc : CLLocation?
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let clloc = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        currentLoc = clloc
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! CustomTableViewCell
        let itemOb = items[indexPath.row]
        
        
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: itemOb.imageUrl)
            cell.imgView.sd_setImage(with: url)

            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        //let data = NSData(contentsOf: url!)
        //if data != nil{
        //    cell.imgView.image = UIImage(data: data as! Data)
        //}

        cell.titleLabel.text = itemOb.title
        cell.priceLabel.text = String(itemOb.price)
        cell.conditionLabel.text = itemOb.condition
        cell.addressLabel.text = itemOb.addressStr
        let rounded = round(itemOb.calculateDistance(fromLocation: estcurrentLoc)/1609.344*100)/100
        cell.distance.text = String(rounded) + "mi"
        
        return cell
    }

    var selectedItem : ItemObject?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedItem = items[indexPath.row]

        self.performSegue(withIdentifier: "toBuyItem", sender: nil)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBuyItem"{
            let dvc = segue.destination as! BuyItemViewController
            dvc.item = self.selectedItem

        }
    }
 
    @IBAction func unwindToBuy(segue: UIStoryboardSegue){
        
    }
    

}
