//
//  ProfileViewController.swift
//  Yard2
//
//  Created by Caitlyn Chen on 1/5/17.
//  Copyright © 2017 Caitlyn Chen. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage

class ProfileViewController: UIViewController {

    @IBOutlet weak var moneyRaised: UILabel!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var imgView: UIImageView!
    
    var itemprices: [Double] = []
    override func viewDidLoad() {

        super.viewDidLoad()
        
        navBar.topItem?.title = FIRAuth.auth()?.currentUser?.email
        
        
        let ref = FIRDatabase.database().reference(withPath: "previous-posts")
        
        
        ref.observe(.value, with: { snapshot in
            var newItems: [Double] = []

            var sum = 0.0

            for item in snapshot.children {
                let itemOb = ItemObject(snapshot: item as! FIRDataSnapshot)
                
                newItems.append(itemOb.price)
            }
            
            self.itemprices = newItems
            
            for i in newItems {
                sum = sum + i
            }

            self.moneyRaised.text = String(sum)

        })
        

        
        

        // Do any additional setup after loading the view.
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        try! FIRAuth.auth()!.signOut()
        self.dismiss(animated: true, completion: nil)
        let newvc: UIViewController = LoginViewController() as UIViewController
        self.present(newvc, animated: true, completion: nil)

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToProfile(segue: UIStoryboardSegue){
        
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
