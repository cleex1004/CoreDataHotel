//
//  AvailabilityViewController.m
//  CoreDataHotel
//
//  Created by Christina Lee on 4/25/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import "AvailabilityViewController.h"
#import "AutoLayout.h"
#import "AppDelegate.h"
#import "Reservation+CoreDataClass.h"
#import "Reservation+CoreDataProperties.h"
#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"
#import "BookViewController.h"
#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"
#import "HotelService.h"

@interface AvailabilityViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSFetchedResultsController *availableRooms;


@end

@implementation AvailabilityViewController

-(NSFetchedResultsController *)availableRooms{
    if (!_availableRooms) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        request.predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@", self.endDate, self.startDate];
        
        NSError *roomError;
        NSArray *results = [appDelegate.persistentContainer.viewContext executeFetchRequest:request error:&roomError];
        
        NSMutableArray *unavailableRooms = [[NSMutableArray alloc]init];
        for (Reservation *reservation in results) {
            [unavailableRooms addObject:reservation.room];
        }
        
        NSFetchRequest *roomRequest = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
        roomRequest.predicate = [NSPredicate predicateWithFormat:@"NOT self IN %@", unavailableRooms];
        
        NSSortDescriptor *roomSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"hotel.name" ascending:YES];
        NSSortDescriptor *roomNumberSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
        
        roomRequest.sortDescriptors = @[roomSortDescriptor, roomNumberSortDescriptor];
        
        NSError *availableRoomError;
        
        _availableRooms = [[NSFetchedResultsController alloc]initWithFetchRequest:roomRequest managedObjectContext:appDelegate.persistentContainer.viewContext sectionNameKeyPath:@"hotel.name" cacheName:nil];
        
        [_availableRooms performFetch:&availableRoomError];
//        _availableRooms = [appDelegate.persistentContainer.viewContext executeFetchRequest:roomRequest error:&availableRoomError];
    }
    
    return _availableRooms;
}

-(void)loadView{
    [super loadView];
    [self setupTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSSortDescriptor *numberDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
//    NSArray *descriptors = [NSArray arrayWithObject:numberDescriptor];
//    self.availableRooms = [self.availableRooms sortedArrayUsingDescriptors:descriptors];
}

-(void)setupTableView{
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [AutoLayout fullScreenConstraintsWithVFLForView:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.availableRooms sections]objectAtIndex:section];
    
    return sectionInfo.numberOfObjects;
    
//    return self.availableRooms.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Room *currentRoom = [self.availableRooms objectAtIndexPath:indexPath];
//    Room *currentRoom = self.availableRooms[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Room: %i (%i beds, $%f per night)", currentRoom.number, currentRoom.beds, currentRoom.cost];
//    cell.textLabel.text = [NSString stringWithFormat:@"%i", currentRoom.number];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BookViewController *bookVC = [[BookViewController alloc]init];
    Room *room = [self.availableRooms objectAtIndexPath:indexPath];
//    bookVC.room = self.availableRooms[indexPath.row];
    bookVC.room = room;
    bookVC.startDate = self.startDate;
    bookVC.endDate = self.endDate;
    [self.navigationController pushViewController:bookVC animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.availableRooms.sections.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.availableRooms.sections objectAtIndex:section];
    
    return sectionInfo.name;
}


@end
