//
//  ViewController.swift
//  lottery
//
//  Created by chennhuang on 16/3/5.
//  Copyright (c) 2016年 lottery. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    var collection: UICollectionView!
    var resultBtn: UIButton!
    var exitBtn:   UIButton!
    var result: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var flowLayout = UICollectionViewFlowLayout();
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.itemSize = CGSize(width: (self.view.bounds.width - 10 * 4)/3, height: (self.view.bounds.width - 10 * 4)/3)
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.view.backgroundColor = UIColor.whiteColor()
        var rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height - 100))
        collection = UICollectionView(frame: rect, collectionViewLayout: flowLayout)
        collection.dataSource = self
        collection.delegate = self
        collection.registerClass(LotteryView.classForCoder(), forCellWithReuseIdentifier: "defaultCell")
        collection.backgroundColor = UIColor.whiteColor()
        self.view .addSubview(collection)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //实现UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return result.count
    }
    
    //实现UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //返回Cell内容，这里我们使用刚刚建立的defaultCell作为显示内容
        var cell:LotteryView  = collection.dequeueReusableCellWithReuseIdentifier("defaultCell", forIndexPath: indexPath) as! LotteryView
        
        var index = indexPath.row;
        cell.setLabelText(result[Int(index)] as! String)
        cell.setSurfaceImages(cell.imageByColor(UIColor(white: 0, alpha: 0)))
        return cell;
    }
    
    //实现UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        //某个Cell被选择的事件处理
    }
    
    func onExitBtn(sender: UIButton){
       exit(0)
    }
    
    func onResultBtn(sender: UIButton){
        println("点击了Button");
    }
}
