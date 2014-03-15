//
//  MERootViewController.m
//  MEKit
//
//  Created by William Towe on 3/15/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MERootViewController.h"
#import <MEKit/MEKit.h>

@interface MERootViewController ()
@property (strong,nonatomic) MEGradientView *gradientView;
@end

@implementation MERootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setGradientView:[[MEGradientView alloc] initWithFrame:CGRectZero]];
    [self.gradientView setColors:@[[UIColor ME_colorWithHexadecimalString:@"abcdef"],[UIColor ME_colorWithHexadecimalString:@"bd1b2a"]]];
    [self.view addSubview:self.gradientView];
}
- (void)viewDidLayoutSubviews {
    [self.gradientView setFrame:self.view.bounds];
}

@end
