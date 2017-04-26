//
//  LookupReservationViewController.m
//  CoreDataHotel
//
//  Created by Christina Lee on 4/26/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import "LookupReservationViewController.h"
#import "AutoLayout.h"
#import "AppDelegate.h"
#import "Reservation+CoreDataProperties.h"
#import "Reservation+CoreDataClass.h"


@interface LookupReservationViewController () <UITableViewDataSource>
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSFetchedResultsController *reservations;

@end

@implementation LookupReservationViewController
-(void)loadView{
    [super loadView];
    [self setupLayoutTableView];
}

-(void)setupLayoutTableView{
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;

    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [AutoLayout fullScreenConstraintsWithVFLForView:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

-(NSFetchedResultsController *)reservations{
    if (!_reservations) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        
        NSError *reservationError;
        NSArray *results = [appDelegate.persistentContainer.viewContext executeFetchRequest:request error:&reservationError];
        
        NSMutableArray *guests = [[NSMutableArray alloc]init];
        for (Reservation *reservation in results) {
            [unavailableRooms addObject:reservation.room];
        }
        
        NSFetchRequest *roomRequest = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
        roomRequest.predicate = [NSPredicate predicateWithFormat:@"NOT self IN %@", unavailableRooms];
        
        NSSortDescriptor *roomSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"hotel.name" ascending:YES];
        NSSortDescriptor *roomNumberSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
        
        roomRequest.sortDescriptors = @[roomSortDescriptor, roomNumberSortDescriptor];
        
        NSError *bookedRoomError;
        
        _reservations = [[NSFetchedResultsController alloc]initWithFetchRequest:roomRequest managedObjectContext:appDelegate.persistentContainer.viewContext sectionNameKeyPath:@"hotel.name" cacheName:nil];
        
        [_reservations performFetch:&bookedRoomError];
    }
    
    return _reservations;
}

//-(NSFetchedResultsController *)availableRooms{
//    if (!_availableRooms) {
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//        
//        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
//        request.predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@", self.endDate, self.startDate];
//        
//        NSError *roomError;
//        NSArray *results = [appDelegate.persistentContainer.viewContext executeFetchRequest:request error:&roomError];
//        
//        NSMutableArray *unavailableRooms = [[NSMutableArray alloc]init];
//        for (Reservation *reservation in results) {
//            [unavailableRooms addObject:reservation.room];
//        }
//        
//        NSFetchRequest *roomRequest = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
//        roomRequest.predicate = [NSPredicate predicateWithFormat:@"NOT self IN %@", unavailableRooms];
//        
//        NSSortDescriptor *roomSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"hotel.name" ascending:YES];
//        NSSortDescriptor *roomNumberSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
//        
//        roomRequest.sortDescriptors = @[roomSortDescriptor, roomNumberSortDescriptor];
//        
//        NSError *availableRoomError;
//        
//        _availableRooms = [[NSFetchedResultsController alloc]initWithFetchRequest:roomRequest managedObjectContext:appDelegate.persistentContainer.viewContext sectionNameKeyPath:@"hotel.name" cacheName:nil];
//        
//        [_availableRooms performFetch:&availableRoomError];
//        //        _availableRooms = [appDelegate.persistentContainer.viewContext executeFetchRequest:roomRequest error:&availableRoomError];
//    }
//    
//    return _availableRooms;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.reservations sections]objectAtIndex:section];
    
    return sectionInfo.numberOfObjects;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Room *currentReservation = [self.reservations objectAtIndexPath:indexPath];

//    cell.textLabel.text = [NSString stringWithFormat:@"Room: %i (%i beds, $%f per night)", currentRoom.number, currentRoom.beds, currentRoom.rate];
        cell.textLabel.text = [NSString stringWithFormat:@"%i", currentReservation.firstName];
    return cell;
}


@end
