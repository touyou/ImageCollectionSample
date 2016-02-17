//
//  ViewController.swift
//  ImageCollectionSample
//
//  Created by 藤井陽介 on 2016/02/17.
//  Copyright © 2016年 touyou. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var choiceAPIPickerVIew: UIPickerView!
    @IBOutlet var searchWordField: UITextField!
    var selectedAPI: String = "Tiqav"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        choiceAPIPickerVIew.delegate = self
        choiceAPIPickerVIew.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // PickerViewのセクションの数
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    // PickerViewの選択肢の数
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    // PickerViewの選択肢の文字列
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return switchAPIString(row)
    }
    // 選ばれた選択肢に応じてどうするか
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedAPI = switchAPIString(row)
    }
    // どれが選ばれたか
    func switchAPIString(num: Int) -> String! {
        switch(num) {
        case 0:
            return "Tiqav"
        case 1:
            return "Twitter"
        case 2:
            return "Pixaboy"
        case 3:
            return "Google"
        default:
            return ""
        }
    }
    // searchButtonをおした時
    @IBAction func pushSearchButton() {
        print(selectedAPI)
        print(searchWordField.text)
        if selectedAPI == "" || searchWordField.text == nil {
            simpleAlert("検索ワードが記入されているか確認の上もう一度お試しください。")
        }
        performSegueWithIdentifier("toCollectView", sender: nil)
    }
    // 検索ワードとどのAPIを使うかを渡す
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toCollectView") {
            let collectView = segue.destinationViewController as! ImageCollectionViewController
            collectView.selectedAPI = self.selectedAPI
            collectView.searchWord = self.searchWordField.text!
        }
    }
    
    // 単純なアラートをつくる関数
    func simpleAlert(titleString: String) {
        let alertController = UIAlertController(title: titleString, message: nil, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}

