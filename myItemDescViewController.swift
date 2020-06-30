//
//  myItemDescViewController.swift
//  toys
//
//  Created by Thanakorn Kaewsawang on 12/6/2562 BE.
//  Copyright © 2562 Thanakorn K. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class myItemDescViewController: UIViewController {
    
    var itemId = ""
    var ref: DatabaseReference!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var pricelabel: UILabel!
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var desc: UITextView!
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
            let type = value?["type"]as? String ?? ""
            let desc = value?["itemDescription"]as? String ?? ""
            let status = value?["status"]as? String ?? ""
            self.name.text = name
            self.pricelabel.text = price
            self.setImg(x: url)
            self.typeBtn.setTitle(type, for: .normal)
            self.desc.text = desc
            self.status.text = "สถานะ : "+status
            if status == "pending"{
                self.editBtn.isHidden = true
            }
            
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! editItemViewController
        vc.itemId = self.itemId
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllData()

        // Do any additional setup after loading the view.
    }
    

    

}
