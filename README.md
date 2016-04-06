# SimplePDF
SimplePDF is a Swift class that lets you create simple PDF documents with page numbers and table of contents. The code is a rough implementation of [Builder](https://en.wikipedia.org/wiki/Builder_pattern) design pattern. See the demo project for usage example.

### Features
Although SimplePDF can only generate simple PDF documents, It can be used in a variety of use cases. It allows you to add:

* headings (H1 - H6) and Body Text. (Formatting of these can be customized by passing a custom subclass of `DefaultTextFormatter` to the SimplePDF `init` method.)
* Images (with captions).
* Add text to multiple columns, this can also be used to create borderless tables
* Headers/Footers (with page number and pages count)
* UIView instances (You can design a UIView in a nib or in a storyboard and add it as a page to the PDF, This can be useful to add, for example, a cover page with company logo, etc.)

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

// Write PDF
// Note that the tmpPDFPath is path to a temporary file, it needs to be saved somewhere
let tmpPDFPath = pdf.writePDFWithTableOfContents()
```

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
