//
//  ViewController.m
//  CoreDataHotel
//
//  Created by Christina Lee on 4/24/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import "ViewController.h"
#import "AutoLayout.h"
#import "HotelsViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupLayout];
}

-(void)setupLayout{
    UIButton *browseButton = [self createButtonWithTitle:@"Browse"];
    UIButton *bookButton = [self createButtonWithTitle:@"Book"];
    UIButton *lookupButton = [self createButtonWithTitle:@"Lookup"];
    
    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat statusBarHeight = 20.0;
    CGFloat topMargin = navBarHeight + statusBarHeight;
    CGFloat windowHeight = self.view.frame.size.height;
    CGFloat buttonHeight = ((windowHeight - topMargin) / 3);
    
    NSDictionary *viewDictionary = @{@"browseButton": browseButton, @"bookButton": bookButton, @"lookupButton": lookupButton};
    
    NSDictionary *metricsDictionary = @{@"topMargin": [NSNumber numberWithFloat:topMargin], @"buttonHeight": [NSNumber numberWithFloat:buttonHeight]};
    
    NSString *visualFormatString = @"V:|-topMargin-[browseButton(==buttonHeight)][bookButton(==browseButton)][lookupButton(==browseButton)]|";
    
    [AutoLayout constraintsWithVFLForViewDictionary:viewDictionary forMetricsDictionary:metricsDictionary withOptions:0 withVisualFormat:visualFormatString];
    
    browseButton.backgroundColor = [UIColor blueColor];
    [AutoLayout leadingConstraintFrom:browseButton toView:self.view];
    [AutoLayout trailingConstraintFrom:browseButton toView:self.view];

    [browseButton addTarget:self action:@selector(browseButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    
    bookButton.backgroundColor = [UIColor redColor];
    [AutoLayout leadingConstraintFrom:bookButton toView:self.view];
    [AutoLayout trailingConstraintFrom:bookButton toView:self.view];

    [bookButton addTarget:self action:@selector(bookButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    
    lookupButton.backgroundColor = [UIColor greenColor];
    [AutoLayout leadingConstraintFrom:lookupButton toView:self.view];
    [AutoLayout trailingConstraintFrom:lookupButton toView:self.view];

    [lookupButton addTarget:self action:@selector(lookupButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)browseButtonSelected{
    HotelsViewController *hotelVC = [[HotelsViewController alloc]init];
    [self.navigationController pushViewController:hotelVC animated:YES];
    
}

-(void)bookButtonSelected{
    
}

-(void)lookupButtonSelected{
    
}

-(UIButton *)createButtonWithTitle:(NSString *)title {
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:button];
    
    return button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
