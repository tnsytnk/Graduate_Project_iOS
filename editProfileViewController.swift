//
//  editProfileViewController.swift
//  toys
//
//  Created by Thanakorn Kaewsawang on 12/6/2562 BE.
//  Copyright © 2562 Thanakorn K. All rights reserved.
//

import UIKit
import Firebase

class editProfileViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate {
    var ref : DatabaseReference!
    var uid = Auth.auth().currentUser?.uid
    
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextView!
    @IBOutlet weak var addressTF: UITextView!
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func getData(){
        ref = Database.database().reference()
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            //let username = value?["username"] as? String ?? ""
            let name = value?["username"]as? String ?? ""
            let phone = value?["phone"]as? String ?? ""
            let address = value?["address"]as? String ?? ""
            
            self.nameTF.text = name
            self.phoneTF.text = phone
            self.addressTF.text = address
            
        })
    }
    
    
    
    
    
    
    @IBAction func submit(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "กรอกข้อมูลไม่ครบ", message: "alertMessage", preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "ตกลง", style: .default, handler: nil)
        alert.addAction(okAction)
        
        
        if nameTF.text == ""{
            alert.message = "กรุณาใส่ ชื่อ-นามสกุล ของท่าน"
            self.present(alert, animated: true, completion: nil)
        }else{
            if phoneTF.text == ""{
                alert.message = "กรุณาใส่เบอร์โทรของท่าน"
                self.present(alert, animated: true, completion: nil)
            }else{
                if addressTF.text == ""{
                    alert.message = "กรุณาใส่ที่อยู่ของท่าน"
                    self.present(alert, animated: true, completion: nil)
                }else{
                    
                    // code here if all textField != null
                    
                    ref = Database.database().reference()
                    ref.child("users").child(uid!).updateChildValues(["username":nameTF.text,"phone":phoneTF.text,"address":addressTF.text])
                    
                    
                    let alertui: UIAlertController = UIAlertController(title: "สำเร็จ!", message: "อัพเดตข้อมูลของคุณแล้ว", preferredStyle: .alert)
                    
                    let vc = (self.storyboard?.instantiateViewController(withIdentifier: "tabbar"))!
                    
                    let okAction: UIAlertAction = UIAlertAction(title: "ตกลง",  style: .default, handler: { action in self.present(vc, animated: true, completion: nil)})
                    
                    alertui.addAction(okAction)
                    
                    self.present(alertui, animated: true, completion: nil)
                    
                }
            }
        }
        
        
        
        //self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.delegate = self
        phoneTF.delegate = self
        addressTF.delegate = self

      
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
