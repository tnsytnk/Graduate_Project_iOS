//
//  NewUserViewController.swift
//  toys
//
//  Created by Thanakorn Kaewsawang on 12/5/2562 BE.
//  Copyright © 2562 Thanakorn K. All rights reserved.
//

import UIKit
import Firebase

class NewUserViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate {

    var ref: DatabaseReference!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phone: UITextView!
    @IBOutlet weak var addressText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        phone.delegate = self
        addressText.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    
    func checkNil(){
        let alert: UIAlertController = UIAlertController(title: "กรอกข้อมูลไม่ครบ", message: "alertMessage", preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "ตกลง", style: .default, handler: nil)
         alert.addAction(okAction)
        
        
        if nameTextField.text == ""{
            alert.message = "กรุณาใส่ ชื่อ-นามสกุล ของท่าน"
            self.present(alert, animated: true, completion: nil)
        }else{
            if phone.text == ""{
                alert.message = "กรุณาใส่เบอร์โทรของท่าน"
                self.present(alert, animated: true, completion: nil)
            }else{
                if addressText.text == ""{
                    alert.message = "กรุณาใส่ที่อยู่ของท่าน"
                    self.present(alert, animated: true, completion: nil)
                }else{
                    
                    // code here if all textField != null
                    addInfotoDb()
                }
            }
        }
    }
    
    func addInfotoDb(){
        let name = nameTextField.text
        let phoneNo = phone.text
        let address = addressText.text
        
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        //let userID = Auth.auth().currentUser?.uid
        self.ref.child("users").child(user!.uid).setValue(["username": name,"email": user?.email,"phone": phoneNo,"address": address,"coins": "50","rating":"5","coinsIn":"0","coinsOut":"0","ratingCount":"0","allrating":"0"])
        //self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: UIButton) {
       checkNil()
        
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "tabbar"))!
        self.present(vc, animated: true, completion: nil)
        //performSegue(withIdentifier: "tabbar", sender: self)
        
    }
    
}
