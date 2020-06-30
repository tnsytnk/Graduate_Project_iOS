//
//  editItemViewController.swift
//  toys
//
//  Created by Thanakorn Kaewsawang on 12/6/2562 BE.
//  Copyright © 2562 Thanakorn K. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class editItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate {
    let activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    var myPickerData = [String](arrayLiteral: "แรกเกิด - 2 ปี", "3 - 5 ปี", "6 - 8 ปี", "9 ปี ขึ้นไป")
    
    var status = ""
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myPickerData.count
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myPickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        age.text = myPickerData[row]
    }
    
    
    var itemId = ""
    var count = 0
    var url = ""
    var ref: DatabaseReference!
    let user = Auth.auth().currentUser
   
    @IBOutlet weak var addImageBtn: UIButton!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var ImageView2: UIImageView!
    
    @IBOutlet weak var ImageView3: UIImageView!
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var price: UITextField!
    
    @IBOutlet weak var picCount: UILabel!
    @IBOutlet weak var dev: UITextField!
    @IBOutlet weak var age: UITextField!
    
    @IBOutlet weak var ship: UITextField!
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
    
    
    func getAllData(){
        
        ref = Database.database().reference()
        
        ref.child("items").child(itemId).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            //let username = value?["username"] as? String ?? ""
            let name = value?["itemName"]as? String ?? ""
            let price = value?["price"]as? String ?? ""
            let url = value?["itemURL1"]as? String ?? ""
            let development = value?["development"]as? String ?? ""
            let status = value?["status"]as? String ?? ""
            let desc = value?["itemDescription"]as? String ?? ""
            let age = value?["ageRange"]as? String ?? ""
            let shipping = value?["deliveryPrice"]as? String ?? ""
            self.name.text = name
            self.price.text = price
            self.setImg(x: url)
            self.desc.text = desc
            self.age.text = age
            self.dev.text = development
            self.ship.text = shipping
            self.status = status
            self.url = url
            
            
            
        })
    }
    
    @IBAction func importImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true) {
            //after add img complete
            self.count+=1
            self.picCount.text = String(self.count)+"/3"
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            if count==1{
                img.image = image}
            else if count==2{
                ImageView2.image = image}
            else if count==3{
                ImageView3.image = image
                addImageBtn.isEnabled = false
                addImageBtn.isUserInteractionEnabled = false
            }
            
        }
        else{
            // error message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func deleteImg(_ sender: Any) {
        
        if img.image == nil {
            let alert: UIAlertController = UIAlertController(title: "ไม่มีรูปภาพ", message: "กรุณาใส่รูปภาพของเล่น", preferredStyle: .alert)
            
            let okAction: UIAlertAction = UIAlertAction(title: "ตกลง", style: .default, handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        //img.image = nil
        }else{
            img.image = nil
        }
    }
    
    func chooseDevelopment(x:String){
        dev.text = x
    }
    
    func developmentChecker(x:UIAlertController){
        if age.text == myPickerData[0]{
            let action1: UIAlertAction = UIAlertAction(title: "เสริมกล้ามเนื้อ ประสานสัมพันธ์", style: .default, handler: { action in self.chooseDevelopment(x:"เสริมกล้ามเนื้อ ประสานสัมพันธ์")
            })
            let action2: UIAlertAction = UIAlertAction(title: "สติปัญญา ความคิดสร้างสรรค์", style: .default, handler: { action in self.chooseDevelopment(x:"สติปัญญา ความคิดสร้างสรรค์")
            })
            let action3: UIAlertAction = UIAlertAction(title: "คำนวนเรขาคณิต - คณิตศาสตร์", style: .default, handler: { action in self.chooseDevelopment(x:"คำนวนเรขาคณิต - คณิตศาสตร์")
            })
            x.addAction(action1)
            x.addAction(action2)
            x.addAction(action3)
            
        }else if age.text == myPickerData[1]{
            let action1: UIAlertAction = UIAlertAction(title: "เสริมกล้ามเนื้อ ประสานสัมพันธ์", style: .default, handler: { action in self.chooseDevelopment(x:"เสริมกล้ามเนื้อ ประสานสัมพันธ์")
            })
            let action2: UIAlertAction = UIAlertAction(title: "สติปัญญา ความคิดสร้างสรรค์", style: .default, handler: { action in self.chooseDevelopment(x:"สติปัญญา ความคิดสร้างสรรค์")
            })
            let action3: UIAlertAction = UIAlertAction(title: "คำนวนเรขาคณิต - คณิตศาสตร์", style: .default, handler: { action in self.chooseDevelopment(x:"คำนวนเรขาคณิต - คณิตศาสตร์")
            })
            let action4: UIAlertAction = UIAlertAction(title: "เสริมประสบการณ์ชีวิต และวิทยาศาสตร์", style: .default, handler: { action in self.chooseDevelopment(x:"เสริมประสบการณ์ชีวิต และวิทยาศาสตร์")
            })
            x.addAction(action1)
            x.addAction(action2)
            x.addAction(action3)
            x.addAction(action4)
            
        }else if age.text == myPickerData[2] {
            let action1: UIAlertAction = UIAlertAction(title: "เครื่องเล่นสนามและครุภัณฑ์", style: .default, handler: { action in self.chooseDevelopment(x:"เครื่องเล่นสนามและครุภัณฑ์")
            })
            let action2: UIAlertAction = UIAlertAction(title: "สติปัญญา ความคิดสร้างสรรค์", style: .default, handler: { action in self.chooseDevelopment(x:"สติปัญญา ความคิดสร้างสรรค์")
            })
            let action3: UIAlertAction = UIAlertAction(title: "คำนวนเรขาคณิต - คณิตศาสตร์", style: .default, handler: { action in self.chooseDevelopment(x:"คำนวนเรขาคณิต - คณิตศาสตร์")
            })
            let action4: UIAlertAction = UIAlertAction(title: "เสริมประสบการณ์ชีวิต และวิทยาศาสตร์", style: .default, handler: { action in self.chooseDevelopment(x:"เสริมประสบการณ์ชีวิต และวิทยาศาสตร์")
            })
            x.addAction(action1)
            x.addAction(action2)
            x.addAction(action3)
            x.addAction(action4)
            
        }else if age.text == myPickerData[3]{
            let action1: UIAlertAction = UIAlertAction(title: "เครื่องเล่นสนามและครุภัณฑ์", style: .default, handler: { action in self.chooseDevelopment(x:"เครื่องเล่นสนามและครุภัณฑ์")
            })
            let action2: UIAlertAction = UIAlertAction(title: "สติปัญญา ความคิดสร้างสรรค์", style: .default, handler: { action in self.chooseDevelopment(x:"สติปัญญา ความคิดสร้างสรรค์")
            })
            let action3: UIAlertAction = UIAlertAction(title: "คำนวนเรขาคณิต - คณิตศาสตร์", style: .default, handler: { action in self.chooseDevelopment(x:"คำนวนเรขาคณิต - คณิตศาสตร์")
            })
            let action4: UIAlertAction = UIAlertAction(title: "เสริมประสบการณ์ชีวิต และวิทยาศาสตร์", style: .default, handler: { action in self.chooseDevelopment(x:"เสริมประสบการณ์ชีวิต และวิทยาศาสตร์")
            })
            x.addAction(action1)
            x.addAction(action2)
            x.addAction(action3)
            x.addAction(action4)
        }else{
            print("input age error")
        }
        
    }
    
    func start(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        self.view.addSubview(activityIndicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    func stop(){
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
    @IBAction func addDevelopmentBtn(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "เลือกพัฒนาการ", message: "เลือกการเสริมสร้างพัฒนาการดังต่อไปนี้", preferredStyle: .alert)
        developmentChecker(x: alert)
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteimg(){
        let storage = Storage.storage()
        
        
        storage.reference(forURL: url).delete { error in
            if error == nil{
                print("up")
                
                
            }else{
                print("no")
                
            }
        }
        
    }
    
    func uploadImagesToStorage(_ image:UIImage, completion: @escaping (_ url: URL?)->() ){
        //guard let image = ImageView.image else {return}
        let imageData = image.pngData()
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        //user = Auth.auth().currentUser
        let storage = Storage.storage()
        let storageRef = storage.reference()
        //let uidRef = storageRef.child(user!.uid)
        let fileRef = storageRef.child(user!.uid+"/"+NSUUID().uuidString+".png")
        fileRef.putData(imageData!, metadata: metaData){ (metadata ,error) in
            if error == nil{
                print("up")
                fileRef.downloadURL(completion:{(url,error)in completion(url)})
                
            }else{
                print("no")
                completion(nil)
            }
            
        }
        
        
    }
    
    func saveInfo(name :String,itemURL:URL, completion: @escaping ((_ url: URL?)->()) ){
        
        ref = Database.database().reference()
        
       ref.child("items").child(itemId).updateChildValues(["itemName":self.name.text!,"itemDescription":desc.text!,"itemURL1":itemURL.absoluteString,"owner":user!.uid,"price":price.text!,"deliveryPrice":ship.text!,"ageRange":age.text!,"development":dev.text!,"status":status,"type":age.text!+"_"+dev.text!,"itemId":itemId])
        
        self.stop()
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "tabbar"))!
        self.present(vc, animated: true, completion: nil)
    }
    
    func click(){
        self.uploadImagesToStorage(self.img.image!) { url in
            self.saveInfo(name: self.name.text!, itemURL: url!){ success in////////
                
            }
        }
    }
    
    @IBAction func edit(_ sender: Any) {
        
        
        let alert: UIAlertController = UIAlertController(title: "ใส่ข้อมูลไม่ครบ", message: "alertMessage", preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "ตกลง", style: .default, handler: nil)
        alert.addAction(okAction)
        
        
        if img.image == nil{
            alert.message = "ใส่รูปภาพอย่างน้อยหนึ่งรูป"
            self.present(alert, animated: true, completion: nil)
        }else{
            if name.text == ""{
                alert.message = "กรุณาใส่ชื่อของเล่น"
                self.present(alert, animated: true, completion: nil)
            }else{
                if desc.text == ""{
                    alert.message = "กรุณาบรรยายรายละเอียดของเล่น"
                    self.present(alert, animated: true, completion: nil)
                }else{
                    
                    if age.text == ""{
                        alert.message = "กรุณาใส่ช่วงอายุที่เหมาะสม"
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        if dev.text == ""{
                            alert.message = "กรุณาเลือกพัฒนาการ"
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            if price.text == ""{
                                alert.message = "กรุณาใส่ราคาของเล่น"
                                self.present(alert, animated: true, completion: nil)
                            }else{
                                if ship.text == ""{
                                    alert.message = "กรุณาใส่ค่าจัดส่ง"
                                    self.present(alert, animated: true, completion: nil)
                                }else{
                                    // code here if all textField != null
                                    self.start()
                                    self.click()
                                    
                                }
                                
                            }
                            
                        }
                    }
                    
                    
                }
            }
        }
    }
    
    
    
   
    
    func delete(){
        ref = Database.database().reference()
        ref.child("items").child(itemId).removeValue()
        deleteimg()
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "tabbar"))!
        
        let alert: UIAlertController = UIAlertController(title: "ลบสำเร็จ!", message: "ของเล่นชิ้นนี้ถูกลบแล้ว", preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "ตกลง",  style: .default, handler: { action in self.present(vc, animated: true, completion: nil)})
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        //self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func deleteItem(_ sender: Any) {
        
        
        let alert: UIAlertController = UIAlertController(title: "ยืนยันการลบของเล่น", message: "ของเล่นชิ้นนี้จะถูกลบอย่างถาวร", preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "ยืนยัน",  style: .default, handler: { action in self.delete()
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "ยกเลิก",  style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
        
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllData()
        
        name.delegate = self
        desc.delegate = self
        age.delegate = self
        dev.delegate = self
        price.delegate = self
        ship.delegate = self
        
        //itemDescription.clearsOnInsertion = true
        let thePicker = UIPickerView()
        age.inputView = thePicker
        thePicker.delegate = self

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
