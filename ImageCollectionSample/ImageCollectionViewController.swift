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
    var reqs: [NSURLRequest] = []
    
    override func viewDidLoad() {
        // self.viewDidLoad()
        
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
        
        imageCollectionView.delegate = self
    }
    
    func tiqav() {
        // 日本語対応
        let text = "http://api.tiqav.com/search.json?q="+searchWord
        // source_urlの画像は大体消されてた
        Alamofire.request(.GET, encodeURL(text), parameters: nil).responseJSON(completionHandler: {
            response in
            // print(response.result.value)
            guard let object = response.result.value else {
                return
            }
            let json = JSON(object)
            json.forEach({(_, json) in
                let url = NSURL(string: "http://img.tiqav.com/" + String(json["id"]) + "." + json["ext"].string!)
                let req = NSURLRequest(URL: url!)
                self.reqs.append(req)
            })
        })
        print(images.count)
    }
    func twitter() {
    }
    func pixaboy() {
        // 多分英語のみでおもしろ画像少ない△
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
        Alamofire.request(.GET, url, parameters: nil).responseJSON(completionHandler: {
            response in
            guard let object = response.result.value else {
                return
            }
            let json = JSON(object)
            json.forEach({(_, json) in
                let url = NSURL(string: json[key].string!)
                print(json[key].string)
                let req = NSURLRequest(URL: url!)
                self.reqs.append(req)
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
        print(reqs.count)
        return reqs.count
    }
    // 入れるもの
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CustomCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        NSURLConnection.sendAsynchronousRequest(reqs[Int(indexPath.row)], queue: NSOperationQueue.mainQueue(), completionHandler: {(res, data, err) in
            let image = UIImage(data: data!)
            cell.imageView.image = self.cropThumbnailImage(image!, w: 100, h: 100)
        })
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
