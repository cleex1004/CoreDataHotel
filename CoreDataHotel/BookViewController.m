//
//  BookViewController.m
//  CoreDataHotel
//
//  Created by Christina Lee on 4/25/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import "BookViewController.h"
#import "AutoLayout.h"
#import "Guest+CoreDataClass.h"
#import "Guest+CoreDataProperties.h"


@interface BookViewController ()

@property(strong, nonatomic) UILabel *firstNameLabel;
@property(strong, nonatomic) UILabel *lastNameLabel;
@property(strong, nonatomic) UILabel *emailLabel;
@property(strong, nonatomic) UITextField *firstNameField;
@property(strong, nonatomic) UITextField *lastNameField;
@property(strong, nonatomic) UITextField *emailField;

@end

@implementation BookViewController
-(void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupLayout];
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setupLayout{
    self.firstNameLabel = [[UILabel alloc]init];
    self.firstNameLabel.text = @"FIRST NAME:";
    [self.firstNameLabel setTextAlignment:NSTextAlignmentCenter];
    self.lastNameLabel = [[UILabel alloc]init];
    self.lastNameLabel.text = @"LAST NAME:";
    [self.lastNameLabel setTextAlignment:NSTextAlignmentCenter];
    self.emailLabel = [[UILabel alloc]init];
    self.emailLabel.text = @"EMAIL:";
    [self.emailLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.firstNameField= [[UITextField alloc]init];
    self.lastNameField= [[UITextField alloc]init];
    self.emailField= [[UITextField alloc]init];
    
    self.firstNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.lastNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.emailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.firstNameField.translatesAutoresizingMaskIntoConstraints = NO;
    self.lastNameField.translatesAutoresizingMaskIntoConstraints = NO;
    self.emailField.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.firstNameLabel];
    [self.view addSubview:self.lastNameLabel];
    [self.view addSubview:self.emailLabel];
    [self.view addSubview:self.firstNameField];
    [self.view addSubview:self.lastNameField];
    [self.view addSubview:self.emailField];
    
    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat statusBarHeight = 20.0;
    CGFloat topMargin = navBarHeight + statusBarHeight;
    CGFloat windowHeight = self.view.frame.size.height;
    CGFloat height = ((windowHeight - topMargin) / 6);
    
    NSDictionary *viewDictionary = @{@"firstNameLabel": self.firstNameLabel, @"firstNameField": self.firstNameField, @"lastNameLabel": self.lastNameLabel, @"lastNameField": self.lastNameField, @"emailLabel": self.emailLabel, @"emailField": self.emailField};
    
    NSDictionary *metricsDictionary = @{@"topMargin": [NSNumber numberWithFloat:topMargin], @"height": [NSNumber numberWithFloat:height]};

    NSString *visualFormatString = @"V:|-topMargin-[firstNameLabel(==height)][firstNameField(==firstNameLabel)][lastNameLabel(==firstNameLabel)][lastNameField(==firstNameLabel][emailLabel(==firstNameLabel)][emailField(==firstNameLabel)]|";

    [AutoLayout constraintsWithVFLForViewDictionary:viewDictionary forMetricsDictionary:metricsDictionary withOptions:0 withVisualFormat:visualFormatString];
    
    [AutoLayout leadingConstraintFrom:self.firstNameLabel toView:self.view];
    [AutoLayout trailingConstraintFrom:self.firstNameLabel toView:self.view];
    [AutoLayout leadingConstraintFrom:self.lastNameLabel toView:self.view];
    [AutoLayout trailingConstraintFrom:self.lastNameLabel toView:self.view];
    [AutoLayout leadingConstraintFrom:self.emailLabel toView:self.view];
    [AutoLayout trailingConstraintFrom:self.emailLabel toView:self.view];
    [AutoLayout leadingConstraintFrom:self.firstNameField toView:self.view];
    [AutoLayout trailingConstraintFrom:self.firstNameField toView:self.view];
    [AutoLayout leadingConstraintFrom:self.lastNameField toView:self.view];
    [AutoLayout trailingConstraintFrom:self.lastNameField toView:self.view];
    [AutoLayout leadingConstraintFrom:self.emailField toView:self.view];
    [AutoLayout trailingConstraintFrom:self.emailField toView:self.view];
}

-(void)setupBookButton{
    UIBarButtonItem *bookButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(bookButtonPressed)];
    [self.navigationItem setRightBarButtonItem:bookButton];
}

-(void)bookButtonPressed{
    Guest *newGuest;
    newGuest.firstName = self.firstNameField.text;
    newGuest.lastName = self.lastNameField.text;
    newGuest.email = self.emailField.text;
//    AvailabilityViewController *availabiltyVC = [[AvailabilityViewController alloc]init];
//    availabiltyVC.endDate = endDate;
//    availabiltyVC.startDate = startDate;
//    [self.navigationController pushViewController:availabiltyVC animated:YES];
}

@end
