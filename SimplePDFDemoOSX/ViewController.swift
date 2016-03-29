//
//  ViewController.swift
//  SimplePDFDemo
//
//  Created by Muhammad Ishaq on 29/03/2015.
//  Copyright (c) 2015 Kahaf. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
        
        override func viewDidLoad() {
                super.viewDidLoad()
                // Do any additional setup after loading the view, typically from a nib.
        }
        
        
        @IBAction func generateAndOpenPDF(sender: AnyObject) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                        self.generateAndOpenPDFHandler()
                }
                
                
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
                        print("Writing \(tmpPDFPath)")
                        NSWorkspace.sharedWorkspace().openURL(pdfURL)
                })
        }
        
        private func addDocumentCover(pdf: SimplePDF) {
                // Cover Page can be designed in a nib (.xib) and added to pdf via `pdf.addView()` call.
                //
                // Here's how you can design a cover page with using a UIView (sample applies to any other view that you want to add to pdf)
                // 1. Create a nib with the same dimensions as PDF page (e.g. A4 page is 595x842)
                // 2. All the labels in the view should have their class set to `SimplePDFLabel` (or a subclass of it)
                // 3. Load the view from the nib and add it to pdf
                // ```
                // // ...
                // let coverPage = NSBundle.mainBundle().loadNibNamed("PDFCoverPage", owner: self, options: nil).first as PDFCoverPage
                // pdf.addView(coverPage)
                // ```
                //
                // NOTE:
                //      Please note that if you use the above method to render a view to PDF, AutoLayout will *not* be run on it, If your view doesn't rely on
                // autolayout e.g. say it's a simple table, you don't need to worry about anything.
                //
                // However, if your view uses AutoLayout to correctly position elements, you *have to* add it to the active view hierarchy. You can add to the
                // view hierarchy off-screen, then call `pdf.addView()` to render it to PDF. The catch here is that now the view would render as *bitmap*. This means
                // any labels will not be selectable as text and they would lose quality if you zoom in (because they are bitmaps).
                //
                
                
                // NOTE: we manually format document title and use `addAttributedString` instead of, say, `addH1` because we don't want it in the TOC
                let documentTitle = NSMutableAttributedString(string: "Demo PDF")
                let titleFont = NSFont.boldSystemFontOfSize(48)
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
                pdf.addH2("Level 2 Heading")
                pdf.addBodyText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce nec enim est. Phasellus eu lacus ac ex facilisis porta eu ac nisi. Ut ullamcorper id justo vel lobortis. Cras sed egestas elit, malesuada maximus metus. Mauris faucibus, metus et interdum feugiat, mauris felis varius lacus, porta semper ipsum eros eget massa. Fusce et diam ac lacus bibendum rutrum ac nec neque. Proin rutrum nisl nec vestibulum commodo. Donec eu dolor quis sapien lobortis elementum. Ut tincidunt justo at mauris lobortis placerat. Nam tristique ornare luctus. Donec eu pretium sapien. Pellentesque venenatis eros nulla, eget tincidunt mauris tempor eget. In egestas orci a sem congue semper.")
                
                let imagePath = NSBundle.mainBundle().pathForResource("Demo", ofType: "png")!
                let imageCaption = "fig 1: Lorem ipsum dolor sit amet"
                pdf.addImages([imagePath], imageCaptions: [imageCaption], imagesPerRow: 1)
                
                pdf.addBodyText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce nec enim est. Phasellus eu lacus ac ex facilisis porta eu ac nisi. Ut ullamcorper id justo vel lobortis. Cras sed egestas elit, malesuada maximus metus. Mauris faucibus, metus et interdum feugiat, mauris felis varius lacus, porta semper ipsum eros eget massa. Fusce et diam ac lacus bibendum rutrum ac nec neque. Proin rutrum nisl nec vestibulum commodo. Donec eu dolor quis sapien lobortis elementum. Ut tincidunt justo at mauris lobortis placerat. Nam tristique ornare luctus. Donec eu pretium sapien. Pellentesque venenatis eros nulla, eget tincidunt mauris tempor eget. In egestas orci a sem congue semper.")
                
                for i in 0..<2 {
                        pdf.addH3("Level 3 Heading \(i)")
                        pdf.addBodyText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce nec enim est. Phasellus eu lacus ac ex facilisis porta eu ac nisi. Ut ullamcorper id justo vel lobortis. Cras sed egestas elit, malesuada maximus metus. Mauris faucibus, metus et interdum feugiat, mauris felis varius lacus, porta semper ipsum eros eget massa. Fusce et diam ac lacus bibendum rutrum ac nec neque. Proin rutrum nisl nec vestibulum commodo. Donec eu dolor quis sapien lobortis elementum. Ut tincidunt justo at mauris lobortis placerat. Nam tristique ornare luctus. Donec eu pretium sapien. Pellentesque venenatis eros nulla, eget tincidunt mauris tempor eget. In egestas orci a sem congue semper.")
                        for j in 0..<3 {
                                pdf.addH4("Level 4 Heading \(j)")
                                pdf.addBodyText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce nec enim est. Phasellus eu lacus ac ex facilisis porta eu ac nisi. Ut ullamcorper id justo vel lobortis. Cras sed egestas elit, malesuada maximus metus. Mauris faucibus, metus et interdum feugiat, mauris felis varius lacus, porta semper ipsum eros eget massa. Fusce et diam ac lacus bibendum rutrum ac nec neque. Proin rutrum nisl nec vestibulum commodo. Donec eu dolor quis sapien lobortis elementum. Ut tincidunt justo at mauris lobortis placerat. Nam tristique ornare luctus. Donec eu pretium sapien. Pellentesque venenatis eros nulla, eget tincidunt mauris tempor eget. In egestas orci a sem congue semper.")
                                for k in 0..<3 {
                                        pdf.addH5("Level 5 Heading \(k)")
                                        pdf.addBodyText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce nec enim est. Phasellus eu lacus ac ex facilisis porta eu ac nisi. Ut ullamcorper id justo vel lobortis. Cras sed egestas elit, malesuada maximus metus. Mauris faucibus, metus et interdum feugiat, mauris felis varius lacus, porta semper ipsum eros eget massa. Fusce et diam ac lacus bibendum rutrum ac nec neque. Proin rutrum nisl nec vestibulum commodo. Donec eu dolor quis sapien lobortis elementum. Ut tincidunt justo at mauris lobortis placerat. Nam tristique ornare luctus. Donec eu pretium sapien. Pellentesque venenatis eros nulla, eget tincidunt mauris tempor eget. In egestas orci a sem congue semper.")
                                        
                                        pdf.addImages([imagePath, imagePath, imagePath, imagePath], imageCaptions: [imageCaption, imageCaption, imageCaption, imageCaption], imagesPerRow: 3, spacing: 10, padding: 5)
                                }
                        }
                }
        }
        
        private func addHeadersFooters(pdf: SimplePDF) {
                let regularFont = NSFont.systemFontOfSize(8)
                let boldFont = NSFont.boldSystemFontOfSize(8)
                let leftAlignment = NSMutableParagraphStyle()
                leftAlignment.alignment = NSTextAlignment.Left
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
                let dateString = dateFormatter.stringFromDate(NSDate())
                
                // add some document information to the header, on left
                let leftHeaderString = "Author: Muhammad Ishaq\nDate/Time: \(dateString)"
                let leftHeaderAttrString = NSMutableAttributedString(string: leftHeaderString)
                leftHeaderAttrString.addAttribute(NSParagraphStyleAttributeName, value: leftAlignment, range: NSMakeRange(0, leftHeaderAttrString.length))
                leftHeaderAttrString.addAttribute(NSFontAttributeName, value: regularFont, range: NSMakeRange(0, leftHeaderAttrString.length))
                leftHeaderAttrString.addAttribute(NSFontAttributeName, value: boldFont, range: leftHeaderAttrString.mutableString.rangeOfString("Author:"))
                leftHeaderAttrString.addAttribute(NSFontAttributeName, value: boldFont, range: leftHeaderAttrString.mutableString.rangeOfString("Date/Time:"))
                let header = SimplePDF.HeaderFooterText(type: .Header, pageRange: NSMakeRange(1, Int.max), attributedString: leftHeaderAttrString)
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
                let footerString = NSMutableAttributedString(string: "\(pdf.kPageNumberPlaceholder) of \(pdf.kPagesCountPlaceholder)")
                footerString.addAttribute(NSParagraphStyleAttributeName, value: centerAlignment, range: NSMakeRange(0, footerString.length))
                let footer = SimplePDF.HeaderFooterText(type: .Footer, pageRange: NSMakeRange(1, Int.max), attributedString: footerString)
                pdf.headerFooterTexts.append(footer)
                
                // add a link to your app may be
                let link = NSMutableAttributedString(string: "http://ishaq.pk/")
                link.addAttribute(NSParagraphStyleAttributeName, value: leftAlignment, range: NSMakeRange(0, link.length))
                let appLinkFooter = SimplePDF.HeaderFooterText(type: .Footer, pageRange: NSMakeRange(1, Int.max), attributedString: link)
                pdf.headerFooterTexts.append(appLinkFooter)
                
                // NOTE: we can specify either the image or its path
                let footerImage = SimplePDF.HeaderFooterImage(type: .Footer, pageRange: NSMakeRange(1, Int.max),
                        imagePath: logoPath!, image:nil, imageHeight: 20, alignment: .Right)
                pdf.headerFooterImages.append(footerImage)
        }
        
}


