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
#import "RoomsViewController.h"
#import "Reservation+CoreDataProperties.h"
#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"


@interface LookupReservationViewController () <UITableViewDataSource, UISearchBarDelegate>
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) UISearchBar *searchBar;
@property(strong, nonatomic) NSArray *allReservations;
@property(strong, nonatomic) NSMutableArray *filteredReservations;

@end

@implementation LookupReservationViewController

BOOL isSearching;

-(void)loadView{
    [super loadView];
    [self setupLayoutView];
}

-(void)setupLayoutView{
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.searchBar = [[UISearchBar alloc]init];
    [self.view addSubview:self.searchBar];
    self.searchBar.delegate = self;
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat statusBarHeight = 20.0;
    CGFloat topMargin = navBarHeight + statusBarHeight;
    CGFloat windowHeight = self.view.frame.size.height;
    CGFloat searchHeight = 44.0;
    CGFloat tableHeight = (windowHeight - topMargin - searchHeight);
    
    NSDictionary *viewDictionary = @{@"searchBar": _searchBar, @"tableView": _tableView};

    NSDictionary *metricsDictionary = @{@"topMargin": [NSNumber numberWithFloat:topMargin], @"searchHeight": [NSNumber numberWithFloat:searchHeight], @"tableHeight": [NSNumber numberWithFloat:tableHeight]};

    NSString *visualFormatString = @"V:|-topMargin-[searchBar(==searchHeight)][tableView(==tableHeight)]|";

    [AutoLayout constraintsWithVFLForViewDictionary:viewDictionary forMetricsDictionary:metricsDictionary withOptions:0 withVisualFormat:visualFormatString];
    [AutoLayout leadingConstraintFrom:self.searchBar toView:self.view];
    [AutoLayout trailingConstraintFrom:self.searchBar toView:self.view];
    [AutoLayout leadingConstraintFrom:self.tableView toView:self.view];
    [AutoLayout trailingConstraintFrom:self.tableView toView:self.view];

}

-(NSArray *)allReservations{
    if (!_allReservations) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        
        NSError *reservationError;
        NSArray *results = [context executeFetchRequest:request error:&reservationError];
        
        NSMutableArray *reservedGuests = [[NSMutableArray alloc]init];
        for (Reservation *reservation in results) {
            [reservedGuests addObject:reservation.guest];
        }
        
        NSFetchRequest *guestRequest = [NSFetchRequest fetchRequestWithEntityName:@"Guest"];
        guestRequest.predicate = [NSPredicate predicateWithFormat:@"self IN %@", reservedGuests];
        
        NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];

        guestRequest.sortDescriptors = @[nameSortDescriptor];
        
        NSError *guestError;
        
        NSArray *allresults = [context executeFetchRequest:guestRequest error:&guestError];
        
        if (guestError) {
            NSLog(@"There was an error fetching hotels from Core Data!");
        }
        
        _allReservations = allresults;
    }
    return _allReservations;
}



- (void)viewDidLoad {
    [super viewDidLoad];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.filteredReservations.count == 0) {
        return self.allReservations.count;
    } else {
        return self.filteredReservations.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Guest *currentReservation;
    if ([self.searchBar.text  isEqualToString:@""]) {
        currentReservation = self.allReservations[indexPath.row];
    } else {
        currentReservation = self.filteredReservations[indexPath.row];
    }

//    cell.textLabel.text = [NSString stringWithFormat:@"Room: %i (%i beds, $%f per night)", currentRoom.number, currentRoom.beds, currentRoom.rate];
        cell.textLabel.text = [NSString stringWithFormat:@"Guest: %@ %@", currentReservation.firstName, currentReservation.lastName];
    return cell;
}


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    isSearching = YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    isSearching = YES;
    
    if ([searchText isEqualToString:@""]) {
        isSearching = NO;
        self.filteredReservations = nil;
    } else {
        self.filteredReservations = [[NSMutableArray alloc]init];
        self.filteredReservations = [[self.allReservations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"guest.lastName CONTAINS[c] %@ or guest.firstName CONTAINS[c] %@", searchBar.text, searchBar.text]] mutableCopy];
    }
    [self.tableView reloadData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    self.filteredReservations = nil;
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
    isSearching = NO;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text != nil) {
        self.filteredReservations = [[NSMutableArray alloc]init];
        self.filteredReservations = [[self.allReservations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"guest.lastName CONTAINS[c] %@ or guest.firstName CONTAINS[c] %@", searchBar.text, searchBar.text]] mutableCopy];
    } else {
        self.filteredReservations = nil;
    }
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
    isSearching = NO;
}

@end

//-(NSFetchedResultsController *)reservations{
//    if (!_reservations) {
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//
//        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
//
//        NSError *reservationError;
//        NSArray *results = [appDelegate.persistentContainer.viewContext executeFetchRequest:request error:&reservationError];
//
//        NSMutableArray *reservedGuests = [[NSMutableArray alloc]init];
//        for (Reservation *reservation in results) {
//            [reservedGuests addObject:reservation.guest];
//        }
//
//        NSFetchRequest *guestRequest = [NSFetchRequest fetchRequestWithEntityName:@"Guest"];
//        guestRequest.predicate = [NSPredicate predicateWithFormat:@"self IN %@", reservedGuests];
//
//        NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
//        NSSortDescriptor *hotelSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"reservation.room.hotel.name" ascending:YES];
//
//        guestRequest.sortDescriptors = @[nameSortDescriptor, hotelSortDescriptor];
//
//        NSError *guestError;
//
//        _reservations = [[NSFetchedResultsController alloc]initWithFetchRequest:guestRequest managedObjectContext:appDelegate.persistentContainer.viewContext sectionNameKeyPath:@"reservation.room.hotel.name" cacheName:nil];
//
//        [_reservations performFetch:&guestError];
//    }
//
//    return _reservations;
//}
