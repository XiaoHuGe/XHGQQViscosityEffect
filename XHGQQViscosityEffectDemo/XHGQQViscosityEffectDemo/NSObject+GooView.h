//
//  NSObject+GooView.h
//  06-QQ粘性效果
//
//  Created by yz on 15/6/23.
//  Copyright (c) 2015年 yz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (GooView)

- (CGFloat)centerDistanceWithBigCenter:(CGPoint)bigCenter smallCenter:(CGPoint)smallCenter;

// 描述形变路径
- (UIBezierPath *)pathWithBigCenter:(CGPoint)bigCenter bigRadius:(CGFloat)bigRadius smallCenter:(CGPoint)smallCenter smallRadius:(CGFloat)smallRadius;

@end
