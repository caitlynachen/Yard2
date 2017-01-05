//
//  SortViewController.swift
//  Yard2
//
//  Created by Caitlyn Chen on 1/4/17.
//  Copyright © 2017 Caitlyn Chen. All rights reserved.
//

import UIKit

class SortViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var conditionLabels = ["By Location", "By Date", "By Price"]

    var index: Int?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 60
        
        tableView.delegate = self
        tableView.dataSource = self
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conditionLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SortTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SortCell", for: indexPath) as! SortTableViewCell
        
        cell.sortLabel.text = conditionLabels[indexPath.row]
        
        if indexPath.row == index{
            cell.chkbutton.isHidden = false
        } else{
            cell.chkbutton.isHidden = true
        }
        return cell
    }
    
    var selectedCon : Int?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCon = indexPath.row
        
        self.performSegue(withIdentifier: "unwindToBuyFromSort", sender: self)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "unwindToBuyFromSort"{
            let dvc = segue.destination as! BuyViewController
            if selectedCon != nil{
                dvc.previousquery = selectedCon!
            }
        }

    }
    

}
