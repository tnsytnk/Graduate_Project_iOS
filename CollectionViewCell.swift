//
//  CollectionViewCell.swift
//  toys
//
//  Created by Thanakorn Kaewsawang on 11/5/2562 BE.
//  Copyright © 2562 Thanakorn K. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var toyImageView: UIImageView!
    
    //@IBOutlet weak var toyLabel: UILabel!
    @IBOutlet weak var toyLabel: UILabel!
    
    var itemModel : itemModel?{
        didSet{
            toyLabel.text = itemModel?.name
            //toyImageView.image.
            //toyImageView.image =
            let url = URL(string: (itemModel?.itemImageURL)!)
            if let url = url as? URL{
                KingfisherManager.shared.retrieveImage(with: url as Resource, options: nil, progressBlock: nil) { (image, error, cache, imageURL) in
                    self.toyImageView.image = image
                    self.toyImageView.kf.indicatorType = .activity
                }
            }
            
        }
    
    }
}
