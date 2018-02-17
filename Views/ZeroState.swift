//
//  ZeroState.swift
//  climbingweather
//
//  Created by Jon St. John on 2/14/18.
//

import UIKit

class ZeroState: UIView {
    
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
    
    private func commonInit() {
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

public protocol ZeroStateDelegate {
    func buttonTapped()
}
