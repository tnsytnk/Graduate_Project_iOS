//
//  sellViewController.swift
//  toys
//
//  Created by Thanakorn Kaewsawang on 30/5/2562 BE.
//  Copyright © 2562 Thanakorn K. All rights reserved.
//

import UIKit
import Firebase

class sellViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var item = [String]()
    var status = [String]()
    var ref: DatabaseReference!
    var uid = Auth.auth().currentUser?.uid
    var itemId = ""
    var Data:String = ""
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var mycell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! UITableViewCell
        
        //mycell.textLabel?.text = order[indexPath.row]
        //mycell.textLabel?.text = arrData[indexPath.row].name
        mycell.textLabel?.text = item[indexPath.row]
        mycell.detailTextLabel?.text = status[indexPath.row]
        return mycell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Data = item[indexPath.row]
        self.itemId = Data
        performSegue(withIdentifier: "sell", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! orderInfoViewController
        vc.itemId = itemId//self.selectname
        
        
    }
    
    func getData(){
        ref = Database.database().reference()
        
        
        self.ref.child("sellOrder").child(uid!).queryOrderedByKey().observe(.value) { (snapshot) in
            self.item.removeAll()
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapShot{
                    if let mainDict = snap.value as? [String:AnyObject]{
                        let item = mainDict["itemId"] as? String
                        let status = mainDict["status"] as? String
                        
                        self.item.append(item!)
                        self.status.append(status!)
                        
                        self.tableView.reloadData()
                        //elf.table.collectionView.reloadData()
                        
                    }
                }
            }
        }
        
        
        
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
