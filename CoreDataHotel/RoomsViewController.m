//
//  RoomsViewController.m
//  CoreDataHotel
//
//  Created by Christina Lee on 4/24/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import "RoomsViewController.h"
#import "AppDelegate.h"
#import "AutoLayout.h"
#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"
#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"

@interface RoomsViewController () <UITableViewDataSource>

@property(strong, nonatomic) NSArray *allRooms;
@property(strong, nonatomic) UITableView *tableView;

@end

@implementation RoomsViewController

-(void)loadView{
    [super loadView];
    [self setupLayout];
}

-(void)setupLayout{
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [AutoLayout fullScreenConstraintsWithVFLForView:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.allRooms = [[self.hotel rooms] allObjects];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allRooms.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Room *currentRoom = self.allRooms[indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%d", currentRoom.number];
    
    return cell;
}


@end
