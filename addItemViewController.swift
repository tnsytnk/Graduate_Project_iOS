//
//  addItemViewController.swift
//  toys
//
//  Created by Thanakorn Kaewsawang on 27/5/2562 BE.
//  Copyright © 2562 Thanakorn K. All rights reserved.
//

import UIKit
import Firebase
import Foundation



class addItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate,UITextFieldDelegate{
    //var ref = DatabaseReference.init()
    var ref: DatabaseReference!
    let user = Auth.auth().currentUser
    
    //@IBOutlet weak var activityIndicator: UIView!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var development: UITextField!
    @IBOutlet weak var delivery: UITextField!
    @IBOutlet weak var price: UITextField!
    let activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    var status = "available"
    var myPickerData = [String](arrayLiteral: "แรกเกิด - 2 ปี", "3 - 5 ปี", "6 - 8 ปี", "9 ปี ขึ้นไป")

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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
   

   
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var ImageView2: UIImageView!
    @IBOutlet weak var ImageView3: UIImageView!
    @IBOutlet weak var picCount: UILabel!
    var count = 0
    @IBOutlet weak var addImgButton: UIButton!
    
    //@IBOutlet weak var itemName: UITextField!
    
   
    //@IBOutlet var itemDescription: UITextView!
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
                ImageView.image = image}
            else if count==2{
                ImageView2.image = image}
            else if count==3{
                ImageView3.image = image
                addImgButton.isEnabled = false
                addImgButton.isUserInteractionEnabled = false
            }
            
        }
        else{
            // error message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*@IBAction func addItemTapped(_ sender: Any) {
        let alertImg: UIAlertController = UIAlertController(title: "กรุณาเพิ่มรูปภาพ", message: "เพิ่มรูปภาพของเล่นอย่างน้อย 1 รูป", preferredStyle: .alert)
        
        let alertName: UIAlertController = UIAlertController(title: "กรุณาใส่ชื่อของเล่น", message: "ใส่ชื่อของเล่น", preferredStyle: .alert)
        
        //let alertDescription: UIAlertController = UIAlertController(title: "กรุณาใส่รายละเอียด", message: "ใส่รายละเอียดของของเล่น", preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "ตกลง", style: .default, handler: nil)
        
        if ImageView.image == nil{  // check if add an img
            alertImg.addAction(okAction)
            
            self.present(alertImg, animated: true, completion: nil)
        }else{
            //check name!= nil
            if itemName.text == nil{
                alertName.addAction(okAction)
                
                self.present(alertName, animated: true, completion: nil)
            }
            
            
        }
    }*/
    
    
    func chooseDevelopment(x:String){
        development.text = x
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
        
        var post1Ref = ref.child("items").childByAutoId()
        //post1Ref.setValue(post1)
        
        //var postId = post1Ref.key
        //self.ref.child("items").childByAutoId()
        post1Ref.setValue(["itemName":itemName.text!,"itemDescription":itemDescription.text!,"itemURL1":itemURL.absoluteString,"owner":user!.uid,"price":price.text!,"deliveryPrice":delivery.text!,"ageRange":age.text!,"development":development.text!,"status":status,"type":age.text!+"_"+development.text!,"itemId":""])
        
        let postId = post1Ref.key
        print(":"+postId!)
        post1Ref.updateChildValues(["itemId":postId!])
        //self.dismiss(animated: true, completion: nil)
        //self.ref.child("users").child(user!.uid).setValue(["username": name,"email": user?.email,"phone": phoneNo,"address": address,"coins": 50,"rating":5])
        self.stop()
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "tabbar"))!
        self.present(vc, animated: true, completion: nil)
    }
    
    func click(){
        self.uploadImagesToStorage(self.ImageView.image!) { url in
            self.saveInfo(name: self.itemName.text!, itemURL: url!){ success in////////
                
            }
        }
    }
    
    @IBAction func addItemTapped(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "ใส่ข้อมูลไม่ครบ", message: "alertMessage", preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "ตกลง", style: .default, handler: nil)
        alert.addAction(okAction)
        
        
        if ImageView.image == nil{
            alert.message = "ใส่รูปภาพอย่างน้อยหนึ่งรูป"
            self.present(alert, animated: true, completion: nil)
        }else{
            if itemName.text == ""{
                alert.message = "กรุณาใส่ชื่อของเล่น"
                self.present(alert, animated: true, completion: nil)
            }else{
                if itemDescription.text == ""{
                    alert.message = "กรุณาบรรยายรายละเอียดของเล่น"
                    self.present(alert, animated: true, completion: nil)
                }else{
                    
                    if age.text == ""{
                        alert.message = "กรุณาใส่ช่วงอายุที่เหมาะสม"
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        if development.text == ""{
                            alert.message = "กรุณาเลือกพัฒนาการ"
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            if price.text == ""{
                                alert.message = "กรุณาใส่ราคาของเล่น"
                                self.present(alert, animated: true, completion: nil)
                            }else{
                                if delivery.text == ""{
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
        
        
        // self.start()
        //self.click()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        itemDescription.clearsOnInsertion = true
        let thePicker = UIPickerView()
        age.inputView = thePicker
        thePicker.delegate = self
        itemName.delegate = self
        itemDescription.delegate = self
        age.delegate = self
        development.delegate = self
        price.delegate = self
        delivery.delegate = self
        //developmentChecker()
        
        
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
