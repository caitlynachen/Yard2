




import UIKit
import Firebase

class SearchViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var items : [ItemObject] = []
    var itemstr: [String] = []
    
    var data: [String] = []
    //put items in here instead
    
    var filteredData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = FIRDatabase.database().reference(withPath: "item-name")
        
        ref.observe(.value, with: { snapshot in
            var newItems: [ItemObject] = []
            var newstr: [String] = []
            
            for item in snapshot.children {
                let itemOb = ItemObject(snapshot: item as! FIRDataSnapshot)
                newItems.append(itemOb)
                newstr.append(itemOb.title)
            }
            self.itemstr = newstr
            self.items = newItems
            self.tableView.reloadData()
        })

        
        
        tableView.dataSource = self
        searchBar.delegate = self
//        filteredData = itemstr
    }
    var results : [ItemObject] = []


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! UITableViewCell
        let itemOb = results[indexPath.row]
        
        
//        DispatchQueue.global(qos: .background).async {
//            let url = URL(string: itemOb.imageUrl)
//            cell.imgView.sd_setImage(with: url)
//            
//            DispatchQueue.main.async {
//                tableView.reloadData()
//            }
//        }
        
        cell.textLabel?.text = itemOb.title
//        cell.priceLabel.text = String(itemOb.price)
//        cell.conditionLabel.text = itemOb.condition
//        cell.addressLabel.text = itemOb.addressStr
//        let rounded = round(itemOb.calculateDistance(fromLocation: estcurrentLoc)/1609.344*100)/100
//        cell.distance.text = String(rounded) + "mi"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty == false{
        results = items.filter({(it: ItemObject) -> Bool in
            return it.title.range(of: searchText, options: .caseInsensitive) != nil
        })

        }

        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

