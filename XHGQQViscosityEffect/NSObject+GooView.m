//
//  NSObject+GooView.m
//  06-QQ粘性效果
//
//  Created by yz on 15/6/23.
//  Copyright (c) 2015年 yz. All rights reserved.
//

#import "NSObject+GooView.h"

@implementation NSObject (GooView)

// 获取两个圆之间的距离
- (CGFloat)centerDistanceWithBigCenter:(CGPoint)bigCenter smallCenter:(CGPoint)smallCenter
{
    // 获取x轴偏移量
    CGFloat offsetX =  smallCenter.x - bigCenter.x;
    
    // 获取y轴偏移量
    CGFloat offsetY =  smallCenter.y - bigCenter.y;
    
    return sqrtf(offsetX * offsetX + offsetY * offsetY);
}

// 描述形变路径
- (UIBezierPath *)pathWithBigCenter:(CGPoint)bigCenter bigRadius:(CGFloat)bigRadius smallCenter:(CGPoint)smallCenter smallRadius:(CGFloat)smallRadius
{
    
    // 获取小圆x1和y1
    CGFloat x1 = smallCenter.x;
    CGFloat y1 = smallCenter.y;
    
    // 获取小圆x2和y2
    CGFloat x2 = bigCenter.x;
    CGFloat y2 = bigCenter.y;
    
    // 获取圆心距离
    CGFloat d = [self centerDistanceWithBigCenter:bigCenter smallCenter:smallCenter];
    
    // sinθ
    CGFloat sinθ = (x2 - x1) / d;
    
    // cosθ
    CGFloat cosθ = (y2 - y1) / d;
    
    
    CGFloat r1 = smallRadius ;
    
    CGFloat r2 = bigRadius;
    
    // A点
    CGPoint pointA = CGPointMake(x1 - r1 * cosθ, y1 + r1 * sinθ);
    // B点
    CGPoint pointB = CGPointMake(x1 + r1 * cosθ, y1 - r1 * sinθ);
    // C点
    CGPoint pointC = CGPointMake(x2 + r2 * cosθ, y2 - r2 * sinθ);
    // D点
    CGPoint pointD = CGPointMake(x2 - r2 * cosθ, y2 + r2 * sinθ);
    
    // 控制点
    // O点
    CGPoint pointO = CGPointMake(pointA.x + d * 0.5 * sinθ, pointA.y + d * 0.5 * cosθ);
    // P点
    CGPoint pointP = CGPointMake(pointB.x + d * 0.5 * sinθ, pointB.y + d * 0.5 * cosθ);
    
    
    // 描述路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:pointA];
    
    [path addLineToPoint:pointB];
    
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    
    [path addLineToPoint:pointD];
    
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    
    return path;
}


@end
