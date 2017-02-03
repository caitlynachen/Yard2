

import UIKit
import Firebase
import JSQMessagesViewController

class DMViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var item : ItemObject?
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var commentRef: FIRDatabaseReference?
    
    @IBOutlet weak var titleLabel: UILabel!
    var comments: [DMObject] = []
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        titleLabel.text = item?.addedByUser

        self.tableView.rowHeight = 70
        
        
        commentRef = FIRDatabase.database().reference(withPath: "dm")
        tableView.delegate = self
        tableView.dataSource = self
        
        let username = item?.addedByUser

        commentRef?.observe(.value, with: { snapshot in
            var newComs: [DMObject] = []
            
            for item in snapshot.children {
                let itemOb = DMObject(snapshot: item as! FIRDataSnapshot)
                if ((itemOb.createdBy == FIRAuth.auth()?.currentUser?.email && itemOb.sentTo == username) || (itemOb.sentTo ==  FIRAuth.auth()?.currentUser?.email && itemOb.createdBy == username)){
                    newComs.append(itemOb)

                }
            }
            
            self.comments = newComs
            self.tableView.reloadData()
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func sendButtonTap(_ sender: Any) {
        let comref = commentRef?.child(textField.text!)
        
        let comOb = DMObject(title: self.textField.text!, createdAt: String(describing: NSDate()), createdBy: (FIRAuth.auth()?.currentUser?.email)!, sentTo: (item?.addedByUser)!)
        
        
        comref?.setValue(comOb.toAnyObject())
        
        textField.text = ""
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DMCell", for: indexPath)
        let itemOb = comments[indexPath.row]
        
        cell.textLabel?.text = itemOb.title
        
        if itemOb.createdBy == FIRAuth.auth()?.currentUser?.email{
            cell.textLabel?.textColor = UIColor.black
            
        } else{
            cell.textLabel?.textColor = UIColor.blue
        }
        
        
        return cell
    }
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.bottomConstraint?.constant = 20.0
            } else {
                self.bottomConstraint?.constant = endFrame?.size.height ?? 30.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
   
}
