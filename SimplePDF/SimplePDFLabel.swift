//
//  PDFLabel.swift
//
//  Created by Muhammad Ishaq on 22/03/2015.
//

import UIKit

class SimplePDFLabel: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {
        let isPDF = !CGRectIsEmpty(UIGraphicsGetPDFContextBounds())
        
        if(!layer.shouldRasterize && isPDF && (self.backgroundColor == nil || CGColorGetAlpha(self.backgroundColor?.CGColor) == 0)) {
            self.drawRect(self.bounds)
        }
        else {
            super.drawLayer(layer, inContext: ctx)
        }
    }

}
