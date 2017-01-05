//
//  ConditionViewController.swift
//  YardSale
//
//  Created by Caitlyn Chen on 1/3/17.
//  Copyright © 2017 Caitlyn Chen. All rights reserved.
//

import UIKit

class ConditionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var conditionLabels = ["New", "Like New", "Good", "Fair", "Poor"]
    var descriptionLabels = ["New with tag, unused, unopened packaging", "New without tags, unused, no sign of use", "Gently used, functional, one/few minor flaws", "Used, functional, multiple flaws/defects", "Major flaws, may be damaged, for parts"]
    

    @IBOutlet weak var tableView: UITableView!
    
    var index: Int?
    
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ConditionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ConCell", for: indexPath) as! ConditionTableViewCell
        
        cell.condition.text = conditionLabels[indexPath.row]
        cell.descriptionLabel.text = descriptionLabels[indexPath.row]
        
        if indexPath.row == index{
            cell.chkButton.isHidden = false
        } else{
            cell.chkButton.isHidden = true
        }

        
        return cell
    }
    
    var selectedCon : Int?

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedCon = indexPath.row
        
        self.performSegue(withIdentifier: "unwindFromCon", sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFromCon"{
            let dvc = segue.destination as! SellViewController
            if selectedCon != nil{
                dvc.conStr = conditionLabels[selectedCon!]
                dvc.conInt = selectedCon!
            }
        }
        
    }
 

}
