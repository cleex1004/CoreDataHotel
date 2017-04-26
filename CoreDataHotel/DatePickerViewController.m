//
//  DatePickerViewController.m
//  CoreDataHotel
//
//  Created by Christina Lee on 4/25/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import "DatePickerViewController.h"
#import "AvailabilityViewController.h"
#import "AutoLayout.h"

@interface DatePickerViewController ()

@property(strong, nonatomic) UILabel *startDateLabel;
@property(strong, nonatomic) UILabel *endDateLabel;
@property(strong, nonatomic) UIDatePicker *startDate;
@property(strong, nonatomic) UIDatePicker *endDate;

@end

@implementation DatePickerViewController

-(void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupDatePickers];
    [self setupDoneButton];
}

-(void)setupDoneButton{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    [self.navigationItem setRightBarButtonItem:doneButton];
}

-(void)doneButtonPressed{
    NSDate *endDate = self.endDate.date;
    NSDate *startDate = self.startDate.date;
    if ([[NSDate date] timeIntervalSinceReferenceDate] > [startDate timeIntervalSinceReferenceDate]) {
        self.startDate.date = [NSDate date];
        if ([endDate timeIntervalSinceReferenceDate] < [startDate timeIntervalSinceReferenceDate]) {
            self.startDate.date = [NSDate date];
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = 1;
            NSCalendar *theCalendar = [NSCalendar currentCalendar];
            NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
            self.endDate.date = nextDate;
//            return;
        }

        return;
    }
        AvailabilityViewController *availabiltyVC = [[AvailabilityViewController alloc]init];
    availabiltyVC.endDate = endDate;
    availabiltyVC.startDate = startDate;
    [self.navigationController pushViewController:availabiltyVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setupDatePickers{
    self.startDateLabel = [[UILabel alloc]init];
    self.startDateLabel.text = @"SELECT A START DATE:";
    [self.startDateLabel setTextAlignment:NSTextAlignmentCenter];
    self.endDateLabel = [[UILabel alloc]init];
    self.endDateLabel.text = @"SELECT AN END DATE:";
    [self.endDateLabel setTextAlignment:NSTextAlignmentCenter];
    self.startDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.endDateLabel.translatesAutoresizingMaskIntoConstraints = NO;

    self.startDate = [[UIDatePicker alloc]init];
    self.startDate.datePickerMode = UIDatePickerModeDate;
    self.startDate.translatesAutoresizingMaskIntoConstraints = NO;

    self.endDate = [[UIDatePicker alloc]init];
    self.endDate.datePickerMode = UIDatePickerModeDate;
    self.endDate.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.startDateLabel];
    [self.view addSubview:self.endDateLabel];
    [self.view addSubview:self.startDate];
    [self.view addSubview:self.endDate];
    
    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat statusBarHeight = 20.0;
    CGFloat topMargin = navBarHeight + statusBarHeight;
    CGFloat windowHeight = self.view.frame.size.height;
    CGFloat labelHeight = ((windowHeight - topMargin) / 6);
    CGFloat dateHeight = ((windowHeight - topMargin) / 3);
    
    NSDictionary *viewDictionary = @{@"startDateLabel": _startDateLabel, @"startDate": _startDate, @"endDateLabel": _endDateLabel, @"endDate":_endDate};
    
    NSDictionary *metricsDictionary = @{@"topMargin": [NSNumber numberWithFloat:topMargin], @"labelHeight": [NSNumber numberWithFloat:labelHeight], @"dateHeight": [NSNumber numberWithFloat:dateHeight]};
    
    NSString *visualFormatString = @"V:|-topMargin-[startDateLabel(==labelHeight)][startDate(==dateHeight)][endDateLabel(==startDateLabel)][endDate(==startDate)]|";

    [AutoLayout constraintsWithVFLForViewDictionary:viewDictionary forMetricsDictionary:metricsDictionary withOptions:0 withVisualFormat:visualFormatString];
    [AutoLayout leadingConstraintFrom:_startDateLabel toView:self.view];
    [AutoLayout trailingConstraintFrom:_startDateLabel toView:self.view];
    [AutoLayout leadingConstraintFrom:_startDate toView:self.view];
    [AutoLayout trailingConstraintFrom:_startDate toView:self.view];
    [AutoLayout leadingConstraintFrom:_endDateLabel toView:self.view];
    [AutoLayout trailingConstraintFrom:_endDateLabel toView:self.view];
    [AutoLayout leadingConstraintFrom:_endDate toView:self.view];
    [AutoLayout trailingConstraintFrom:_endDate toView:self.view];
}

@end

//    self.endDate.frame = CGRectMake(0, 84.0, self.view.frame.size.width, 200.0);
//    self.startDate.frame = CGRectMake(0, 284.0, self.view.frame.size.width, 200.00);
