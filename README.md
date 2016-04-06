# SimplePDF
SimplePDF is a Swift class that lets you create simple PDF documents with page numbers and table of contents. The code is a rough implementation of [Builder](https://en.wikipedia.org/wiki/Builder_pattern) design pattern. See the demo project for usage example.

### Features
Although SimplePDF can only generate simple PDF documents, It can be used in a variety of use cases. It allows you to add:

* Headings (H1 - H6) and Body Text. (Formatting of these can be customized by passing a custom subclass of `DefaultTextFormatter` to the SimplePDF `init` method.)
* Images (with captions).
* Add text to multiple columns, this can also be used to create borderless tables
* Headers/Footers (with page number and pages count)
* UIView instances (You can design a UIView in a nib or in a storyboard and add it as a page to the PDF, This can be useful to add, for example, a cover page with company logo, etc.)

In addition to predefined headings and body text formats, you can also add any `NSAttributedString` to the pdf, however it will not be included in Table of Contents. Table of Contents only takes into account the content added through `addH1` ... `addH6` functions.

### Supported iOS & SDK Version
As of this writing, SimplePDF is in Swift 2.1. Therefore you need Xcode 7.2.1 for development. You can probably target iOS 8.0 and later.

## Getting Started
Copy the files in _SimplePDF_ directory to your project (note to self: need to make it a pod) and start using it. Here's what typical usage would look like:

```swift
// Initialize
let pdf = SimplePDF(pdfTitle: "Simple PDF Demo", authorName: "Muhammad Ishaq")

// add some content
pdf.addH1("Level 2 Heading")
pdf.addBodyText("Some body text, probably a long string with multiple paras")
pdf.addH2("Level 2 Heading")
pdf.addBodyText("Lorem ipsum dolor sit amet...")

// add an image
let imagePath = NSBundle.mainBundle().pathForResource("Demo", ofType: "png")!
let imageCaption = "fig 1: Lorem ipsum dolor sit amet"
pdf.addImages([imagePath], imageCaptions: [imageCaption], imagesPerRow: 1)

// Configure headers/footers (discussed below)
// ...

// Write PDF
// Note that the tmpPDFPath is path to a temporary file, it needs to be saved somewhere
let tmpPDFPath = pdf.writePDFWithTableOfContents()
```

There is also a `writePDFWithoutTableOfContents()` function if you don't want Table of Contents.

### Adding Headers/Footers

There are two types of Headers/Footers.

1. **Text** This is added using `HeaderFooterText` instance, any new line characters result in multiline header (or footer). This can be name of the author and document creation date for example, or it can be the page number e.g. "Page 1 of 12".

2. **Image:** This is added using `HeaderFooterImage` instance and can only be a single image (e.g. an icon or logo).

**Alignment:** Header/Footer can have Left, Center or Right alignment, It will be added to the corresponding location on top/bottom of the page.

**Page Number & Pages Count:** In a text header/footer, occurrences of `pdf.kPageNumberPlaceholder` are replaced with the current page number and of `pdf.kPagesCountPlaceholder` are replaced with pages count.

The `pageRange` attribute controls which pages the header/footer appears on. `pageRange` is an `NSRange` instance, `pageRange.location` specifies zero based page index where the header/footer would first appear. `pageRange.length` specifies how many pages it would appear on (starting at `pageRange.location`).

Here's how a multiline header (or footer) could be added (in this case it is a header on the left):

```swift
// Variables to format the header string
let regularFont = UIFont.systemFontOfSize(8)
let boldFont = UIFont.boldSystemFontOfSize(8)
let leftAlignment = NSMutableParagraphStyle()
leftAlignment.alignment = NSTextAlignment.Left
let dateFormatter = NSDateFormatter()
dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
let dateString = dateFormatter.stringFromDate(NSDate())

// Create the attributed string for header
let leftHeaderString = "Author: Muhammad Ishaq\nDate/Time: \(dateString)"
let leftHeaderAttrString = NSMutableAttributedString(string: leftHeaderString)
leftHeaderAttrString.addAttribute(NSParagraphStyleAttributeName, value: leftAlignment, range: NSMakeRange(0, leftHeaderAttrString.length))
leftHeaderAttrString.addAttribute(NSFontAttributeName, value: regularFont, range: NSMakeRange(0, leftHeaderAttrString.length))
leftHeaderAttrString.addAttribute(NSFontAttributeName, value: boldFont, range: leftHeaderAttrString.mutableString.rangeOfString("Author:"))
leftHeaderAttrString.addAttribute(NSFontAttributeName, value: boldFont, range: leftHeaderAttrString.mutableString.rangeOfString("Date/Time:"))

// Create the header
// location of pageRange is 1, so it skips page 0 i.e. the first page
let header = SimplePDF.HeaderFooterText(type: .Header, pageRange: NSMakeRange(1, Int.max), attributedString: leftHeaderAttrString)
pdf.headerFooterTexts.append(header)
```

Here's how a logo could be added (in this case it is a header on the right)

```swift
// add a logo to the header, on right
let logoPath = NSBundle.mainBundle().pathForResource("Demo", ofType: "png")
// location of pageRange is 1, so it skips page 0 i.e. the first page
// NOTE: we can specify either the image (UIImage instance) or its path
let rightLogo = SimplePDF.HeaderFooterImage(type: .Header, pageRange: NSMakeRange(1, Int.max),
    imagePath: logoPath!, image:nil, imageHeight: 35, alignment: .Right)
pdf.headerFooterImages.append(rightLogo)
```

And here's how page number and with pages count could be added (in this case it's a footer in the center):

```swift
// add page numbers to the footer (center aligned)
let centerAlignment = NSMutableParagraphStyle()
centerAlignment.alignment = .Center
let footerString = NSMutableAttributedString(string: "\(pdf.kPageNumberPlaceholder) of \(pdf.kPagesCountPlaceholder)")
footerString.addAttribute(NSParagraphStyleAttributeName, value: centerAlignment, range: NSMakeRange(0, footerString.length))
// location of pageRange is 1, so it skips page 0 i.e. the first page
let footer = SimplePDF.HeaderFooterText(type: .Footer, pageRange: NSMakeRange(1, Int.max), attributedString: footerString)
pdf.headerFooterTexts.append(footer)
```


### Adding View
You can call `addView(view)` to render UIView instances to a PDF page. The passed view will be rendered new PDF page. This is mostly useful to design cover pages. A view is always added to its own page. It starts a new page if required, and any content added after it appears on the next page.

Here's how you can design a cover page with a UIView (or a subclass)

1. Create a nib with the same dimensions as PDF page (e.g. A4 page is 595x842, you can lookup other dimensions in `PageSize` enum).
2. All the labels in the view should have their class set to `SimplePDFLabel` (or a subclass of it)
3. Load the view from the nib and add it to pdf

```swift
let coverPage = NSBundle.mainBundle().loadNibNamed("PDFCoverPage", owner: self, options: nil).first as PDFCoverPage
pdf.addView(coverPage)
```

#### Note
Please note that if you use the above method to render a view to PDF, AutoLayout will **not** be run on it, If your view doesn't rely on AutoLayout, you don't need to worry about anything. However, if your view uses AutoLayout to correctly position elements, you **have to** add it to the active view hierarchy. You can add to the view hierarchy off-screen, then call `pdf.addView(view)` to render it to PDF. But now the view would render as *bitmap*. This means any labels will not be selectable as text and they would lose quality if you zoom in (being bitmaps).

## License
```
The MIT License (MIT)

Copyright (c) 2015 Muhammad Ishaq

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
