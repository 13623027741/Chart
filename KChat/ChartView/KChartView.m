//
//  KChatView.m
//  KChat
//
//  Created by Mac on 2017/11/20.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "KChartView.h"

#define LeftWidth 40
#define Space 30
#define SideSpace 20
#define TitleFontSize 12


#define AnimationStartKey @"animation"

@interface KChartView()<CAAnimationDelegate>
// 渐变的颜色
@property(nullable, strong)NSArray *colors;
//渐变颜色的分割点
@property(nonatomic,strong)NSArray *locations;
///背景线颜色
@property (nonatomic, strong) UIColor *backgroundLineColor;
//图表背景渐变方向
@property(nonatomic,assign)kGradientType kBGType;
//设置图表显示方向
@property(nonatomic,assign)kChartDirection chartDirection;
//设置x轴单位
@property(nonatomic,copy)NSString* xUnit;
//设置y轴单位
@property(nonatomic,copy)NSString* yUnit;
//设置Y轴显示值
@property(nonatomic,strong)NSArray* yValues;
//设置X轴显示值
@property(nonatomic,strong)NSArray* xValues;
//设置文本颜色
@property(nonatomic,strong)UIColor* textColor;
//设置柱子颜色
@property(nonatomic,strong)UIColor* barColor;
//设置标注颜色
@property(nonatomic,strong)UIColor* titleColor;

//渐变图层
@property(nonatomic,strong)CAGradientLayer* gradientLayer;

@end

@implementation KChartView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

+(instancetype)barWithFrame:(CGRect)frame chatDirectionType:(kChartDirection)chatType{
    KChartView* chatView = [[KChartView alloc] initWithFrame:frame];
    chatView.chartDirection = chatType;
    return chatView;
}

-(instancetype)setBackgroundColors:(NSArray *)colos backgroundType:(kGradientType)backgroundType locations:(NSArray *)locations backgroundLineColor:(UIColor *)lineColor{
    _colors = colos;
    _locations = locations;
    _backgroundLineColor = lineColor;
    _kBGType = backgroundType;
    _backgroundLineColor = lineColor;
    [self drawBackgroundLayer];
    return self;
}

-(instancetype)setYvalues:(NSArray*)yValues xValues:(NSArray*)xValues xUnit:(NSString*)xUnit yUnit:(NSString*)yUnit textColor:(UIColor *)textColor barColor:(UIColor *)barColor titleColor:(UIColor *)titleColor{
    _yValues = yValues;
    _xValues = xValues;
    _xUnit = xUnit;
    _yUnit = yUnit;
    _textColor = textColor;
    _barColor = barColor;
    _titleColor = titleColor;
    switch (_chartDirection) {
        case kChartDirectionHorizontal:
            [self drawChartWithHorizontal];
            break;
        case kChartDirectionVertical:
            [self drawChartWithVertical];
            break;
    }
    
    return self;
}
//绘制背景图
-(void)drawBackgroundLayer{
    
    self.gradientLayer.frame = self.bounds;
    _gradientLayer.locations = _locations;
    _gradientLayer.colors = _colors;
    switch (_kBGType) {
        case kGradientTypebothway: //双向
            _gradientLayer.startPoint = CGPointMake(0, 0);
            _gradientLayer.endPoint = CGPointMake(1, 1);
            break;
        case kGradientTypeVertical://纵向
            _gradientLayer.startPoint = CGPointMake(0, 0);
            _gradientLayer.endPoint = CGPointMake(0, 1);
            break;
        case kGradientTypeHorizontal://横向
            _gradientLayer.startPoint = CGPointMake(0, 0);
            _gradientLayer.endPoint = CGPointMake(1, 0);
            break;
    }
    [self.layer addSublayer:_gradientLayer];
}

