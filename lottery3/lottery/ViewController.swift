//
//  YQ app
//
import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    var collection: UICollectionView!
    var coverView: CoverImageView!
    var resultBtn: UIButton!
    var exitBtn:   UIButton!
    var isOpen: Bool = false
    var dataArr: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.itemSize = CGSize(width: ((self.view.bounds.width - 40) - 10 * 4)/3, height: (self.view.bounds.width - 10 * 4)/3)
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.view.backgroundColor = UIColor.whiteColor()
        var rect = CGRect(origin: CGPoint(x: 20, y: 0), size: CGSize(width: self.view.frame.width - 40, height: self.view.frame.height * 3 / 5.0))
        rect.origin.y = self.view.frame.height / 2.0 - rect.size.height / 2.0
        collection = UICollectionView(frame: rect, collectionViewLayout: flowLayout)
        collection.dataSource = self
        collection.delegate = self
        collection.registerClass(LotteryView.classForCoder(), forCellWithReuseIdentifier: "defaultCell")
        collection.backgroundColor = UIColor.whiteColor()
        self.view .addSubview(collection)
        
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "background")
        self.view.insertSubview(backgroundImage, atIndex: 0)
        
        let headerImage = UIImage(named: "Tittle")
        var headerRect = CGRect(origin: CGPoint(x: 10, y: 0),
                                size: CGSize(width: self.view.frame.width - 20, height: (self.view.frame.width - 20) * 119 / 884.0))
        headerRect.origin.y = (rect.origin.y - headerRect.size.height) / 2.0
        let headerView = UIImageView(frame: headerRect)
        headerView.image = headerImage
        self.view.addSubview(headerView)
        
        
        coverView = CoverImageView(frame: rect)
        coverView.refreshImageView()
        self.view.addSubview(coverView)
        
        resultBtn = UIButton(type: UIButtonType.System)
        resultBtn.showsTouchWhenHighlighted = true;
        resultBtn.frame = CGRectMake(80, self.view.frame.height - 80, 100, 20)
        resultBtn.setTitle("result", forState: UIControlState.Normal)
        resultBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        resultBtn.addTarget(self, action: #selector(ViewController.onResultBtn(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        exitBtn = UIButton(type: UIButtonType.System)
        exitBtn.showsTouchWhenHighlighted = true;
        exitBtn.frame = CGRectMake(self.view.frame.width - 80 - 100, self.view.frame.height - 80, 100, 20)
        exitBtn.setTitle("exit", forState: UIControlState.Normal)
        exitBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        exitBtn.addTarget(self, action: #selector(ViewController.onExitBtn(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(resultBtn)
        self.view.addSubview(exitBtn)
        
        let array = [5, 10, 15, 20, 25, 30]
        dataArr = [array[Int(arc4random_uniform(6))], array[Int(arc4random_uniform(6))], array[Int(arc4random_uniform(6))],
                   array[Int(arc4random_uniform(6))], array[Int(arc4random_uniform(6))], array[Int(arc4random_uniform(6))],
                   array[Int(arc4random_uniform(6))], array[Int(arc4random_uniform(6))]]
        
        dataArr.addObject(array[Int(arc4random_uniform(6))])
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ViewController.openCard(_:)),
                                                         name: "kNotificationCardOpen", object: nil)
        
    }
    
    func openCard(notification: NSNotification) {
        
        self.isOpen = true
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

        let cell:LotteryView  = collection.dequeueReusableCellWithReuseIdentifier("defaultCell", forIndexPath: indexPath) as! LotteryView
        let text:String = String(format: "%d", Int(dataArr[Int(indexPath.item)] as! NSNumber))
        cell.setLabelText(text + "%")
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
    }
    
    func onExitBtn(sender: UIButton){
       exit(0)
    }
    
    func onResultBtn(sender: UIButton) {
        if !self.isOpen {
            let alertView = UIAlertView(title: nil, message: "Please scratch the balls to win discount", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }
        else {
            
            var result = 0
            var resultCount = 0;
            let array = [5, 10, 15, 20, 25, 30]
            for value in  array{
                var count = 0
                for realValue in dataArr {
                    
                    let real:NSNumber = realValue as! NSNumber
                    if (real == value) {
                        count += 1;
                    }
                }
                if (resultCount <= count) {
                    if resultCount < count {
                        resultCount = count
                        result = value
                    }
                    else if (result < value){
                        result = value
                    }
                }
                
            }
            let alertView = UIAlertView(title: nil, message: "Congrats you won " + String(format: "%d", Int(result)) + "% discount", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }
        
    }
    
}
