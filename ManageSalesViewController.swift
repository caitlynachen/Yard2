//
//  BuyViewController.swift
//  
//
//  Created by Caitlyn Chen on 12/21/16.
//
//

import UIKit
import Firebase
import FirebaseAuth
import MapKit

class ManageSalesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var items: [ItemObject] = []
    let ref = FIRDatabase.database().reference(withPath: "item-name")

    let locationManager = CLLocationManager()
    var estcurrentLoc : CLLocation?
    var results : [ItemObject] = []

    
    @IBOutlet weak var uppertableViewConstraint: NSLayoutConstraint!

    @IBAction func searchTapped(_ sender: Any) {
        searchNavBar.isHidden = false
        uppertableViewConstraint.constant = uppertableViewConstraint.constant + 30
        
        searchBar.isHidden = false

    }
 
    @IBAction func cancelSearch(_ sender: Any) {
        searchNavBar.isHidden = true
        
        searchBar.isHidden = true
        uppertableViewConstraint.constant = uppertableViewConstraint.constant - 30
        
        
        searchBar.endEditing(true)
        results = []
        tableView.reloadData()

    }

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchNavBar: UINavigationBar!
    override func viewDidAppear(_ animated: Bool) {
        estcurrentLoc = currentLoc
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchNavBar.isHidden = true
        
        searchBar.isHidden = true
        
        self.tableView.rowHeight = 144
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
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
        
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

        // Do any additional setup after loading the view.
    }
    
    var currentLoc : CLLocation?
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let clloc = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        currentLoc = clloc
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if results.count == 0{
            return items.count
            
        }
        return results.count    }
    
    var itemRow: Int?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ManageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "manCell", for: indexPath) as! ManageTableViewCell
        var itemOb = items[indexPath.row]
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

        itemRow = indexPath.row
        
        cell.titleLabel.text = itemOb.title
        cell.priceLabel.text = String(itemOb.price)
        cell.conditionLabel.text = itemOb.condition
        cell.addressLabel.text = itemOb.addressStr
        let rounded = round(itemOb.calculateDistance(fromLocation: currentLoc)/1609.344*100)/100
        cell.distance.text = String(rounded) + "mi"
        
        
        return cell
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let actionSheetController: UIAlertController = UIAlertController()
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            }
            actionSheetController.addAction(cancelAction)
            let takePictureAction: UIAlertAction = UIAlertAction(title: "Delete", style: .default) { action -> Void in
                let deleteAlert: UIAlertController = UIAlertController(title: "Confirm Deletion.", message: "Delete?", preferredStyle: .alert)
                
                let dontDeleteAction: UIAlertAction = UIAlertAction(title: "Don't Delete", style: .cancel) { action -> Void in
                }
                deleteAlert.addAction(dontDeleteAction)
                let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .default) { action -> Void in
                    
                    let itemOb = self.items[indexPath.row]
                    itemOb.ref?.removeValue()
                }
                deleteAlert.addAction(deleteAction)
                
                
                self.present(deleteAlert, animated: true, completion: nil)
            }
            actionSheetController.addAction(takePictureAction)
            self.present(actionSheetController, animated: true, completion: nil)
            
        }
    }
    

    var selectedItem : ItemObject?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedItem = items[indexPath.row]
        
        self.performSegue(withIdentifier: "toManItem", sender: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    @IBAction func unwindToManage(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func unwindToManSales(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func unwindToManSold(segue: UIStoryboardSegue){
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toManItem"{
            let dvc = segue.destination as! ManageItemViewController
            dvc.item = self.selectedItem
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
