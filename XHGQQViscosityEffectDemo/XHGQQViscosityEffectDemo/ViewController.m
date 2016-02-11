//
//  ViewController.m
//  XHGQQViscosityEffectDemo
//
//  Created by xiaohuge on 16/2/11.
//  Copyright © 2016年 xiaohuge. All rights reserved.
//

#import "ViewController.h"
#import "ShitView.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet ShitView *badgeView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _badgeView.layer.cornerRadius = 10;
    
    [_badgeView setTitle:@"10" forState:UIControlStateNormal];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
