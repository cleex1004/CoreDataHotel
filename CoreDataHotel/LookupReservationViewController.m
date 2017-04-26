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
#import "Guest+CoreDataClass.h"
#import "Guest+CoreDataProperties.h"


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
        
        NSMutableArray *reservedGuests = [[NSMutableArray alloc]init];
        for (Reservation *reservation in results) {
            [reservedGuests addObject:reservation.guest];
        }
        
        NSFetchRequest *guestRequest = [NSFetchRequest fetchRequestWithEntityName:@"Guest"];
        guestRequest.predicate = [NSPredicate predicateWithFormat:@"self IN %@", reservedGuests];
        
        NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
        
        guestRequest.sortDescriptors = @[nameSortDescriptor];
        
        NSError *guestError;
        
        _reservations = [[NSFetchedResultsController alloc]initWithFetchRequest:guestRequest managedObjectContext:appDelegate.persistentContainer.viewContext sectionNameKeyPath:@"firstName" cacheName:nil];
        
        [_reservations performFetch:&guestError];
    }
    
    return _reservations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.reservations sections]objectAtIndex:section];
    
    return sectionInfo.numberOfObjects;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Guest *currentReservation = [self.reservations objectAtIndexPath:indexPath];

//    cell.textLabel.text = [NSString stringWithFormat:@"Room: %i (%i beds, $%f per night)", currentRoom.number, currentRoom.beds, currentRoom.rate];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", currentReservation.firstName];
    return cell;
}


@end
