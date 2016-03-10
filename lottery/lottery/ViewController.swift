//
//  YQ app
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    var collection: UICollectionView!
    var resultBtn: UIButton!
    var exitBtn:   UIButton!
    var result: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = UICollectionViewFlowLayout();
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.itemSize = CGSize(width: (self.view.bounds.width - 10 * 4)/3, height: (self.view.bounds.width - 10 * 4)/3)
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.view.backgroundColor = UIColor.whiteColor()
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height - 100))
        collection = UICollectionView(frame: rect, collectionViewLayout: flowLayout)
        collection.dataSource = self
        collection.delegate = self
        collection.registerClass(LotteryView.classForCoder(), forCellWithReuseIdentifier: "defaultCell")
        collection.backgroundColor = UIColor.whiteColor()
        self.view .addSubview(collection)
        
        resultBtn = UIButton(type: UIButtonType.System)
        resultBtn.showsTouchWhenHighlighted = true;
        resultBtn.frame = CGRectMake(80, self.view.frame.height - 80, 100, 20)
        resultBtn.setTitle("result", forState: UIControlState.Normal)
        resultBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        resultBtn.addTarget(self, action: Selector("onResultBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        exitBtn = UIButton(type: UIButtonType.System)
        exitBtn.showsTouchWhenHighlighted = true;
        exitBtn.frame = CGRectMake(self.view.frame.width - 80 - 100, self.view.frame.height - 80, 100, 20)
        exitBtn.setTitle("exit", forState: UIControlState.Normal)
        exitBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        exitBtn.addTarget(self, action: Selector("onExitBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(resultBtn)
        self.view.addSubview(exitBtn)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"openOneCard:",
            name: "kNotificationOneCardOpen", object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func openOneCard(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        self.result = userInfo["title"] as! String
        
        for cell in self.collection.visibleCells() {
            let cell2 = cell as? LotteryView
            cell2?.setProhibitCoating()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 9
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //返回Cell内容，这里我们使用刚刚建立的defaultCell作为显示内容
        let cell:LotteryView  = collection.dequeueReusableCellWithReuseIdentifier("defaultCell", forIndexPath: indexPath) as! LotteryView
        
        let array = ["5%","10%","15%","20%","25%","30%"]
        let index = rand() % 6
        cell.setLabelText(array[Int(index)])
        let image = UIImage(named: "coating")
        cell.setSurfaceImages(image!)
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
    }
    
    func onExitBtn(sender: UIButton){
       exit(0)
    }
    
    func onResultBtn(sender: UIButton) {
        if result.isEmpty {
            let alertView = UIAlertView(title: nil, message: "Please scratch one of the balls to win discount", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }
        else {
            let alertView = UIAlertView(title: nil, message: "You won " + self.result + " discount", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }
        
    }
}
