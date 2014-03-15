//
//  UIColor+MEExtensions.h
//  MEFrameworks
//
//  Created by William Towe on 6/7/12.
//  Copyright (c) 2012 Maestro. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

#define MEColorW(w) [UIColor colorWithWhite:((w)/255.0) alpha:1]
#define MEColorWA(w,a) [UIColor colorWithWhite:((w)/255.0) alpha:((a)/255.0)]

#define MEColorRGB(r,g,b) [UIColor colorWithRed:((r)/255.0) green:((g)/255.0) blue:((b)/255.0) alpha:1]
#define MEColorRGBA(r,g,b,a) [UIColor colorWithRed:((r)/255.0) green:((g)/255.0) blue:((b)/255.0) alpha:((a)/255.0)]

#define MEColorHSB(h,s,b) [UIColor colorWithHue:(h) saturation:(s) brightness:(b) alpha:1]
#define MEColorHSBA(h,s,b,a) [UIColor colorWithHue:(h) saturation:(s) brightness:(b) alpha:(a)]

@interface UIColor (MEExtensions)

/**
 Returns the hexadecimal string representation of the receiver.
 
 @return The hexadecimal string representation
 */
@property (readonly,nonatomic) NSString *ME_hexadecimalString;

/**
 Returns a `UIColor` instance created from the given string.
 
 @param hexadecimalString The hexadecimal string to transform
 @return The `UIColor` instance created from _hexadecimalString_ or nil if no color could be created
 */
+ (UIColor *)ME_colorWithHexadecimalString:(NSString *)hexadecimalString;
@end
