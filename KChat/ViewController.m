//
//  ViewController.m
//  KChat
//
//  Created by Mac on 2017/11/20.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "KChartView.h"

@interface ViewController ()

@property(nonatomic,strong)KChartView* chartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    _chartView = [KChartView barWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300) chatDirectionType:kChartDirectionVertical];
    [[_chartView
      setBackgroundColors:@[(__bridge id)[UIColor orangeColor].CGColor,(__bridge id)[UIColor redColor].CGColor] backgroundType:kGradientTypebothway locations:@[@0.1,@1] backgroundLineColor:[UIColor whiteColor]]
     setYvalues:@[@"0",@"20",@"40",@"60",@"80",@"100"] xValues:@[@"12",@"35",@"60",@"80",@"100"] xUnit:@"m/s" yUnit:@"%" textColor:[UIColor orangeColor] barColor:RGBCOLOR(255 ,218 ,185) titleColor:[UIColor whiteColor]];
    [self.view addSubview:_chartView];
}

@end