//绘制横向图表
-(void)drawChartWithHorizontal{
    
    [self drawLine];
    CGFloat topWidth = SideSpace,bottomWidth = SideSpace;
    CGFloat Width = self.bounds.size.width - LeftWidth;
    CGFloat height = self.bounds.size.height - topWidth - bottomWidth;
    CAShapeLayer* linesLayer = [CAShapeLayer layer];
    linesLayer.frame = CGRectMake(LeftWidth, topWidth,Width, height);
    linesLayer.fillColor = [UIColor clearColor].CGColor;
    linesLayer.strokeColor = _backgroundLineColor.CGColor;
    linesLayer.lineWidth = 1.f;
    
    //绘制参照线
    UIBezierPath* linePath = [UIBezierPath bezierPath];
    for (NSInteger i = 1; i < _yValues.count; i++) {
        [linePath moveToPoint:CGPointMake(((Width / _yValues.count) * i), 0)];
        [linePath addLineToPoint:CGPointMake( (Width / _yValues.count) * i,height)];
        
        NSLog(@"x轴---%g--",(Width / _yValues.count) * i);
    }
    linesLayer.path = linePath.CGPath;
    [self.layer addSublayer:linesLayer];
    
    //绘制Y轴title
    for (NSInteger i = 0; i < _yValues.count; i++) {
        CGFloat labX = topWidth + (Width / _yValues.count) * i;
        CGFloat labWidth = SideSpace;
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(labX + labWidth / 4, height + labWidth , labWidth + labWidth / 2, labWidth)];
        label.text = _yValues[i];
        label.textColor = _titleColor;
        label.font = [UIFont systemFontOfSize:TitleFontSize];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }

    //绘制X轴title
    for (NSInteger i = 0; i < _xValues.count; i++) {
        CGFloat labX = LeftWidth + height /_xValues.count * (i + 1);
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, labX - LeftWidth / 2 - Space, LeftWidth, LeftWidth / 2)];
        label.text = _xValues[i];
        label.textColor = _titleColor;
        label.font = [UIFont systemFontOfSize:TitleFontSize];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }

    for (NSInteger i =  0; i < _xValues.count; i++) {
        
        CAShapeLayer* barLayer = [CAShapeLayer layer];
        barLayer.fillColor = [UIColor clearColor].CGColor;
        barLayer.strokeColor = _barColor.CGColor;
        barLayer.frame = CGRectMake(LeftWidth, topWidth ,Width, height);
        barLayer.lineWidth = SideSpace;
        
        UIBezierPath* barPath = [UIBezierPath bezierPath];
        
        CGFloat barX = LeftWidth + height /_xValues.count * (i + 1);
        CGFloat barHeight = ([_xValues[i] floatValue] / 100) * (Width * (_yValues.count - 1) / _yValues.count);
        
        NSLog(@"----%g---",barHeight);
        
        [barPath moveToPoint:CGPointMake(0,barX - LeftWidth / 2 - Space - SideSpace / 2)];
        [barPath addLineToPoint:CGPointMake(barHeight,barX - LeftWidth / 2 - Space - SideSpace / 2)];
        
        barLayer.path = barPath.CGPath;
        [self.layer addSublayer:barLayer];
        
        CABasicAnimation* basicAnimation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
        basicAnimation.fromValue = @0;
        basicAnimation.toValue = @1;
        basicAnimation.duration = 1;
        basicAnimation.delegate = self;
        [barLayer addAnimation:basicAnimation forKey:AnimationStartKey];
    }
    
}
//绘制纵向图表
-(void)drawChartWithVertical{
    
    [self drawLine];
    CGFloat topWidth = SideSpace,bottomWidth = SideSpace;
    CGFloat Width = self.bounds.size.width - LeftWidth;
    CGFloat height = self.bounds.size.height - topWidth - bottomWidth;
    CAShapeLayer* linesLayer = [CAShapeLayer layer];
    linesLayer.frame = CGRectMake(LeftWidth, topWidth,Width, height);
    linesLayer.fillColor = [UIColor clearColor].CGColor;
    linesLayer.strokeColor = _backgroundLineColor.CGColor;
    linesLayer.lineWidth = 1.f;
    
    //绘制参照线
    UIBezierPath* linePath = [UIBezierPath bezierPath];
    for (NSInteger i = 1; i < _yValues.count; i++) {
        [linePath moveToPoint:CGPointMake(0, ((height / _yValues.count)) * i)];
        [linePath addLineToPoint:CGPointMake(Width, (height / _yValues.count) * i)];
        
        NSLog(@"y轴---%g--",(height / _yValues.count) * i);
    }
    linesLayer.path = linePath.CGPath;
    [self.layer addSublayer:linesLayer];
    
    //绘制Y轴title
    for (NSInteger i = 0; i < _yValues.count; i++) {
        CGFloat labY = topWidth + (height / _yValues.count) * (_yValues.count - i);
        CGFloat labWidth = SideSpace;
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(labWidth - labWidth / 2, labY - labWidth / 2, labWidth + labWidth / 2, labWidth)];
        label.text = _yValues[i];
        label.textColor = _titleColor;
        label.font = [UIFont systemFontOfSize:TitleFontSize];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    
    //绘制X轴title
    for (NSInteger i = 0; i < _xValues.count; i++) {
        CGFloat labX = LeftWidth + Width /_xValues.count * (i + 1);
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(labX - LeftWidth / 2 - Space, topWidth + height, LeftWidth, LeftWidth / 2)];
        label.text = _xValues[i];
        label.textColor = _titleColor;
        label.font = [UIFont systemFontOfSize:TitleFontSize];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    
    for (NSInteger i =  0; i < _xValues.count; i++) {
        
        CAShapeLayer* barLayer = [CAShapeLayer layer];
        barLayer.fillColor = [UIColor clearColor].CGColor;
        barLayer.strokeColor = _barColor.CGColor;
        barLayer.frame = CGRectMake(LeftWidth, topWidth ,Width, height);
        barLayer.lineWidth = SideSpace;
        
        UIBezierPath* barPath = [UIBezierPath bezierPath];
        
        CGFloat barX = LeftWidth + Width /_xValues.count * (i + 1);
        CGFloat barHeight = ( 1 - [_xValues[i] floatValue] / 100 ) * (height * (_yValues.count - 1) / _yValues.count) + LeftWidth + 3;
        
        NSLog(@"----%g---",barHeight);
        
        [barPath moveToPoint:CGPointMake(barX - LeftWidth - Space / 2 - Space / 2,height)];
        [barPath addLineToPoint:CGPointMake(barX -LeftWidth - Space / 2 - Space / 2, barHeight)];
        
        barLayer.path = barPath.CGPath;
        [self.layer addSublayer:barLayer];
        
        CABasicAnimation* basicAnimation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
        basicAnimation.fromValue = @0;
        basicAnimation.toValue = @1;
        basicAnimation.duration = 1;
        basicAnimation.delegate = self;
        [barLayer addAnimation:basicAnimation forKey:AnimationStartKey];
    }
    
    
}

//绘制X/Y轴线
-(void)drawLine{
    
    CAShapeLayer* lineLayer = [CAShapeLayer layer];
    lineLayer.frame = self.bounds;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.strokeColor = _backgroundLineColor.CGColor;
    lineLayer.lineWidth = 1.f;
    
    CGFloat topWidth = SideSpace;
    CGFloat bottomWidth = SideSpace;
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;
    UIBezierPath* linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(LeftWidth, topWidth)];
    [linePath addLineToPoint:CGPointMake(LeftWidth, height - bottomWidth)];
    [linePath addLineToPoint:CGPointMake(width, height - bottomWidth)];
    lineLayer.path = linePath.CGPath;
    [self.layer addSublayer:lineLayer];
}


//懒加载
-(CAGradientLayer *)gradientLayer{
    
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
    }
    return _gradientLayer;
}

#pragma mark - 动画代理
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.layer removeAnimationForKey:AnimationStartKey];
}

@end
