//
//  ListDMUsersViewController.swift
//  Yard2
//
//  Created by Caitlyn Chen on 2/1/17.
//  Copyright © 2017 Caitlyn Chen. All rights reserved.
//

import UIKit
import Firebase

class ListDMUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var commentRef: FIRDatabaseReference?

    var comments: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

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


        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DMProfCell", for: indexPath)
        let itemOb = comments[indexPath.row]
        
        cell.textLabel?.text = itemOb
    
        
        return cell
    }
    
    var selectedUser: String?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedUser = comments[indexPath.row]
        
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
