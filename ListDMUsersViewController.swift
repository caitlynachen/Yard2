//
//  ListDMUsersViewController.swift
//  Yard2
//
//  Created by Caitlyn Chen on 2/1/17.
//  Copyright © 2017 Caitlyn Chen. All rights reserved.
//

import UIKit
import Firebase

class ListDMUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var commentRef: FIRDatabaseReference?

    var userRef: FIRDatabaseReference?

    var allusers: [String] = []
    var comments: [String] = []
    
    var results : [String] = []


    @IBOutlet weak var uppertableViewConstraint: NSLayoutConstraint!
    
    
    @IBAction func searchButtonTap(_ sender: Any) {
        searchNavBar.isHidden = false
        uppertableViewConstraint.constant = uppertableViewConstraint.constant + 30
        
        searchBar.isHidden = false

    }
   
    @IBAction func cancelButTap(_ sender: Any) {
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
        self.tableView.rowHeight = 70

        
        commentRef = FIRDatabase.database().reference(withPath: "dm")
        tableView.delegate = self
        tableView.dataSource = self

        commentRef?.observe(.value, with: { snapshot in
            var newComs: [String] = []
            
            for item in snapshot.children {
                let itemOb = DMObject(snapshot: item as! FIRDataSnapshot)
                if  itemOb.sentTo ==  FIRAuth.auth()?.currentUser?.email {
                    if itemOb.createdBy != FIRAuth.auth()?.currentUser?.email{
                        newComs.append(itemOb.createdBy)
//                        newComs.push(itemOb.createdBy) unless newComs.include?(itemOb.createdBy)

                    }
                }
            }
            
            
            self.comments = newComs
            let unique = Array(Set(self.comments))
            self.comments = unique
            self.tableView.reloadData()
        })
        
        userRef = FIRDatabase.database().reference(withPath: "users")

        userRef?.observe(.value, with: { snapshot in
            var newComs: [String] = []
            
            let i = snapshot.value as! NSDictionary
           
            for x in i{
                let y = (x.value as! String)
//                self.allusers.append(x.value as! String)
                self.allusers.append(y)
                
            }
//            self.allusers = newComs
            print (self.allusers.count)

            self.tableView.reloadData()
        })
//        



        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var searchNavBar: UINavigationBar!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if results.count == 0{
            return comments.count
            
        }
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DMProfCell", for: indexPath)
        
//        print ("intableview" + "\(self.allusers.count)")

        
        if results.count != 0 {
            let itemOb = results[indexPath.row]
            cell.textLabel?.text = itemOb

        } else{
            let itemOb = comments[indexPath.row]
            cell.textLabel?.text = itemOb

        }
    
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("search\(allusers.count)")
        
        if searchText.isEmpty == false {
            results = allusers.filter({(it: String) -> Bool in
                return it.range(of: searchText, options: .caseInsensitive) != nil
            })
            
        }
        
        if searchText == ""{
            results = allusers
        }
        
        tableView.reloadData()
    }

    
    var selectedUser: String?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if results.count != 0{
            selectedUser = results[indexPath.row]

        } else{
            selectedUser = comments[indexPath.row]
        }
        self.performSegue(withIdentifier: "FromDMListToDM", sender: nil)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "FromDMListToDM"{
            let dvc = segue.destination as! DMProfileViewController
            dvc.userName = self.selectedUser
            //
            //            dvc.URLstr = newString
            //            print(newString)
            
            
            
        }
    }
    @IBAction func unwindFromDMToDMList(segue: UIStoryboardSegue){
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
