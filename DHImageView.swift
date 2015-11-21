import UIKit

class WSLoadingBar: WSView {
    private var barWidthConstraint: NSLayoutConstraint!
    private lazy var movingBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blueColor()
        self.addSubview(view)
        |~|view
        self.barWidthConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        view.addConstraint(self.barWidthConstraint)
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view" : view]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view" : view]))
        return view
    }()
    override func setUp() {
        movingBar.hidden = false
        updateFrame(1)
    }
    
    /**
    Updates the amount the loading bar is filed
    @param: takes in a value between 0.0 and 1.0.  
    @discussion: Anything less than 0.0 will be interpreted as 0.0 and anything more than 1.0 will be interpreted as 1.0.
    */
    func updateFrame(level: CGFloat) {
        self.layoutIfNeeded()
        switch level {
        case let i where i < 0.0:
            updateFrame(0.0)
        case let i where i > 1.0:
            updateFrame(1.0)
        case 0.0..<0.1:
            self.barWidthConstraint.constant = frame.width * 0.1
        case 0.1...1.0: fallthrough
        default:
            self.barWidthConstraint.constant = frame.width * level
        }
        self.movingBar.layoutIfNeeded()
    }
}

@IBDesignable
class WSImageView: WSView {
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        self.addSubview(view)
        |~|(view)
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view" : view]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view" : view]))
        return view
        }()
    private lazy var loadingBar: WSLoadingBar = {
        let view = WSLoadingBar()
        self.imageView.addSubview(view)
        |~|view
        self.imageView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view" : view]))
        self.imageView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[view(3)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view" : view]))
        return view
        }()
    override func setUp() {
        imageView.hidden = false
        loadingBar.updateFrame(0)
    }
    func updateLoadingBar(amt: CGFloat) {
        loadingBar.updateFrame(amt)
        self.layoutIfNeeded()
        self.loadingBar.layoutIfNeeded()
    }
}
