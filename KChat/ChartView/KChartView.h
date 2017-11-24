//
//  KChatView.h
//  KChart
//
//  Created by Mac on 2017/11/20.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

// RGB颜色
#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

typedef NS_ENUM(NSUInteger, kGradientType) { //渐变方向
    kGradientTypeHorizontal,  //横向
    kGradientTypeVertical,    //纵向
    kGradientTypebothway,     //双向
};

typedef NS_ENUM(NSUInteger, kChartDirection) { //图表的方向
    kChartDirectionHorizontal,  //横向
    kChartDirectionVertical,    //纵向
};

@interface KChartView : UIView

//初始化
+(instancetype)barWithFrame:(CGRect)frame chatDirectionType:(kChartDirection)chatType;
/*设置背景颜色 渐变
 backgroundType 图表背景渐变方向
 colors // 渐变的颜色 CGColor 类型
 locations 渐变颜色的分割点
 lineColor 背景线颜色
 */
-(instancetype)setBackgroundColors:(NSArray*)colos backgroundType:(kGradientType)backgroundType locations:(NSArray*)locations backgroundLineColor:(UIColor*)lineColor;
/*
 */
-(instancetype)setYvalues:(NSArray*)yValues xValues:(NSArray*)xValues xUnit:(NSString*)xUnit yUnit:(NSString*)yUnit textColor:(UIColor*)textColor barColor:(UIColor*)barColor titleColor:(UIColor*)titleColor;
@end
