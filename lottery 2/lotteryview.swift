//
//  YQ app
//

import UIKit

class Point: NSObject {
    var x : CGFloat!
    var y : CGFloat!
    
    init(x :CGFloat, y:CGFloat) {
        self.x = x;
        self.y = y;
    }
    
    func getX() ->CGFloat {
        return x;
    }
    
    func getY() ->CGFloat {
        return y;
    }
}

class LotteryView: UICollectionViewCell {
    
    var textLabel: UILabel!
    var surfaceImage: UIImage!
    var surfaceImageView: UIImageView!
    var path: NSMutableArray!
    var isOpen: Bool = false
    var isProhibit: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        textLabel = UILabel(frame: CGRect(origin: CGPoint(x: frame.width / 2 - 30, y: frame.height / 2 - 15), size: CGSize(width: 50, height: 30)))
        textLabel.textAlignment = NSTextAlignment.Center
        textLabel.font = UIFont.systemFontOfSize(20)
        textLabel.textColor = UIColor.blackColor()
        self.addSubview(textLabel);

        self.surfaceImageView = UIImageView(frame: self.bounds)
        surfaceImage = self.imageByColor(UIColor(white: 0.3, alpha: 1))
        self.surfaceImageView.image = surfaceImage;
        self.addSubview(self.surfaceImageView)
        
        self.path = NSMutableArray()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if !self.isOpen  && !isProhibit {
            let touch:UITouch = (touches as NSSet).anyObject()! as! UITouch
            let point:CGPoint = touch.locationInView(self)
            let tPoint = Point(x: point.x,y: point.y);
            self.path.addObject(tPoint)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        if !self.isOpen && !isProhibit {
            let touch:UITouch = (touches as NSSet).anyObject()! as! UITouch
            let point:CGPoint = touch.locationInView(self)
            let tPoint = Point(x: point.x,y: point.y);
            self.path.addObject(tPoint)
            
            drawMaskImage(self.path)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        if !self.isOpen && !isProhibit {
            self.checkForOpen()
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        if !self.isOpen && !isProhibit {
            self.checkForOpen()
        }
    }
    
    
    func setLabelText(labelText:String) {
        textLabel.text = labelText
    }
    
    
    func setSurfaceImages(image: UIImage) {
        let desImage = self.imageCompressWithSize(image,size: self.frame.size)
        surfaceImage = desImage
        self.surfaceImageView.image = desImage
    }
    
    func setProhibitCoating(){
        self.isProhibit = true
    }
    
    func checkForOpen() {
        
        //检查红色的中间区域有多少红色像素点
        let image = self.surfaceImageView.image

        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image!.CGImage))
        let data = CFDataGetBytePtr(pixelData)
        var count = 0;
        let imagePiexelWidth = CGImageGetWidth(image!.CGImage);
        let imagePiexelHeight = CGImageGetWidth(image!.CGImage);
        let startX = Int(self.textLabel.frame.origin.x) * 2;
        let startY = Int(self.textLabel.frame.origin.y) * 2;
        let stopX = Int(textLabel.frame.origin.x + textLabel.frame.width) * Int(CGFloat(imagePiexelWidth) / (image?.size.width)!);
        let stopY = Int(textLabel.frame.origin.y + textLabel.frame.height) * Int(CGFloat(imagePiexelHeight) / (image?.size.height)!);

        for i in  startX ... stopX{
            for j in startY ... stopY {
                let pixelInfo: Int = Int(((imagePiexelWidth * j) + i)) * 4
                let alpha = data[pixelInfo + 3]
                
                if alpha == 0 {
                    count++
                }
            }
    
        }
        
        //如果label只有100个以下的像素是红点，则说明已经出来了
        let multiple = Int(CGFloat(imagePiexelWidth) / (image?.size.width)!)
        var okCount = 2500
        if multiple <= 2{
            okCount = multiple * 2500
        }
        else {
            okCount = multiple * 3700
        }
            
        
        if count >  okCount {
            self.isOpen = true
            self.surfaceImage = imageByColor(UIColor(white: 0, alpha: 0))
            self.surfaceImageView.image = self.surfaceImage
            let text:String = self.textLabel.text!
            NSNotificationCenter.defaultCenter().postNotificationName("kNotificationOneCardOpen", object: self, userInfo: ["title": text])

        }
    }
    
    func imageByColor(color:UIColor) -> UIImage {
        let imageSize:CGSize = CGSizeMake(1, 1)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.mainScreen().scale)
        color.set()
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height))
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
            
    }

    
    func drawMaskImage(points:NSMutableArray) {
        UIGraphicsBeginImageContextWithOptions(self.surfaceImageView.frame.size, false, UIScreen.mainScreen().scale);
        let rect = CGRect(origin: CGPoint(x:0, y: 0), size: self.surfaceImageView.frame.size)
        surfaceImage.drawInRect(rect)
        for point in points {
            let clearRect = CGRect(origin: CGPoint(x: point.getX() - 5, y: point.getY() - 5), size: CGSize(width: 10, height: 10))
            CGContextClearRect(UIGraphicsGetCurrentContext(), clearRect);
        }

        let maskImage = UIGraphicsGetImageFromCurrentImageContext();
        surfaceImageView.image = maskImage
        UIGraphicsEndImageContext();
    }
    
    func imageCompressWithSize(oriImage:UIImage, size:CGSize) ->UIImage {
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(origin: CGPoint(x:0, y: 0), size: CGSize(width: size.width, height: size.height))
        oriImage.drawInRect(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

