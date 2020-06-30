//
//  itemDetailViewController.swift
//  toys
//
//  Created by Thanakorn Kaewsawang on 29/5/2562 BE.
//  Copyright © 2562 Thanakorn K. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class itemDetailViewController: UIViewController {
    
    var Data :itemModel?
    var ref: DatabaseReference!

    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet var dcs: UITextView!
    
    
    @IBOutlet weak var buybtn: UIButton!
    @IBOutlet weak var typebtn: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var img1: UIImageView!
    var finalname = ""
    var Description = ""
    var status = ""
    var url=""
    var price = ""
    var type = ""
    var owner = ""
    var itemId = ""
    var coinsAfterOrder : Int = 0
    var deliveryPrice = ""
    let User = Auth.auth().currentUser
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "sellerid" {
            if let svc = segue.destination as? sellerHomeViewController {
                print("1")
                svc.sellerId = self.owner
                
            }
        }
        
        
    }
    
    
    
    @IBAction func boxTapped(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "ค่าจัดส่งของเล่น "+self.deliveryPrice+" บาท", message: "ผู้แลกของเล่นต้องจ่ายเป็นเงินสดให้แก่บริษัทส่งของ", preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "ตกลง", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
   
    
    func checkCoins(price:String) {
        let user = Auth.auth().currentUser
        ref = Database.database().reference()
        //var bool:Bool = true
    
        let p:Int = Int(price)!// ?? 0
        var c:Int? = 0
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let coins = value?["coins"]as? String ?? ""
            c = Int(coins)!// ?? 0
            print(c)
            if let cc = c, p > cc{
                //bool = false
                print("cant")
                print(p)
                print(cc)
                //return false -> cantBuy
                print("cantBuy")
                let alert: UIAlertController = UIAlertController(title: "เหรียญไม่พอ", message: "จำนวนเหรียญไม่พอที่จะแลกของเล่นชิ้นนี้", preferredStyle: .alert)
                
                let okAction: UIAlertAction = UIAlertAction(title: "ตกลง", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            }else if let cc = c, p <= cc{
                //bool = true
                print("can")
                print(p)
                print(cc)
                //return true -> canBuy
                
                print("canBuy")
                self.ref.child("items").child(self.itemId).updateChildValues(["status":"pending"])
                self.coinsManager()
                //create order db
                //myOrder(itemIbuy) -> myid-item1,item2,..
                self.ref.child("myOrder").child(user!.uid).child(self.itemId).setValue(["seller": self.owner,"itemId":self.itemId,"status":"confirm","price":price,"trackingNo":""])
                
                //sellOrder(itemIsell) -> sellerid-item1,item2,..
                self.ref.child("sellOrder").child(self.owner).child(self.itemId).setValue(["buyer": user!.uid,"itemId":self.itemId,"status":"confirm","price":price,"trackingNo":""])
                
                
                
                let alert: UIAlertController = UIAlertController(title: "สำเร็จ!", message: "แลกของเล่นชิ้นนี้สำเร็จแล้ว", preferredStyle: .alert)
                
                let okAction: UIAlertAction = UIAlertAction(title: "ตกลง", style: .default, handler: { action in self.goHome()})
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                
                //create ui history
                //noti to seller
                
            }else{
                let cc = c
                print("error")
                print(p)
                print(cc)
            }
        
            
        })
   
        
        
        
        
       
    }
    
    func coinsManager(){
        let p = Int(price) ?? 0
        var c = 0
        var cOut = 0
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let coins = value?["coins"]as? String ?? ""
            let coinsOut = value?["coinsOut"]as? String ?? ""
            c = Int(coins) ?? 0
            self.coinsAfterOrder = c-p
            cOut = Int(coinsOut) ?? 0
            cOut += p
            self.ref.child("users").child(userID!).updateChildValues(["coins":String(self.coinsAfterOrder),"coinsOut":String(cOut)])
            
        })
        ref.child("users").child(owner).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let coinsIn = value?["coinsIn"]as? String ?? ""
            let p = Int(self.price) ?? 0
            var cIn = Int(coinsIn) ?? 0
            cIn += p
        self.ref.child("users").child(self.owner).updateChildValues(["coinsIn":String(cIn)])
        })
        
    }
    
    func goHome(){
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "tabbar"))!
        self.present(vc, animated: true, completion: nil)
    }
    
    func buy(){
        print("new")
        let user = Auth.auth().currentUser
        ref = Database.database().reference()
        //check currcoins
        //let canBuy = self.checkCoins(price: price)
        self.checkCoins(price: price)
    }
    
    
    @IBAction func buyTapped(_ sender: UIButton) {
        
        
        let alert: UIAlertController = UIAlertController(title: "ยืนยันการแลกของเล่น", message: "ยืนยันที่จะแลกของเล่นชิ้นนี้หรือไม่", preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "ยืนยัน",  style: .default, handler: { action in self.buy()
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "ยกเลิก",  style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
       
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if owner == User?.uid{
            buybtn.isEnabled = true
            buybtn.isHidden = true
        }
        if status == "pending"{
            buybtn.isEnabled = false
            buybtn.setTitle("pending", for: .disabled)
            //buybtn.isHidden = true
        }else if status == "sold out"{
            buybtn.isEnabled = false
            buybtn.setTitle("sold out", for: .disabled)
            //buybtn.isHidden = true
        }
        
        
        
        name.text = finalname
        dcs.text = Description
        priceLabel.text = price
        typebtn.setTitle(type, for: .normal)
        print(self.url)
        guard let u = URL(string: url) else {
            return
        }
        
        
        let resource = ImageResource(downloadURL: u)
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { (image, error, cache, imageURL) in
            self.img1.image = image
            self.img1.kf.indicatorType = .activity
        }
        
        
        
        

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
}
