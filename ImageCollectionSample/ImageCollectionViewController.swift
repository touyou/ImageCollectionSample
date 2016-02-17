//
//  ImageCollectionViewController.swift
//  ImageCollectionSample
//
//  Created by 藤井陽介 on 2016/02/17.
//  Copyright © 2016年 touyou. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ImageCollectionViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var imageCollectionView: UICollectionView!
    var selectedAPI: String = ""
    var searchWord: String = ""
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        // self.viewDidLoad()
        imageCollectionView.delegate = self
        
        switch(selectedAPI) {
            case "Tiqav":
            tiqav()
            break
            case "Twitter":
            twitter()
            break
            case "Pixaboy":
            pixaboy()
            break
            case "Google":
            google()
            break
        default:
            break
            
        }
        
    }
    
    func tiqav() {
        // 日本語対応
        let text = "http://api.tiqav.com/search.json?q="+searchWord
        getImage(encodeURL(text), key: "source_url")
    }
    func twitter() {
    }
    func pixaboy() {
        let text = "https://pixaboy.com/api/?key="+APIKeyList.APIKey.pixaboy()+"&q="+searchWord+"&image_type=photo"
        print(text)
        getImage(encodeURL(text), key: "previewURL")
    }
    func google() {
    }
    func encodeURL(text: String) -> NSURL! {
        return NSURL(string: text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
    }
    // 画像をJSONから取得して処理するところ、urlと画像のurlが入るキーを指定できる
    func getImage(url: NSURL, key: String) {
        Alamofire.request(.GET, url).responseJSON(completionHandler: {
            response in
            print("clear")
            print(response)
            guard let object = response.result.value else {
                return
            }
            let json = JSON(object)
            json.forEach({(_, json) in
                let url = NSURL(string: json[key].string!)
                print(json[key].string)
                let req = NSURLRequest(URL: url!)
                NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue(), completionHandler: {(res, data, err) in
                    let image = UIImage(data: data!)
                    self.images.append(self.cropThumbnailImage(image!, w: 100, h: 100))
                })
            })
        })
        print(images.count)
    }
    
    @IBAction func closeView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // セクション数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    // 数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    // 入れるもの
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CustomCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        cell.imageView.image = self.images[Int(indexPath.row)]
        return cell
    }
    
    func cropThumbnailImage(image :UIImage, w:Int, h:Int) ->UIImage {
        // リサイズ処理
        
        let origRef    = image.CGImage;
        let origWidth  = Int(CGImageGetWidth(origRef))
        let origHeight = Int(CGImageGetHeight(origRef))
        var resizeWidth:Int = 0, resizeHeight:Int = 0
        
        if (origWidth < origHeight) {
            resizeWidth = w
            resizeHeight = origHeight * resizeWidth / origWidth
        } else {
            resizeHeight = h
            resizeWidth = origWidth * resizeHeight / origHeight
        }
        
        let resizeSize = CGSizeMake(CGFloat(resizeWidth), CGFloat(resizeHeight))
        UIGraphicsBeginImageContext(resizeSize)
        
        image.drawInRect(CGRectMake(0, 0, CGFloat(resizeWidth), CGFloat(resizeHeight)))
        
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 切り抜き処理
        
        let cropRect  = CGRectMake(
            CGFloat((resizeWidth - w) / 2),
            CGFloat((resizeHeight - h) / 2),
            CGFloat(w), CGFloat(h))
        let cropRef   = CGImageCreateWithImageInRect(resizeImage.CGImage, cropRect)
        let cropImage = UIImage(CGImage: cropRef!)
        
        return cropImage
    }
}
