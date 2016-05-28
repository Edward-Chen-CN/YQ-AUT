//
//  YQ app
//

import UIKit


class LotteryView: UICollectionViewCell {
    
    var textLabel: UILabel!
    var surfaceImage: UIImage!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        textLabel = UILabel(frame: CGRect(origin: CGPoint(x: frame.width / 2 - 30, y: frame.height / 2 - 15), size: CGSize(width: 50, height: 30)))
        textLabel.textAlignment = NSTextAlignment.Center
        textLabel.font = UIFont.systemFontOfSize(20)
        textLabel.textColor = UIColor.blackColor()
        self.addSubview(textLabel);
        
    }
    
    func setLabelText(labelText:String) {
        textLabel.text = labelText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

