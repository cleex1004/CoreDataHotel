//
//  HotelService.m
//  CoreDataHotel
//
//  Created by Christina Lee on 4/28/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//
@import Crashlytics;
#import "HotelService.h"

@implementation HotelService


-(Reservation *)makeReservationFrom:(NSDate *)startDate to:(NSDate *)endDate forHotel:(Hotel *)hotel andRoom:(Room *)room forFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    
    Reservation *newReservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:context];
    newReservation.startDate = startDate;
    newReservation.endDate = endDate;
    newReservation.room = room;
    room.reservation = [room.reservation setByAddingObject:newReservation];
    
    newReservation.guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:context];
    newReservation.guest.firstName = firstName;
    newReservation.guest.lastName = lastName;
    newReservation.guest.email = email;
    
    
    NSError *saveError;
    [context save:&saveError];
    
    if (saveError) {
        NSLog(@"There was an error saving to Core Data");
        
        NSDictionary *attributesDictionary = @{@"Save Error" : saveError.localizedDescription};
        
        [Answers logCustomEventWithName:@"Save Reservation Error" customAttributes:attributesDictionary];
        
    } else {
        NSLog(@"Sucessfully saved to Core Data");
        [Answers logCustomEventWithName:@"Saved New Reservation" customAttributes:nil];
        
    }
    
    NSLog(@"You have saved a new guest!!!!");
    return newReservation;
}

-(NSArray *)getAvailableRoomsFrom:(NSDate *)startDate to:(NSDate *)endDate{
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

    NSError *availableError;
    
    self.availableRooms = [appDelegate.persistentContainer.viewContext executeFetchRequest:roomRequest error:&availableError];
    
    return self.availableRooms;
}

@end


