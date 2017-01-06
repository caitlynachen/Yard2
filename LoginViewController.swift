//
//  LoginViewController.swift
//  YardSale
//
//  Created by Caitlyn Chen on 12/24/16.
//  Copyright © 2016 Caitlyn Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {


    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var errorcheck: Error?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    @IBAction func createUserButtonTapped(_ sender: Any) {
        
     
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
       
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var shouldPerformSegue = false

        if identifier == "createUserToTab"{
            
            
            if self.emailTextField.text == "" || self.passwordTextField.text == ""
            {
                let alertController = UIAlertController(title: "Oops!", message: "Please enter an email and password.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                    
                    if error == nil
                    {
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        
                        shouldPerformSegue = true
                        
                        let top = UIApplication.shared.keyWindow!.rootViewController!
                        top.performSegue(withIdentifier: "createUserToTab", sender: top)
                        
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                    
                }
            }

        
        } else if identifier == "loginToTab"{
            
            
            if self.emailTextField.text == "" || self.passwordTextField.text == ""
            {
                let alertController = UIAlertController(title: "Oops!", message: "Please enter an email and password.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                    
                    
                    if error == nil
                    {
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        
                       shouldPerformSegue = true
                        
                        let top = UIApplication.shared.keyWindow!.rootViewController!
                        top.performSegue(withIdentifier: "loginToTab", sender: top)
                        
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                }
            }
            

        }
        
        return shouldPerformSegue
        
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
