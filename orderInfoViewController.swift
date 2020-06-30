//
//  orderInfoViewController.swift
//  toys
//
//  Created by Thanakorn Kaewsawang on 11/6/2562 BE.
//  Copyright © 2562 Thanakorn K. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class orderInfoViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var cancel: UIButton!
    var itemId = ""
    var url = ""
    var buyer = ""
    var ref: DatabaseReference!
    var uid = Auth.auth().currentUser?.uid
    var data:itemModel!
    var coinsAfterOrder : Int = 0
    @IBOutlet weak var pricelabel: UILabel!
    @IBOutlet weak var img: UIImageView!

    @IBOutlet weak var trackingNoTextField: UITextField!
    @IBOutlet weak var updatebtn: UIButton!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var recieveBtn: UILabel!
    @IBOutlet weak var bname: UILabel!
    
    @IBOutlet weak var bphone: UILabel!
    
    @IBOutlet weak var baddress: UITextView!
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getAllFIRData(){
        ref = Database.database().reference()
        
        ref.child("items").child(itemId).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            //let username = value?["username"] as? String ?? ""
            let name = value?["itemName"]as? String ?? ""
            let price = value?["price"]as? String ?? ""
            let url = value?["itemURL1"]as? String ?? ""
            self.name.text = name
            self.pricelabel.text = price
            self.setImg(x: url)
        })
        ref.child("sellOrder").child(uid!).child(itemId).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let buyer = value?["buyer"]as? String ?? ""
            let status = value?["status"]as? String ?? ""
            let trackingNo = value?["trackingNo"]as? String ?? ""
            if status == "shipped" {
                self.updatebtn.isHidden = true
                self.recieveBtn.isHidden = true
                self.cancel.isHidden = true
                self.trackingNoTextField.text = trackingNo
                
            }else if status == "recieved"{
                self.cancel.isHidden = true
                self.updatebtn.isHidden = true
                self.recieveBtn.isHidden = false
                self.trackingNoTextField.text = trackingNo
                
            }
            
            self.buyer = buyer
            print(self.buyer)
            
            Database.database().reference().child("users").child(buyer).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let buyername = value?["username"]as? String ?? ""
                self.bname.text = buyername
                let buyerphone = value?["phone"]as? String ?? ""
                self.bphone.text = "เบอร์โทรศัพท์: "+buyerphone
                let buyeraddress = value?["address"]as? String ?? ""
                self.baddress.text = buyeraddress
                print(buyername)
            })
            
            
            
        })
        
        
    }
    
    func setImg(x:String){
        print(x)
        
        guard let u = URL(string: x) else {
            return
        }
        
        let resource = ImageResource(downloadURL: u)
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { (image, error, cache, imageURL) in
            self.img.image = image
            self.img.kf.indicatorType = .activity
        }
    }
    func goHome(){
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "tabbar"))!
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func updateTrakingNo(_ sender: Any) {
        if trackingNoTextField.text == "" {
            let alert: UIAlertController = UIAlertController(title: "กรุณาใส่เลขพัสดุ", message: "กรุณาใส่เลขพัสดุให้ถูกต้อง", preferredStyle: .alert)
            
            let okAction: UIAlertAction = UIAlertAction(title: "ตกลง", style: .default, handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }else{
        Database.database().reference().child("sellOrder").child(uid!).child(itemId).updateChildValues(["trackingNo":trackingNoTextField.text,"status":"shipped"])
        Database.database().reference().child("myOrder").child(buyer).child(itemId).updateChildValues(["trackingNo":trackingNoTextField.text,"status":"shipped"])
            
            
            let alert: UIAlertController = UIAlertController(title: "สำเร็จ!", message: "อัพเดตเลขพัสดุแล้ว", preferredStyle: .alert)
            
            let okAction: UIAlertAction = UIAlertAction(title: "ตกลง", style: .default, handler: { action in self.goHome()})
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
    }
    func coinsManager(){
        
        
        let p = Int(pricelabel.text!) ?? 0
        var c = 0
        var cOut = 0
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(buyer).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let coins = value?["coins"]as? String ?? ""
            let coinsOut = value?["coinsOut"]as? String ?? ""
            c = Int(coins) ?? 0
            self.coinsAfterOrder = c-p
            cOut = Int(coinsOut) ?? 0
            cOut -= p
            self.coinsAfterOrder = c+p
            self.ref.child("users").child(self.buyer).updateChildValues(["coins":String(self.coinsAfterOrder),"coinsOut":String(cOut)])
            
        })
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let coinsIn = value?["coinsIn"]as? String ?? ""
            let p = Int(self.pricelabel.text!) ?? 0
            var cIn = Int(coinsIn) ?? 0
            cIn -= p
            self.ref.child("users").child(self.uid!).updateChildValues(["coinsIn":String(cIn)])
            
            
            let alert: UIAlertController = UIAlertController(title: "สำเร็จ!", message: "ยกเลิกคำสั่งซื้อแล้ว ของเล่นจะถูกเก็บอยู่ในบ้านของฉัน", preferredStyle: .alert)
            
            let okAction: UIAlertAction = UIAlertAction(title: "ตกลง", style: .default, handler: { action in self.goHome()})
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        })
        
        
        
    }
   
    func cancelorder(){
        Database.database().reference().child("sellOrder").child(uid!).child(itemId).removeValue()
        Database.database().reference().child("myOrder").child(buyer).child(itemId).removeValue()
        Database.database().reference().child("items").child(itemId).updateChildValues(["status":"available"])
        //coinmanager
        coinsManager()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        
        
        
        let alert: UIAlertController = UIAlertController(title: "ยกเลิกการสั่งซื้อหรือไม่", message: "กดยืนยันเพื่อยกเลิกการสั่งซื้อนี้", preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "ยกเลิกการสั่งซื้อ",  style: .default, handler: { action in self.cancelorder()
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "กลับ",  style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
   
   
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recieveBtn.isHidden = true
        trackingNoTextField.delegate = self
        getAllFIRData()
        /*
        print(self.url)
    
        guard let u = URL(string: url) else {
            return
        }
        
        let resource = ImageResource(downloadURL: u)
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { (image, error, cache, imageURL) in
            self.img.image = image
            self.img.kf.indicatorType = .activity
        }*/
        
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
