//
//  MeViewController.swift
//  toys
//
//  Created by Thanakorn Kaewsawang on 9/5/2562 BE.
//  Copyright © 2562 Thanakorn K. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseUI


class MeViewController: UIViewController {
    var email = String()
    var ref: DatabaseReference!
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func myHomeTapped(_ sender: UIButton) {
   
        performSegue(withIdentifier: "myHome", sender: self)
    }
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var coinbtn: UIButton!
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var coinIn: UIButton!
    
    @IBOutlet weak var coinOut: UIButton!
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        

        try! Auth.auth().signOut()
        //self.dismiss(animated: true, completion: nil)
    
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "VC"))!
        //view.re
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func reTapped(_ sender: Any) {
        refresh()
    }
    
    func refresh(){
        super.viewDidLoad()
        self.start()
        ref = Database.database().reference()
        
        //self.ref.child("users").child(user!.uid).setValue(["username": user?.displayName,"email": user?.email])
        
        
        let userID = Auth.auth().currentUser?.uid
        //let Curruser = Auth.auth().currentUser
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let ratingdb = value?["rating"] as? String ?? ""
            let coins = value?["coins"] as? String ?? ""
            let coinsIn = value?["coinsIn"] as? String ?? ""
            let coinsOut = value?["coinsOut"] as? String ?? ""
            let count = value?["ratingCount"] as? String ?? ""
            let c:Int = Int(Double(count)!)
            // ...
            
            
            self.name.text = username
            self.rating.text = ratingdb+" จากผู้ใช้ "+String(c)+" คน"
            self.coinbtn.setTitle("เหรียญที่ใช้ได้ : "+coins, for: .normal)
            self.coinIn.setTitle("เหรียญรอเข้า : "+coinsIn, for: .normal)
            self.coinOut.setTitle("เหรียญรอจ่าย : "+coinsOut, for: .normal)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        self.stop()
        
    }

    
    func start(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        //view.addSubview(activityIndicator)
        //activityIndicator.isHidden = false
        //self.view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        self.view.addSubview(activityIndicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    func stop(){
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.start()
        ref = Database.database().reference()
        
        //self.ref.child("users").child(user!.uid).setValue(["username": user?.displayName,"email": user?.email])
        
        
        let userID = Auth.auth().currentUser?.uid
        //let Curruser = Auth.auth().currentUser
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let ratingdb = value?["rating"] as? String ?? ""
            let coins = value?["coins"] as? String ?? ""
            let coinsIn = value?["coinsIn"] as? String ?? ""
            let coinsOut = value?["coinsOut"] as? String ?? ""
            let count = value?["ratingCount"] as? String ?? ""
            let c:Int = Int(Double(count)!)
            // ...
            
            
            self.name.text = username
            self.rating.text = ratingdb+" จากผู้ใช้ "+String(c)+" คน"
            self.coinbtn.setTitle("เหรียญที่ใช้ได้ : "+coins, for: .normal)
            self.coinIn.setTitle("เหรียญรอเข้า : "+coinsIn, for: .normal)
            self.coinOut.setTitle("เหรียญรอจ่าย : "+coinsOut, for: .normal)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        self.stop()
        

    

        
        // Do any additional setup after loading the view.
        
        
        //let alert = UIAlertController(title: "Hello "+email, message: "hellooo", preferredStyle: .alert)
       // let buttonOK = UIAlertAction(title: "OK", style: .default, handler: nil)
       // alert.addAction(buttonOK)
      //  let opQue = OperationQueue();
      //  opQue.addOperation ({
      //      self.present(alert, animated: true)
     //   })
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
