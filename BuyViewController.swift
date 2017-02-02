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

class BuyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate{
    

    @IBOutlet weak var searchBar: UISearchBar!
    var storageRef: FIRStorageReference?
    

  
    @IBOutlet weak var searchNavBar: UINavigationBar!
    var items: [ItemObject] = []

    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var estcurrentLoc : CLLocation = CLLocation(latitude: 0, longitude: 0)
    
    var queryswitch = 1
    var previousquery = 1
    
    var results : [ItemObject] = []


//    var dict: [CLLocationDistance:ItemObject] = [:]
    override func viewDidAppear(_ animated: Bool) {
        estcurrentLoc = currentLoc

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if queryswitch != previousquery{
            queryswitch = previousquery
            queries()
        }
    }
    @IBOutlet weak var uppertableViewConstraint: NSLayoutConstraint!
    @IBAction func searchButtonTapped(_ sender: Any) {
        searchNavBar.isHidden = false
        uppertableViewConstraint.constant = uppertableViewConstraint.constant + 30
        
        searchBar.isHidden = false

    }
    @IBAction func cancelSearchButtonTapped(_ sender: Any) {
        
        searchNavBar.isHidden = true
        
        searchBar.isHidden = true
        uppertableViewConstraint.constant = uppertableViewConstraint.constant - 30

        
        searchBar.endEditing(true)
        results = []
        tableView.reloadData()
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchNavBar.isHidden = true
        
        searchBar.isHidden = true
        
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
        searchBar.delegate = self

        queries()
        

        locationManager.startUpdatingLocation()
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func queries() {
        let ref = FIRDatabase.database().reference(withPath: "item-name")

        switch queryswitch{
        case 0:
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
                self.tableView.reloadData()
            })
        case 1:
            ref.observe(.value, with: { snapshot in
                var newItems: [ItemObject] = []
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm:ss Z"
                
                
                var dictionary: [Date:ItemObject] = [:]
                
                for item in snapshot.children {
                    let itemOb = ItemObject(snapshot: item as! FIRDataSnapshot)
                    dictionary.updateValue(itemOb, forKey: dateFormatter.date(from: itemOb.createdAt)!)
                }
                
                
                let sorteddict = dictionary.sorted(by: { $0.key < $1.key })
                for i in sorteddict {
                    newItems.append(i.value)
                }
                self.items = newItems
                self.tableView.reloadData()
            })
            
        case 2:
            ref.observe(.value, with: { snapshot in
                var newItems: [ItemObject] = []
                
                
                var dictionary: [Double:ItemObject] = [:]
                
                for item in snapshot.children {
                    let itemOb = ItemObject(snapshot: item as! FIRDataSnapshot)
                    dictionary.updateValue(itemOb, forKey: itemOb.price)
                }
                
                
                let sorteddict = dictionary.sorted(by: { $0.key < $1.key })
                for i in sorteddict {
                    newItems.append(i.value)
                }
                self.items = newItems
                self.tableView.reloadData()
            })

            
        default:
            print("yikes")
            
            
            
        }

    }
    
    var currentLoc : CLLocation = CLLocation(latitude: 0, longitude: 0)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let clloc = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        currentLoc = clloc
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if results.count == 0{
            return items.count

        }
        return results.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! CustomTableViewCell
        var itemOb : ItemObject = items[indexPath.row]
        
        if results.count != 0 {
            itemOb = results[indexPath.row]
        }
        
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: itemOb.imageUrl)
            cell.imgView.sd_setImage(with: url)

            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }

        let startindex = itemOb.createdAt.index(itemOb.createdAt.startIndex, offsetBy: 5)
        let endindex = itemOb.createdAt.index(itemOb.createdAt.startIndex, offsetBy: 7)
        let str = itemOb.createdAt[startindex...endindex]
        
        let monthstr =  monthString(x: str)
        print(monthstr)
        
        let startindexd = itemOb.createdAt.index(itemOb.createdAt.startIndex, offsetBy: 8)
        let endindexd = itemOb.createdAt.index(itemOb.createdAt.startIndex, offsetBy: 10)
        let montdstr = itemOb.createdAt[startindexd...endindexd]
        
        cell.dateLabel.text = monthstr + montdstr
        cell.titleLabel.text = itemOb.title
        cell.priceLabel.text = "$" + String(itemOb.price)
        cell.conditionLabel.text = itemOb.condition
        cell.addressLabel.text = itemOb.addressStr
        let rounded = round(itemOb.calculateDistance(fromLocation: estcurrentLoc)/1609.344*100)/100
        cell.distance.text = String(rounded) + "mi"
        
        return cell
    }

    func monthString(x: String) -> String{
        if x == "01"{
            return "Jan"
        } else if x == "02"{
            return "Feb"
        }else if x == "03"{
            return "Mar"
        }
        else if x == "04"{
            return "Apr"
        }
        else if x == "05"{
            return "May"
        }
        else if x == "06"{
            return "June"
        }
        else if x == "07"{
            return "July"
        }else if x == "08"{
            return "Aug"
        }
        else if x == "09"{
            return "Sep"
        }
        else if x == "10"{
            return "Oct"
        }else if x == "11"{
            return "Nov"
        }
        else if x == "12"{
            return "Dec"
        }
        
        
     return ""
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty == false {
            results = items.filter({(it: ItemObject) -> Bool in
                return it.title.range(of: searchText, options: .caseInsensitive) != nil
            })
            
        }
        
        if searchText == ""{
            results = items
        }
        
        tableView.reloadData()
    }
    
    var selectedItem : ItemObject?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedItem = items[indexPath.row]

        self.performSegue(withIdentifier: "toBuyItem", sender: nil)
        
    }

    @IBAction func sortByTapped(_ sender: Any) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBuyItem"{
            let dvc = segue.destination as! BuyItemViewController
            dvc.item = self.selectedItem

        } else if segue.identifier == "toSort"{
            
            let dvc = segue.destination as! SortViewController
            dvc.index = queryswitch
        } 
    }
 
    @IBAction func unwindToBuy(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func unwindToBuyFromSort(segue: UIStoryboardSegue){
        
    }
    

}
