//
//  sellerHomeViewController.swift
//  toys
//
//  Created by Thanakorn Kaewsawang on 13/6/2562 BE.
//  Copyright © 2562 Thanakorn K. All rights reserved.
//

import UIKit
import Firebase

class sellerHomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    var sellerId = ""
    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var phone: UILabel!
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath) as! CollectionViewCell
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        cell.itemModel = arrData[indexPath.item]
        
        cell.layer.borderColor  = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        
        return cell
    }
    
    var ref: DatabaseReference!
    
   
    var selectname:String = ""
    var selectDcs: String=""
    var selectimg = ""
    var selectprice:String = ""
    var selecttype:String = ""
    var selectowner:String = ""
    var selectitemId:String = ""
    var selectdeliveryPrice:String = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrData = [itemModel]()
    var Data :itemModel!
    
   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width-20)/2, height: self.collectionView.frame.size.height/3)
        self.sellerHomeData(x: sellerId)
        self.sellerData(a: sellerId)
    }
    
    
    func sellerData(a: String){
        ref = Database.database().reference()
        ref.child("users").child(a).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let name = value?["username"]as? String ?? ""
            self.name.text = name
            let phone = value?["phone"]as? String ?? ""
            let count = value?["ratingCount"] as? String ?? ""
            let c:Int = Int(Double(count)!)
            // ...
            
            
            
            //self.rating.text = ratingdb+" จากผู้ใช้ "+String(c)+" คน"
            self.phone.text = phone
            let rating = value?["rating"]as? String ?? ""
            self.rating.text = "Rating: "+rating+" จากผู้ใช้ "+String(c)+" คน"
        })}

    
    
    func sellerHomeData(x: String){
        ref = Database.database().reference()
        ref.child("items").queryOrdered(byChild: "owner" ).queryEqual(toValue: x).observe(.value) { (snapshot) in
            self.arrData.removeAll()
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapShot{
                    if let mainDict = snap.value as? [String:AnyObject]{
                        let name = mainDict["itemName"] as? String
                        let description = mainDict["itemDescription"] as? String
                        let price = mainDict["price"] as? String
                        let type = mainDict["type"] as? String
                        let owner = mainDict["owner"] as? String
                        let itemId = mainDict["itemId"] as? String
                        let deliveryPrice = mainDict["deliveryPrice"] as? String
                        let status = mainDict["status"] as? String
                        let itemImageURL = mainDict["itemURL1"] as? String ?? ""
                        
                        self.arrData.append(itemModel(name: name!, price: price!, description: description!,type: type!, itemImageURL: itemImageURL,owner: owner!,itemId:itemId!,deliveryPrice:deliveryPrice!,status:status!))
                        self.collectionView.reloadData()
                        
                    }
                }
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.borderWidth = 2
        Data = arrData[indexPath.item]
        selectname = Data.name!
        selectDcs = Data.description!
        selectimg = Data.itemImageURL!
        selectprice = Data.price!
        selectdeliveryPrice = Data.deliveryPrice!
        selecttype = Data.type!
        selectowner = Data.owner!
        selectitemId = Data.itemId!
        //performSegue(withIdentifier: "myitemdesc", sender: self)
        
        
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "myitemdesc" {
            if let svc = segue.destination as? myItemDescViewController {
                print("1")
                svc.itemId = self.selectitemId
                
            }
        }
        
       
    }*/
    
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.lightGray.cgColor
        cell?.layer.borderWidth = 0.5
    }
    
    
}
