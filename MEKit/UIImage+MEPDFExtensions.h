//
//  UIImage+MEPDFExtensions.h
//  MEKit
//
//  Created by William Towe on 10/2/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

/**
 Mask that describes the cache options used when storing an image generated from a PDF.
 
 - `MEPDFExtensionsCacheOptionsNone`, images are never cached
 - `MEPDFExtensionsCacheOptionsFile`, images are cached on disk
 - `MEPDFExtensionsCacheOptionsMemory`, images are cached in memory
 - `MEPDFExtensionsCacheOptionsAll`, images are cached on disk and in memory
 */
typedef NS_OPTIONS(NSInteger, MEPDFExtensionsCacheOptions) {
    MEPDFExtensionsCacheOptionsNone = 0,
    MEPDFExtensionsCacheOptionsFile = 1 << 0,
    MEPDFExtensionsCacheOptionsMemory = 1 << 1,
    MEPDFExtensionsCacheOptionsAll = MEPDFExtensionsCacheOptionsFile | MEPDFExtensionsCacheOptionsMemory
};

@interface UIImage (MEPDFExtensions)

/**
 Returns the current image caching options.
 */
+ (MEPDFExtensionsCacheOptions)ME_defaultPDFExtensionsCacheOptions;
/**
 Sets the current image caching options.
 
 @see MEPDFExtensionsCacheOptions
 */
+ (void)setME_defaultPDFExtensionsCacheOptions:(MEPDFExtensionsCacheOptions)cacheOptions;

/**
 Calls `ME_imageWithPDFNamed:inBundle:size:`, passing _pdfName_, `nil`, and _size_ respectively.
 
 @param pdfName The name of the PDF file, optionally including the file extension
 @param size The desired size of the generated image. The image will be scaled to fit _size_ while maintaining its aspect ratio
 @return The resulting image
 @exception NSException Thrown if _pdfName_ is nil or _size_ is equal to `CGSizeZero`
 */
+ (UIImage *)ME_imageWithPDFNamed:(NSString *)pdfName size:(CGSize)size;
/**
 Creates an image from the PDF named _pdfName_ from _bundle_ scaled to fit _size_. Optionally caches the image based on the current cache options.
 
 @param pdfName The name of the PDF file, optionally including the file extension
 @param bundle The bundle which contains the file named _pdfName_. If nil, defaults to `[NSBundle mainBundle]`
 @param size The desired size of the generated image. The image will be scaled to fit _size_ while maintaining its aspect ratio
 @return The resulting image
 @exception NSException Thrown if _pdfName_ is nil or _size_ is equal to `CGSizeZero`
 */
+ (UIImage *)ME_imageWithPDFNamed:(NSString *)pdfName inBundle:(NSBundle *)bundle size:(CGSize)size;

@end
