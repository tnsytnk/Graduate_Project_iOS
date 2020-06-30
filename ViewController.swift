//
//  ViewController.swift
//  toys
//
//  Created by Thanakorn Kaewsawang on 12/3/2562 BE.
//  Copyright © 2562 Thanakorn K. All rights reserved.
//

import UIKit
import FirebaseUI // firebaseAuthUI
import Firebase

class ViewController: UIViewController{
    //var db: OpaquePointer?
    var ref: DatabaseReference!
    var sql = String()
    var userData = NSDictionary()
    
    @IBOutlet weak var logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("load")
        logo.image = UIImage(named: "logo")!
        
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    @IBAction func logginTapped(_ sender: UIButton) {
        print("Enter Tapped")
        
        let authUI = FUIAuth.defaultAuthUI()
        guard authUI != nil else {
            //Log the error
            return
        }
        
        authUI?.delegate = self
        authUI?.providers = [FUIEmailAuth(),FUIGoogleAuth()]
        
        let authViewController = authUI!.authViewController()
        
        present(authViewController, animated: true, completion: nil)
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    


    }
    extension ViewController: FUIAuthDelegate{
        
        func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        //check if there was in error
    
        if error != nil {
            //Log error
            
            return
        }else{
            var NewUser = authDataResult?.additionalUserInfo?.isNewUser;
            if (NewUser==true) {
                print("new")
                let user = authDataResult?.user
                ref = Database.database().reference()
                self.ref.child("users").child(user!.uid).setValue(["username": user?.displayName,"email": user?.email])
                self.dismiss(animated: true, completion: nil)
                performSegue(withIdentifier: "goHome", sender: self)
                
                
            }else{
                
                print("old")
                let vc = (self.storyboard?.instantiateViewController(withIdentifier: "tabbar"))!
                self.present(vc, animated: true, completion: nil)
                //performSegue(withIdentifier: "goHome", sender: self)
            }
        }
            //let user = authDataResult?.user
            //ref = Database.database().reference()
            //self.ref.child("users").child(user!.uid).setValue(["username": user?.displayName,"email": user?.email])
            //self.dismiss(animated: true, completion: nil)
          

        //performSegue(withIdentifier: "goHome", sender: self)
    
        }

    }



