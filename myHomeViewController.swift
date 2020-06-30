//
//  myHomeViewController.swift
//  toys
//
//  Created by Thanakorn Kaewsawang on 27/5/2562 BE.
//  Copyright © 2562 Thanakorn K. All rights reserved.
//

import UIKit
import Firebase

class myHomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath) as! CollectionViewCell
        //ref = Database.database().reference()
        
        /*let allPlaces = self.ref.child("items")
         
         allPlaces.observeSingleEvent(of: .value, with: { snapshot in
         for child in snapshot.children {
         let snap = child as! DataSnapshot
         let placeDict = snap.value as! [String: Any]
         let info = placeDict["itemName"] as! String
         //let x = placeDict["itemName"] as! [String]
         self.s[self.i] = info
         self.i+=1;
         //let moreInfo = placeDict["moreinfo"] as! String
         print(self.s[self.i]+String(self.i))
         }
         })*/
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        cell.itemModel = arrData[indexPath.item]
        
        
        //cell.toyLabel.text = toys[indexPath.item]
        //cell.toyImageView.image = toyImage[indexPath.item]
        cell.layer.borderColor  = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        
        return cell
    }
    
    var ref: DatabaseReference!

    //ref = Database.database().reference()
    //let vc = MainViewController()
    var selectname:String = ""
    var selectDcs: String=""
    var selectimg = ""
    var selectprice:String = ""
    var selecttype:String = ""
    var selectowner:String = ""
    var selectitemId:String = ""
    var selectdeliveryPrice:String = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //@IBOutlet weak var allBtn: UIButton!
   // @IBOutlet weak var typeBtn: UIButton!
    //@IBOutlet weak var collectionView: UICollectionView!
    
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
        
        
        //self.allBtn.isSelected = true
        //self.getAllFIRData()
        // Do any additional setup after loading the view.
        
        let a = Auth.auth().currentUser?.uid
        self.chooseDevelopment(x: a!)
    }

    
    func getAllFIRData(){
        ref = Database.database().reference()
        self.ref.child("items").queryOrderedByKey().observe(.value) { (snapshot) in
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
   
    func chooseDevelopment(x:String){
        ref = Database.database().reference()
        self.ref.child("items").queryOrdered(byChild: "owner").queryEqual(toValue: x).observe(.value) { (snapshot) in
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
        performSegue(withIdentifier: "myitemdesc", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //let vc = segue.destination as! myItemDescViewController
        //vc.itemId = self.selectitemId
        
        if segue.identifier == "myitemdesc" {
            if let svc = segue.destination as? myItemDescViewController {
                print("1")
                svc.itemId = self.selectitemId
                
            }
        } else if segue.identifier == "newItem" {
            if let svc = segue.destination as? addItemViewController {
                print("2")
            }
        }
        
        //let vc = segue.destination as! myItemDescViewController
        //let vcc = segue.destination as! addItemViewController
    
        //vc.finalname = self.selectname
        //vc.Description = self.selectDcs
        //vc.Data = self.Data
        //vc.price = self.selectprice
        //vc.type = self.selecttype
        //vc.owner = self.selectowner
        //vc.itemId = self.selectitemId
        //vcc.count = 0
        //vc.deliveryPrice = self.selectdeliveryPrice
        //vc.item = self.Data
        //vc.url = self.selectimg
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.lightGray.cgColor
        cell?.layer.borderWidth = 0.5
    }
    
    
}
