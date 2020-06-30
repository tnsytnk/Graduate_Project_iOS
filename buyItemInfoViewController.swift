//
//  buyItemInfoViewController.swift
//  toys
//
//  Created by Thanakorn Kaewsawang on 11/6/2562 BE.
//  Copyright © 2562 Thanakorn K. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import Aftership_iOS_SDK



class buyItemInfoViewController: UIViewController,UITextFieldDelegate {
    
    
    var itemId = ""
    @IBOutlet weak var pricelabel: UILabel!
    var ref: DatabaseReference!
    var seller = ""
    var price = ""
    var uid = Auth.auth().currentUser?.uid
    var coinsAfterRecieved = 0
    var coinsAfterOrder : Int = 0

    @IBOutlet weak var trackingNoTextField: UITextField!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var recieveBtn: UIButton!
    @IBOutlet weak var myname: UILabel!
    @IBOutlet weak var myphone: UILabel!
    @IBOutlet weak var myaddress: UITextView!
    @IBOutlet weak var checkTrackBtn: UIButton!
    

    @IBAction func seller(_ sender: Any) {
        
        ref = Database.database().reference()
        
        Database.database().reference().child("users").child(seller).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let name = value?["username"]as? String ?? ""
            //self.sname.text = name
            let phone = value?["phone"]as? String ?? ""
            //self.sphone.text = "เบอร์โทรศัพท์: "+phone
            let rating = value?["rating"]as? String ?? ""
            //self.srating.text = rating
            let alert: UIAlertController = UIAlertController(title: "ผู้ขาย", message: name+" Tel."+phone+" Rating "+rating, preferredStyle: .alert)
            
            let okAction: UIAlertAction = UIAlertAction(title: "ตกลง", style: .default, handler: { action in self.goHome()})
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        })
        
        
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
            self.price = price
        })
        ref.child("myOrder").child(uid!).child(itemId).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            //seller///let buyer = value?["buyer"]as? String ?? ""
            let status = value?["status"]as? String ?? ""
            let seller = value?["seller"]as? String ?? ""
            let trackingNo = value?["trackingNo"]as? String ?? ""
            if status == "confirm" {
                self.checkTrackBtn.isHidden = true
                self.trackingNoTextField.isEnabled = false
                self.recieveBtn.isHidden = true
            }else if status == "shipped" {
                self.trackingNoTextField.text = trackingNo
                self.checkTrackBtn.isHidden = false
                self.recieveBtn.isHidden = false
                self.cancelBtn.isHidden = true
            }else if status == "recieved" {
                self.trackingNoTextField.text = trackingNo
                self.checkTrackBtn.isHidden = false
                self.recieveBtn.isHidden = false
                self.recieveBtn.isSelected = true
                self.recieveBtn.isEnabled = false
                self.cancelBtn.isHidden = true
            }
            self.seller = seller
            ///self.buyer = buyer
            ///print(self.buyer)
            
            Database.database().reference().child("users").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let name = value?["username"]as? String ?? ""
                self.myname.text = name
                let phone = value?["phone"]as? String ?? ""
                self.myphone.text = "เบอร์โทรศัพท์: "+phone
                let address = value?["address"]as? String ?? ""
                self.myaddress.text = address
                //print(buyername)
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
    @IBAction func checkTrackingTapped(_ sender: Any) {
        let paste = UIPasteboard.general
        paste.string = trackingNoTextField.text
        guard let url = URL(string: "https://th.kerryexpress.com/th/track/") else { return }
        UIApplication.shared.open(url)
        
    }
    
    func coinsManager(){
        let p = Int(price) ?? 0
        var c = 0
        var cOut = 0
        //ref = Database.database().reference()
        //let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value uid.cout-=price
            let value = snapshot.value as? NSDictionary
            //let coins = value?["coins"]as? String ?? ""
            let coinsOut = value?["coinsOut"]as? String ?? ""
            //c = Int(coins) ?? 0
            //self.coinsAfterRecieved = //c-p
            cOut = Int(coinsOut) ?? 0
            cOut -= p
            //self.coinsAfterRecieved = //c-p
            self.ref.child("users").child(self.uid!).updateChildValues(["coinsOut":String(cOut)])
            
           //seller recieve coin from cin
            self.ref.child("users").child(self.seller).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let coinsIn = value?["coinsIn"]as? String ?? ""
                let coins = value?["coins"]as? String ?? ""
                let p = Int(self.price) ?? 0
                var cIn = Int(coinsIn) ?? 0
                let c = Int(coins) ?? 0
                cIn -= p
                self.coinsAfterRecieved = 0
                self.coinsAfterRecieved = c + p
                self.ref.child("users").child(self.seller).updateChildValues(["coinsIn":String(cIn),"coins":String(self.coinsAfterRecieved)])
            })
            
        })
        
        
        
    }
    
    func confirmRecieve(){
        Database.database().reference().child("sellOrder").child(seller).child(itemId).updateChildValues(["status":"recieved"])
        Database.database().reference().child("myOrder").child(uid!).child(itemId).updateChildValues(["status":"recieved"])
        
        Database.database().reference().child("items").child(itemId).updateChildValues(["status":"sold out"])
        
        //manage coin
        coinsManager()
        
        //rating
        let alert: UIAlertController = UIAlertController(title: "กรุณาให้คะแนนผู้ขาย", message: "ให้คะแนนความพึงพอใจของผู้ขายรายนี้", preferredStyle: .alert)
        
        let okAction1: UIAlertAction = UIAlertAction(title: "น้อยที่สุด : 1", style: .default, handler: { action in self.rateMySeller(x: 1)
        })
        let okAction2: UIAlertAction = UIAlertAction(title: "น้อย : 2", style: .default, handler: { action in self.rateMySeller(x: 2)})
        let okAction3: UIAlertAction = UIAlertAction(title: "ปานกลาง : 3", style: .default, handler: { action in self.rateMySeller(x: 3)})
        let okAction4: UIAlertAction = UIAlertAction(title: "มาก : 4", style: .default, handler: { action in self.rateMySeller(x: 4)})
        let okAction5: UIAlertAction = UIAlertAction(title: "มากที่สุด : 5", style: .default, handler: { action in self.rateMySeller(x: 5)})
        alert.addAction(okAction1)
        alert.addAction(okAction2)
        alert.addAction(okAction3)
        alert.addAction(okAction4)
        alert.addAction(okAction5)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func goHome(){
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "tabbar"))!
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func rateMySeller(x:Double){
   
        
        
    ref.child("users").child(seller).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let allRating = value?["allrating"]as? String ?? ""
            let count = value?["ratingCount"]as? String ?? ""

        var all = Double(allRating) ?? 0
        var c = Double(count) ?? 0
        var rating:Double = 0
        
        all+=x    //allrate
        rating = all/(c+1) //rate
        c+=1 //count
         self.ref.child("users").child(self.seller).updateChildValues(["rating": String(rating),"allrating":String(all),"ratingCount":String(c)])
        self.goHome()
        })
        
    
    }
    
    
    @IBAction func recieveTapped(_ sender: Any) {
        self.recieveBtn.isSelected = true
        self.recieveBtn.isEnabled = false
        confirmRecieve()
        
        
        
        //goHome()
    }
    
    func Manager(){
        
        
        let p = Int(pricelabel.text!) ?? 0
        var c = 0
        var cOut = 0
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let coins = value?["coins"]as? String ?? ""
            let coinsOut = value?["coinsOut"]as? String ?? ""
            c = Int(coins) ?? 0
            self.coinsAfterOrder = c-p
            cOut = Int(coinsOut) ?? 0
            cOut -= p
            self.coinsAfterOrder = c+p
            self.ref.child("users").child(self.uid!).updateChildValues(["coins":String(self.coinsAfterOrder),"coinsOut":String(cOut)])
            
        })
        ref.child("users").child(seller).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let coinsIn = value?["coinsIn"]as? String ?? ""
            let p = Int(self.pricelabel.text!) ?? 0
            var cIn = Int(coinsIn) ?? 0
            cIn -= p
            self.ref.child("users").child(self.seller).updateChildValues(["coinsIn":String(cIn)])
            
            
            let alert: UIAlertController = UIAlertController(title: "สำเร็จ!", message: "ยกเลิกคำสั่งซื้อแล้ว ของเล่นจะถูกวางขายอีกครั้ง", preferredStyle: .alert)
            
            let okAction: UIAlertAction = UIAlertAction(title: "ตกลง", style: .default, handler: { action in self.goHome()})
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        })
        
        
        
    }
    
    
    func cancel(){
        Database.database().reference().child("sellOrder").child(seller).child(itemId).removeValue()
        Database.database().reference().child("myOrder").child(uid!).child(itemId).removeValue()
        Database.database().reference().child("items").child(itemId).updateChildValues(["status":"available"])
        //coinmanager
        Manager()
    }
    
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "ยกเลิกการสั่งซื้อหรือไม่", message: "กดยืนยันเพื่อยกเลิกการสั่งซื้อนี้", preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "ยกเลิกการสั่งซื้อ",  style: .default, handler: { action in self.cancel()
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "กลับ",  style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
   
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackingNoTextField.delegate = self
        getAllFIRData()

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
