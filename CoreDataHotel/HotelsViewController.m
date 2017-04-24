//
//  HotelsViewController.m
//  CoreDataHotel
//
//  Created by Christina Lee on 4/24/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import "HotelsViewController.h"
#import "AppDelegate.h"
#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"
#import "AutoLayout.h"

@interface HotelsViewController () <UITableViewDataSource>

@property(strong, nonatomic) NSArray *allHotels;
@property(strong, nonatomic) UITableView *tableView;


@end

@implementation HotelsViewController

-(void)loadView{
    [super loadView];

    [self setupLayout];
    //add tableview as subview and apply constraints
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    [self allHotels];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

-(void)setupLayout{
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [AutoLayout fullScreenConstraintsWithVFLForView:self.tableView];
    //float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
//    [AutoLayout leadingConstraintFrom:_tableView toView:self.view];
//    [AutoLayout trailingConstraintFrom:_tableView toView:self.view];
//    [AutoLayout equalHeightConstraintFrom:_tableView toView:self.view withMultiplier:0.5];

    
}

-(NSArray *)allHotels{
    if (!self.allHotels) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
        NSError *fetchError;
        NSArray *hotels = [context executeFetchRequest:request error:&fetchError];
        
        if (fetchError) {
            NSLog(@"There was an error fetching hotels from Core Data!");
        }
        self.allHotels = hotels;
    }
    NSLog(@"%@", self.allHotels);
    return self.allHotels;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allHotels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Hotel *currentHotel = self.allHotels[indexPath.row];
    
    cell.textLabel.text = currentHotel.name;
    
    return cell;
}

@end
