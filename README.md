# SimplePDF

<!-- [![CI Status](http://img.shields.io/travis/Muhammad Ishaq/SimplePDF.svg?style=flat)](https://travis-ci.org/Muhammad Ishaq/SimplePDF) -->
[![Version](https://img.shields.io/cocoapods/v/SimplePDFSwift.svg?style=flat)](http://cocoapods.org/pods/SimplePDFSwift)
[![License](https://img.shields.io/cocoapods/l/SimplePDFSwift.svg?style=flat)](http://cocoapods.org/pods/SimplePDFSwift)
[![Platform](https://img.shields.io/cocoapods/p/SimplePDFSwift.svg?style=flat)](http://cocoapods.org/pods/SimplePDFSwift)
[![Stories in Ready](https://badge.waffle.io/ishaq/SimplePDF.png?label=ready&title=Ready)](https://waffle.io/ishaq/SimplePDF)

SimplePDF is a Swift class that lets you create simple PDF documents with page numbers and table of contents. The code is a rough implementation of [Builder](https://en.wikipedia.org/wiki/Builder_pattern) design pattern. See the demo project for usage example.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first. Or run `pod try SimplePDFSwift`.

:warning: **Important: Pod for this library is called `SimplePDFSwift`, Please note that pod named `SimplePDF` is a different library (It is available [here](https://github.com/nrewik/SimplePDF) if you'd like to try it).** :warning:

## Requirements

SimplePDF is written in Swift 3.0 as of version 0.2.1. Therefore you need Xcode 8.0 for development. You can target iOS 8.0 and later.

To use SimplePDF on previous versions of Swift, you can use a version earlier than **0.2.1**.


## Installation

SimplePDF is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SimplePDFSwift"
```

### Features
Although SimplePDF can only generate simple PDF documents, It can be used in a variety of use cases. It allows you to add:

* Headings (H1 - H6) and Body Text. Their formatting can be customized by passing a subclass of `DefaultTextFormatter` to SimplePDF `init` method
* Images (with captions)
* Add text to multiple columns, it can also be used to create borderless tables
* Headers/Footers (with page number and pages-count)
* UIView instances (You can design a UIView in a nib or in a storyboard and add it as a page to the PDF. This can be useful to add, for example, a cover page with company logo, etc.)

In addition to predefined headings and body text formats, you can also add any `NSAttributedString` to the pdf, however it will not be included in Table of Contents. Table of Contents only takes into account the content added through `addH1` ... `addH6` functions.

## Getting Started
After installation from CocoaPods, import the module (`import SimplePDFSwift`). A typical usage would look like:

```swift
import SimplePDFSwift

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

If you don't want a table of contents to be generated, instead of `writePDFWithTableOfContents`, you can call `writePDFWithoutTableOfContents()`.

### Adding Headers/Footers

There are two types of Headers/Footers.

1. **Text** This is added using `HeaderFooterText` instance, any new line characters result in multiline header (or footer). This can, for example, be the name of the author and document creation date, or it can be the page number e.g. "Page 1 of 12" or any other text.

2. **Image:** This is added using `HeaderFooterImage` instance and can only be a single image (e.g. an icon or logo).

**Alignment:** Header/Footer can have _Left_, _Center_ or _Right_ alignment, It will be added to the corresponding location on top/bottom of the page.

p**Page Number & Pages Count:** In a text header/footer, occurrences of `SimplePDF.pageNumberPlaceholder` are replaced with the current page number and occurrences of `SimplePDF.pagesCountPlaceholder` are replaced with pages-count.

The `pageRange` attribute controls which pages the header/footer appears on. `pageRange` is an `NSRange` instance, `pageRange.location` specifies zero based page index where the header/footer would first appear. `pageRange.length` specifies how many pages it would appear on (starting at `pageRange.location`).

Here's how a multiline header (or footer) could be added (in this case it is a header on the left and first appears on the second page):

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
// location of pageRange is 1, so it skips page 0 i.e. the first page and appears on second page
let header = SimplePDF.HeaderFooterText(type: .Header, pageRange: NSMakeRange(1, Int.max), attributedString: leftHeaderAttrString)
pdf.headerFooterTexts.append(header)
```

Here's how a logo could be added

```swift
// add a logo to the header, on the right
let logoPath = NSBundle.mainBundle().pathForResource("Demo", ofType: "png")
// location of pageRange is 1, so it skips page 0 i.e. the first page
// NOTE: we can specify either the image (UIImage instance) or its path
let rightLogo = SimplePDF.HeaderFooterImage(type: .Header, pageRange: NSMakeRange(1, Int.max),
    imagePath: logoPath!, image:nil, imageHeight: 35, alignment: .Right)
pdf.headerFooterImages.append(rightLogo)
```

And here's how page number with pages-count could be added

```swift
// add page numbers to the footer (center aligned)
let centerAlignment = NSMutableParagraphStyle()
centerAlignment.alignment = .Center
let footerString = NSMutableAttributedString(string: "\(SimplePDF.pageNumberPlaceholder) of \(SimplePDF.pagesCountPlaceholder)")
footerString.addAttribute(NSParagraphStyleAttributeName, value: centerAlignment, range: NSMakeRange(0, footerString.length))
// location of pageRange is 1, so it skips page 0 i.e. the first page
let footer = SimplePDF.HeaderFooterText(type: .Footer, pageRange: NSMakeRange(1, Int.max), attributedString: footerString)
pdf.headerFooterTexts.append(footer)
```

### Adding a View
You can call `addView(view)` to render UIView instances to a PDF page. The passed view will be rendered new PDF page. This is mostly useful to design cover pages. A view is always added to its own page. It starts a new page if required, and any content added after it appears on the next page.

Here's how you can design a cover page with a UIView (or a subclass)

1. Create a nib with the same dimensions as PDF page (e.g. A4 page is 595x842, you can lookup other dimensions in `PageSize` enum).
2. Optional: If you want the labels to appear as text (instead of bitmaps) in the PDF, all the labels in the view should have their class set to `SimplePDFLabel` (or a subclass of it).
3. Load the view from the nib and add it to pdf

```swift
let coverPage = NSBundle.mainBundle().loadNibNamed("PDFCoverPage", owner: self, options: nil).first as PDFCoverPage
pdf.addView(coverPage)
```

**Note:** Please note that if you use the above method to render a view to PDF, AutoLayout will **not** be run on it, If your view doesn't rely on AutoLayout, you don't need to worry about anything. However, if your view uses AutoLayout to correctly position elements, you **have to** add it to the active view hierarchy. You can add to the view hierarchy off-screen, then call `pdf.addView(view)` to render it to PDF. But now the view would render as _bitmap_. This means any labels will not be selectable as text and they would lose quality (being bitmaps) if you zoom in.

### Customizing Heading and Body Text Formatting
To customize the formatting used in `addH1` ... `addH6` and `addBodyText` functions, you need to:

1. Subclass `DefaultTextFormatter` and override appropriate methods
2. Pass instance of your custom subclass to `SimplePDF`'s `init`.

SimplePDF will now use your subclass instead of `DefaultTextFormatter` to format headings and body text.

### Other Tasks
* You can add attributed strings with `addAttributedString(attrString)`. Note, however, that these strings will not appear in table of contents (no matter how big the rendered text is).
* You can add text to multiple columns with `addAttributedStringsToColumns(columnWidths: [CGFloat], strings: [NSAttributedString])`. This can also be used to create borderless tables. Passing empty string keeps corresponding column empty.
* `addImages(imagePaths:[String], imageCaptions: [String], imagesPerRow:Int = 3)` adds images to pdf. It resizes the images uniformly to fit `imagesPerRow` images in available page width. Passing nil for image (and empty string for caption) keeps corresponding column empty.
* `addImagesRow(imagePaths: [String], imageCaptions: [NSAttributedString], columnWidths: [CGFloat])` adds a single row of images using column widths specified. Passing nil for image (and empty string for caption) keeps corresponding column empty.

## Authors

Muhammad Ishaq (ishaq@ishaq.pk), Martin Stemmle (hi@martn.st)


## License

SimplePDF is available under the MIT license. See the LICENSE file for more info.
