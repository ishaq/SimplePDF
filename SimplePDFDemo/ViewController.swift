//
//  ViewController.swift
//  SimplePDFDemo
//
//  Created by Muhammad Ishaq on 29/03/2015.
//  Copyright (c) 2015 Kahaf. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIDocumentInteractionControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func generateAndOpenPDF(sender: AnyObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            self.generateAndOpenPDFHandler()
        }
        
        
    }
    
    // MARK: - UIDocumentInteractionControllerDelegate
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    // MARK: - Private
    private func generateAndOpenPDFHandler() {
        let pdf = SimplePDF(pdfTitle: "Simple PDF Demo", authorName: "Muhammad Ishaq")
        
        self.addDocumentCover(pdf)
        self.addDocumentContent(pdf)
        self.addHeadersFooters(pdf)
        
        // here we may want to save the pdf somewhere or show it to the user
        let tmpPDFPath = pdf.writePDFWithTableOfContents()
        
        // open the generated PDF
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let pdfURL = NSURL(fileURLWithPath: tmpPDFPath)
            let interactionController = UIDocumentInteractionController(URL: pdfURL!)
            interactionController.delegate = self
            interactionController.presentPreviewAnimated(true)
        })
    }
    
    private func addDocumentCover(pdf: SimplePDF) {
        // NOTE: we manually format document title and use `addAttributedString` instead of, say, `addH1` because we don't want it in the TOC
        let documentTitle = NSMutableAttributedString(string: "Demo PDF")
        let titleFont = UIFont.boldSystemFontOfSize(48)
        let paragraphAlignment = NSMutableParagraphStyle()
        paragraphAlignment.alignment = .Center
        let titleRange = NSMakeRange(0, documentTitle.length)
        documentTitle.addAttribute(NSFontAttributeName, value: titleFont, range: titleRange)
        documentTitle.addAttribute(NSParagraphStyleAttributeName, value: paragraphAlignment, range: titleRange)
        pdf.addAttributedString(documentTitle)
        
        // we don't want anymore text on this page, so we force a page break
        pdf.startNewPage()
    }
    
    private func addDocumentContent(pdf: SimplePDF) {
        pdf.addH1("Lorem ipsum dolor sit amet")
        pdf.addBodyText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce nec enim est. Phasellus eu lacus ac ex facilisis porta eu ac nisi. Ut ullamcorper id justo vel lobortis. Cras sed egestas elit, malesuada maximus metus. Mauris faucibus, metus et interdum feugiat, mauris felis varius lacus, porta semper ipsum eros eget massa. Fusce et diam ac lacus bibendum rutrum ac nec neque. Proin rutrum nisl nec vestibulum commodo. Donec eu dolor quis sapien lobortis elementum. Ut tincidunt justo at mauris lobortis placerat. Nam tristique ornare luctus. Donec eu pretium sapien. Pellentesque venenatis eros nulla, eget tincidunt mauris tempor eget. In egestas orci a sem congue semper.")
        
        let imagePath = NSBundle.mainBundle().pathForResource("Demo", ofType: "png")!
        let imageCaption = "fig 1: Lorem ipsum dolor sit amet"
        pdf.addImages([imagePath], imageCaptions: [imageCaption], imagesPerRow: 1)
        
        pdf.addBodyText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce nec enim est. Phasellus eu lacus ac ex facilisis porta eu ac nisi. Ut ullamcorper id justo vel lobortis. Cras sed egestas elit, malesuada maximus metus. Mauris faucibus, metus et interdum feugiat, mauris felis varius lacus, porta semper ipsum eros eget massa. Fusce et diam ac lacus bibendum rutrum ac nec neque. Proin rutrum nisl nec vestibulum commodo. Donec eu dolor quis sapien lobortis elementum. Ut tincidunt justo at mauris lobortis placerat. Nam tristique ornare luctus. Donec eu pretium sapien. Pellentesque venenatis eros nulla, eget tincidunt mauris tempor eget. In egestas orci a sem congue semper.")
    }
    
    private func addHeadersFooters(pdf: SimplePDF) {
        let regularFont = UIFont.systemFontOfSize(8)
        let boldFont = UIFont.boldSystemFontOfSize(8)
        let leftAlignment = NSMutableParagraphStyle()
        leftAlignment.alignment = NSTextAlignment.Left
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        let dateString = dateFormatter.stringFromDate(NSDate())
        
        // add some document information to the header, on left
        let leftHeaderString = "Author: Muhammad Ishaq\nDate/Time: \(dateString)"
        var leftHeaderAttrString = NSMutableAttributedString(string: leftHeaderString)
        leftHeaderAttrString.addAttribute(NSParagraphStyleAttributeName, value: leftAlignment, range: NSMakeRange(0, leftHeaderAttrString.length))
        leftHeaderAttrString.addAttribute(NSFontAttributeName, value: regularFont, range: NSMakeRange(0, leftHeaderAttrString.length))
        leftHeaderAttrString.addAttribute(NSFontAttributeName, value: boldFont, range: leftHeaderAttrString.mutableString.rangeOfString("Author:"))
        leftHeaderAttrString.addAttribute(NSFontAttributeName, value: boldFont, range: leftHeaderAttrString.mutableString.rangeOfString("Date/Time:"))
        var header = SimplePDF.HeaderFooterText(type: .Header, pageRange: NSMakeRange(1, Int.max), attributedString: leftHeaderAttrString)
        pdf.headerFooterTexts.append(header)
        
        // add a logo to the header, on right
        let logoPath = NSBundle.mainBundle().pathForResource("Demo", ofType: "png")
        // NOTE: we can specify either the image or its path
        let rightLogo = SimplePDF.HeaderFooterImage(type: .Header, pageRange: NSMakeRange(1, Int.max),
            imagePath: logoPath!, image:nil, imageHeight: 35, alignment: .Right)
        pdf.headerFooterImages.append(rightLogo)
        
        // add page numbers to the footer (center aligned)
        let centerAlignment = NSMutableParagraphStyle()
        centerAlignment.alignment = .Center
        var footerString = NSMutableAttributedString(string: "\(pdf.kPageNumberPlaceholder) of \(pdf.kPagesCountPlaceholder)")
        footerString.addAttribute(NSParagraphStyleAttributeName, value: centerAlignment, range: NSMakeRange(0, footerString.length))
        var footer = SimplePDF.HeaderFooterText(type: .Footer, pageRange: NSMakeRange(1, Int.max), attributedString: footerString)
        pdf.headerFooterTexts.append(footer)
        
        // add a link to your app may be
        var link = NSMutableAttributedString(string: "http://ishaq.pk/")
        link.addAttribute(NSParagraphStyleAttributeName, value: leftAlignment, range: NSMakeRange(0, link.length))
        var appLinkFooter = SimplePDF.HeaderFooterText(type: .Footer, pageRange: NSMakeRange(1, Int.max), attributedString: link)
        pdf.headerFooterTexts.append(appLinkFooter)
        
        // NOTE: we can specify either the image or its path
        let footerImage = SimplePDF.HeaderFooterImage(type: .Footer, pageRange: NSMakeRange(1, Int.max),
            imagePath: logoPath!, image:nil, imageHeight: 20, alignment: .Right)
        pdf.headerFooterImages.append(footerImage)
    }

}

