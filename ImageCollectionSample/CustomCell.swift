//
//  CustomCell.swift
//  ImageCollectionSample
//
//  Created by 藤井陽介 on 2016/02/17.
//  Copyright © 2016年 touyou. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
