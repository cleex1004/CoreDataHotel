//
//  DatePickerViewController.m
//  CoreDataHotel
//
//  Created by Christina Lee on 4/25/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import "DatePickerViewController.h"
#import "AvailabilityViewController.h"

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
    if ([[NSDate date] timeIntervalSinceReferenceDate] > [endDate timeIntervalSinceReferenceDate]) {
        self.endDate.date = [NSDate date];
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
    self.endDate = [[UIDatePicker alloc]init];
    self.endDate.datePickerMode = UIDatePickerModeDateAndTime;
    self.endDate.frame = CGRectMake(0, 84.0, self.view.frame.size.width, 200.0);
    [self.view addSubview:self.endDate];
    self.startDate = [[UIDatePicker alloc]init];
    self.startDate.datePickerMode = UIDatePickerModeDateAndTime;
    self.startDate.frame = CGRectMake(0, 284.0, self.view.frame.size.width, 200.00);
    [self.view addSubview:self.startDate];
}

@end
