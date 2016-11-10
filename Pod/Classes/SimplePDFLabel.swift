//
//  PDFLabel.swift
//
//  Created by Muhammad Ishaq on 22/03/2015.
//

import UIKit

class SimplePDFLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let isPDF = !UIGraphicsGetPDFContextBounds().isEmpty
        let layer = self.layer
        if(!layer.shouldRasterize && isPDF && (self.backgroundColor == nil || self.backgroundColor!.cgColor.alpha == 0)) {
            self.draw(self.bounds)
        }
        else {
            super.drawText(in: rect)
        }
    }
}
