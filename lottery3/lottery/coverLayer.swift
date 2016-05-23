//
//  coverLayer.swift
//  lottery
//
//  Created by Alan, Edward, Tram, Ardee.

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

class CoverImageView: UIImageView {
    var path: NSMutableArray!
    var isOpen: Bool = false
    var coverImage: UIImage!
    var boundPath:CGMutablePathRef!
    
    func refreshImageView() {
    
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
        coverImage = UIImage(named: "cover")!
        self.image = coverImage
        self.path = NSMutableArray()
        self.boundPath = CGPathCreateMutable()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if !self.isOpen{
            let touch:UITouch = (touches as NSSet).anyObject()! as! UITouch
            let point:CGPoint = touch.locationInView(self)
            let tPoint = Point(x: point.x,y: point.y);
            self.path.addObject(tPoint)
            
            CGPathMoveToPoint(self.boundPath, nil, point.x, point.y)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        if !self.isOpen{
            let touch:UITouch = (touches as NSSet).anyObject()! as! UITouch
            let point:CGPoint = touch.locationInView(self)
            let tPoint = Point(x: point.x,y: point.y);
            self.path.addObject(tPoint)
            CGPathAddLineToPoint(self.boundPath, nil, point.x, point.y)
            drawMaskImage(self.path)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        if !self.isOpen{
            self.checkForOpen()
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        if !self.isOpen{
            self.checkForOpen()
        }
    }
    
    func getPointsArray() ->NSArray {
        let array:NSMutableArray = NSMutableArray()
        
        let width:CGFloat = CGRectGetWidth(self.bounds)
        let height:CGFloat = CGRectGetHeight(self.bounds)
        
        let topPoint:CGPoint = CGPointMake(width/2, height/6)
        let leftPoint:CGPoint = CGPointMake(width/6, height/2)
        let bottomPoint:CGPoint = CGPointMake(width/2, height-height/6)
        let rightPoint:CGPoint = CGPointMake(width-width/6, height/2)
        
        array.addObject(NSValue(CGPoint:topPoint))
        array.addObject(NSValue(CGPoint:leftPoint))
        array.addObject(NSValue(CGPoint:bottomPoint))
        array.addObject(NSValue(CGPoint:rightPoint))
        
        return array
    }
    
    func checkForOpen() {
        
        let rect:CGRect = CGPathGetPathBoundingBox(self.boundPath)
        
        let pointsArray:NSArray = self.getPointsArray()
        for value in pointsArray {
            let point:CGPoint = value.CGPointValue()
            if !CGRectContainsPoint(rect, point) {
                return
            }
        }
        
        //检查红色的中间区域有多少红色像素点
        let image = self.image
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image!.CGImage))
        let data = CFDataGetBytePtr(pixelData)
        var count = 0;
        let imagePiexelWidth = CGImageGetWidth(image!.CGImage);
        let startX = 0
        let startY = 0
        let stopX = Int(self.frame.size.width)
        let stopY = Int(self.frame.size.height);

        for i in  startX ... stopX{
            for j in startY ... stopY {
                let pixelInfo: Int = Int(((imagePiexelWidth * j) + i)) * 4
                let alpha = data[pixelInfo + 3]

                if alpha == 0 {
                    count += 1
                }
            }

        }

        let multiple = Int(CGFloat(imagePiexelWidth) / (image?.size.width)!)
        var okCount = 7500
        if multiple <= 2{
            okCount = multiple * 35000
        }
        else {
            okCount = multiple * 35000
        }


        if count >  okCount {
            self.isOpen = true
            self.image = imageByColor(UIColor(white: 0, alpha: 0))
            NSNotificationCenter.defaultCenter().postNotificationName("kNotificationCardOpen", object: self, userInfo:nil)

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
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.mainScreen().scale);
        let rect = CGRect(origin: CGPoint(x:0, y: 0), size: self.frame.size)
        coverImage.drawInRect(rect)
        for point in points {
            let clearRect = CGRect(origin: CGPoint(x: point.getX() - 10, y: point.getY() - 10), size: CGSize(width: 40, height: 40))
            CGContextClearRect(UIGraphicsGetCurrentContext(), clearRect);
        }
        
        let maskImage = UIGraphicsGetImageFromCurrentImageContext();
        self.image = maskImage
        UIGraphicsEndImageContext();
    }

}