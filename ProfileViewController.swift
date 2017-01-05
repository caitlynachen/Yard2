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

class ProfileViewController: UIViewController {

    @IBOutlet weak var moneyRaised: UILabel!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var imgView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.topItem?.title = FIRAuth.auth()?.currentUser?.email
        
        

        // Do any additional setup after loading the view.
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
