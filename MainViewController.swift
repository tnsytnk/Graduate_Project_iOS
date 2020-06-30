//
//  MainViewController.swift
//  toys
//
//  Created by Thanakorn Kaewsawang on 11/5/2562 BE.
//  Copyright © 2562 Thanakorn K. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController
,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,UITextFieldDelegate{
    
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
    var selectstatus:String = ""
   
    
   
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrData = [itemModel]()
    var Data :itemModel!
    
    @IBOutlet weak var searchTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        searchTF.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width-20)/2, height: self.collectionView.frame.size.height/3)
    
      
        self.allBtn.isSelected = true
        self.getAllFIRData()
        // Do any additional setup after loading the view.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getAllFIRData(){
        ref = Database.database().reference()
        self.ref.child("items").queryOrdered(byChild: "status").queryEqual(toValue: "available").observe(.value) { (snapshot) in
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
                        
                        let itemImageURL = mainDict["itemURL1"] as? String ?? ""
                        
                        let status = mainDict["status"] as? String
                        
                        
                        self.arrData.append(itemModel(name: name!, price: price!, description: description!,type: type!, itemImageURL: itemImageURL,owner: owner!,itemId:itemId!,deliveryPrice:deliveryPrice!, status:status!))
                        self.collectionView.reloadData()
                        
                    }
                }
            }
        }
    }
    @IBAction func allTapped(_ sender: Any) {
        self.getAllFIRData()
        self.allBtn.isSelected = true
        self.typeBtn.isSelected = false
    }
    
    func chooseDevelopment(x:String){
        ref = Database.database().reference()
        self.ref.child("items").queryOrdered(byChild: "development").queryEqual(toValue: x).observe(.value) { (snapshot) in
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
                        self.arrData.append(itemModel(name: name!, price: price!, description: description!,type: type!, itemImageURL: itemImageURL,owner: owner!,itemId:itemId!,deliveryPrice:deliveryPrice!,status: status!))
                        self.collectionView.reloadData()
                        
                    }
                }
            }
        }
    }
    
    @IBAction func typeTapped(_ sender: Any) {
        
        self.allBtn.isSelected = false
        self.typeBtn.isSelected = true
        

        
        //let okAction: UIAlertAction = UIAlertAction(title: "ตกลง", style: .default, handler: nil)
        
        
        let alert: UIAlertController = UIAlertController(title: "เลือกพัฒนาการ", message: "เลือกการเสริมสร้างพัฒนาการดังต่อไปนี้", preferredStyle: .alert)
        
        let action1: UIAlertAction = UIAlertAction(title: "เสริมกล้ามเนื้อ ประสานสัมพันธ์", style: .default, handler: { action in self.chooseDevelopment(x:"เสริมกล้ามเนื้อ ประสานสัมพันธ์")
        })
        let action2: UIAlertAction = UIAlertAction(title: "สติปัญญา ความคิดสร้างสรรค์", style: .default, handler: { action in self.chooseDevelopment(x:"สติปัญญา ความคิดสร้างสรรค์")
        })
        let action3: UIAlertAction = UIAlertAction(title: "คำนวนเรขาคณิต - คณิตศาสตร์", style: .default, handler: { action in self.chooseDevelopment(x:"คำนวนเรขาคณิต - คณิตศาสตร์")
        })
        let action4: UIAlertAction = UIAlertAction(title: "เสริมประสบการณ์ชีวิต และวิทยาศาสตร์", style: .default, handler: { action in self.chooseDevelopment(x:"เสริมประสบการณ์ชีวิต และวิทยาศาสตร์")
        })
        
        let action5: UIAlertAction = UIAlertAction(title: "เครื่องเล่นสนามและครุภัณฑ์", style: .default, handler: { action in self.chooseDevelopment(x:"เครื่องเล่นสนามและครุภัณฑ์")
        })
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
        alert.addAction(action5)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return toys.count
        
        return arrData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
       
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //
        cell.itemModel = arrData[indexPath.item]
        //
      
        //cell.toyLabel.text = toys[indexPath.item]
        //cell.toyImageView.image = toyImage[indexPath.item]
        cell.layer.borderColor  = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
    
        return cell
        
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
        selectstatus = Data.status!
        performSegue(withIdentifier: "item", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! itemDetailViewController
        vc.finalname = self.selectname
        vc.Description = self.selectDcs
        vc.Data = self.Data
        vc.price = self.selectprice
        vc.type = self.selecttype
        vc.owner = self.selectowner
        vc.itemId = self.selectitemId
        vc.deliveryPrice = self.selectdeliveryPrice
        //vc.item = self.Data
        vc.url = self.selectimg
        vc.status = self.selectstatus
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.lightGray.cgColor
        cell?.layer.borderWidth = 0.5
    }
    
    
    func checkNil(){
        let alert: UIAlertController = UIAlertController(title: "กรอกข้อมูลไม่ครบ", message: "alertMessage", preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "ตกลง", style: .default, handler: nil)
        alert.addAction(okAction)
        
        
        if searchTF.text == ""{
            alert.message = "กรูณาใส่คำที่ต้องการค้นหา"
            self.present(alert, animated: true, completion: nil)
        }else{
            
        }
    }
    
    
    
    @IBAction func searchTapped(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "ไม่พบคำค้นหา", message: "alertMessage", preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "ตกลง", style: .default, handler: nil)
        alert.addAction(okAction)
        
        
        if searchTF.text == ""{
            alert.message = "กรูณาใส่คำค้นหา"
            self.present(alert, animated: true, completion: nil)
        }else{
            ref = Database.database().reference()
            self.ref.child("items").queryOrdered(byChild: "itemName").queryEqual(toValue: searchTF.text).observe(.value) { (snapshot) in
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
                            self.arrData.append(itemModel(name: name!, price: price!, description: description!,type: type!, itemImageURL: itemImageURL,owner: owner!,itemId:itemId!,deliveryPrice:deliveryPrice!,status: status!))
                            self.collectionView.reloadData()
                            
                        }
                    }
                }
                if self.arrData.count == 0 {
                    let alert: UIAlertController = UIAlertController(title: "ไม่พบข้อมูล!", message: "ไม่พบของเล่นที่มีชื่อตรงกัน", preferredStyle: .alert)
                    
                    let okAction: UIAlertAction = UIAlertAction(title: "ตกลง", style: .default, handler: nil)
                    
                    alert.addAction(okAction)
                    self.getAllFIRData()
                    self.present(alert, animated: true, completion: nil)
                    //getAllFIRData()
                }
            }
            
            
            
            
            
        }
            
        }
        
        
    


    }
