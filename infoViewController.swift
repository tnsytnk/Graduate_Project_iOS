//
//  infoViewController.swift
//  toys
//
//  Created by Thanakorn Kaewsawang on 29/5/2562 BE.
//  Copyright © 2562 Thanakorn K. All rights reserved.
//

import UIKit

class infoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    let image: [UIImage] = [UIImage(named: "g1")!,UIImage(named: "advice_ประสบการณ์")!,UIImage(named: "advice_สติปัญญา")!,UIImage(named: "advice_เรขาคณิต")!,UIImage(named: "advice_เครื่องเล่นสนาม")!]
    @IBAction func t1(_ sender: Any) {
        imageView.image = image[0]
    }
    
    @IBAction func t2(_ sender: Any) {
        imageView.image = image[1]
    }
    
    @IBAction func t3(_ sender: Any) {
        imageView.image = image[2]
    }
    @IBAction func t4(_ sender: Any) {
        imageView.image = image[3]
    }
    @IBAction func t5(_ sender: Any) {
        imageView.image = image[4]
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
