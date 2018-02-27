//
//  ZeroState.swift
//  climbingweather
//
//  Created by Jon St. John on 2/14/18.
//

import UIKit

internal class ZeroState: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    
    public var delegate: ZeroStateDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    internal func commonInit() {
        Bundle.main.loadNibNamed("ZeroState", owner: self, options: nil)
        self.addSubview(self.contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.mainButton.layer.cornerRadius = 4
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        self.delegate?.buttonTapped()
    }

}

internal class ZeroStateNoAreasFound: ZeroState {
    override internal func commonInit() {
        super.commonInit()
        self.mainLabel.text = "No areas found"
    }
    
}

internal class ZeroStateNoFavorites: ZeroState {
    override internal func commonInit() {
        super.commonInit()
        self.mainLabel.text = "To add a favorite, first find the area and tap on the yellow star at the top right of the screen"
    }
    
}

internal class ZeroStateFailedToAcquireLocation: ZeroState {
    override internal func commonInit() {
        super.commonInit()
        self.mainLabel.text = "Failed to acquire location"
    }
    
}

internal class ZeroStateLocationNotEnabled: ZeroState {
    
    override internal func commonInit() {
        super.commonInit()
        self.mainLabel.text = "Location access is not currently enabled"
        self.mainButton.setTitle("Open Settings", for: .normal)
        self.mainButton.isHidden = false
    }
    
}


public protocol ZeroStateDelegate {
    func buttonTapped()
}
