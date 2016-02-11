//
//  ShitView.m
//  06-QQ粘性效果
//
//  Created by yz on 15/6/22.
//  Copyright (c) 2015年 yz. All rights reserved.
//

#import "ShitView.h"
#import "NSObject+GooView.h"

@interface ShitView ()

@property (nonatomic, assign) CGFloat circleR2;

@property (nonatomic, assign) CGFloat circleR1;

@property (nonatomic, weak) UIView *smallCircleView;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, assign) CGPoint oriCenter;

@property (nonatomic, assign) BOOL isOverBorder;

@property (nonatomic, weak) UIImageView *gifImageV;

@end



@implementation ShitView

#define maxDistance 60

// 粘性比例 0.9
#define gooRatio 0.9

- (CAShapeLayer *)shapeLayer
{
    if (_shapeLayer == nil) {
        
        CAShapeLayer *shapeL = [CAShapeLayer layer];
        
        shapeL.fillColor = [UIColor redColor].CGColor;
        
        _shapeLayer = shapeL;
        
    }
    return _shapeLayer;
}

- (void)awakeFromNib
{
    [self setUp];
    
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}


- (UIView *)smallCircleView
{
    if (_smallCircleView == nil) {
        
        UIView *smallCircleView = [[UIView alloc] init];
        
        _smallCircleView = smallCircleView;
        
        _smallCircleView.layer.cornerRadius = _circleR1;
        _smallCircleView.hidden = YES;
        _smallCircleView.backgroundColor = [UIColor redColor];
        
        [self.superview insertSubview:smallCircleView atIndex:0];
        
    }
    
    return _smallCircleView;
}



- (void)setUp
{
    // 添加pan手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    // 添加点按手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    
    _circleR1 = self.bounds.size.width * 0.5;
    
    _circleR2 = _circleR1;
    
    _oriCenter = self.center;
    
    self.smallCircleView.center = self.center;
    
    [self setTitle:@"11" forState:UIControlStateNormal];
    
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    
    
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        // 获取圆心距离
        CGFloat d = [self centerDistanceWithBigCenter:self.center smallCenter:self.smallCircleView.center];
        
        // 判断是否超出最大圆心距离
        if (d > maxDistance) {
            [self setUpBoom];
        }else{
            [self setUpRestore];
            
        }
        
    }else if (pan.state == UIGestureRecognizerStateChanged){
        
//        [self.layer removeAllAnimations];
        
        // 获取手指偏移量
        CGPoint transP = [pan translationInView:self];
        
        // 并不会修改中心点
        //    self.transform = CGAffineTransformTranslate(self.transform, transP.x, transP.y);
        
        CGPoint center = self.center;
        
        center.x += transP.x;
        center.y += transP.y;
        
        // 设置大圆中心
        self.center = center;
        
        // 获取圆心距离
        CGFloat d = [self centerDistanceWithBigCenter:self.center smallCenter:self.smallCircleView.center];
        
        // 计算小圆半径：随机搞个比例，随着圆心距离增加，圆心半径不断减少。
        CGFloat smallRadius = _circleR2 - d / 10;
        
        self.smallCircleView.bounds = CGRectMake(0, 0, smallRadius * 2, smallRadius * 2);
        self.smallCircleView.layer.cornerRadius = smallRadius;
        
        // 超过最大圆心距离,不需要描述形变矩形
        if (d > maxDistance ) {
            
            // 超过边界
            _isOverBorder = YES;
            
            // 隐藏小圆
            self.smallCircleView.hidden = YES;
            
            // 没有弹性效果
            [self.shapeLayer removeFromSuperlayer];
            
            
        }else if(d > 0 && _isOverBorder == NO){ // 否则设置小圆圆心，并且描述形变矩形
            
            self.smallCircleView.hidden = NO;

            self.shapeLayer.path = [self pathWithBigCenter:self.center bigRadius:_circleR2 smallCenter:self.smallCircleView.center smallRadius:smallRadius].CGPath;
            
            [self.superview.layer insertSublayer:self.shapeLayer below:_smallCircleView.layer];
        }
        
        [pan setTranslation:CGPointZero inView:self];

    }

    
}


// 还原
- (void)setUpRestore
{
    [self.shapeLayer removeFromSuperlayer];
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.center = _oriCenter;
        
    } completion:^(BOOL finished) {
        _isOverBorder = NO;
        self.smallCircleView.hidden = NO;
        
    }];

}

//点按手势
- (void)tap:(UITapGestureRecognizer *)tap{
    [self setUpBoom];

}

// 爆炸效果
- (void)setUpBoom
{
    
    
    self.userInteractionEnabled = NO;
    
    // 变成气泡消失
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.frame = CGRectMake(0, 0, _circleR2 * 2, _circleR2 * 2);
    
    [self addSubview:imageView];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 1; i < 9; i++) {

        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"blast_gif.bundle/%d",i] ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"blast_gif.bundle/%d", i]];
        [arr addObject:image];
        
    }
    
    imageView.animationImages = arr;
    
    imageView.animationDuration = 1.2;
    imageView.animationRepeatCount = 1;
    [imageView startAnimating];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imageView removeFromSuperview];
        [self removeFromSuperview];
    });
}



@end
