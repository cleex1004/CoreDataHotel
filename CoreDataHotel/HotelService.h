//
//  HotelService.h
//  CoreDataHotel
//
//  Created by Christina Lee on 4/28/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Guest+CoreDataClass.h"
#import "Guest+CoreDataProperties.h"
#import "Reservation+CoreDataClass.h"
#import "Reservation+CoreDataProperties.h"
#import "AppDelegate.h"
#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"
#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"

@interface HotelService : NSObject

@property(strong, nonatomic) Room *room;
@property(strong, nonatomic) Reservation *reservation;

@property(strong, nonatomic) NSDate *startDate;
@property(strong, nonatomic) NSDate *endDate;

@property(strong, nonatomic) NSString *firstName;
@property(strong, nonatomic) NSString *lastName;
@property(strong, nonatomic) NSString *email;

@property(strong, nonatomic) NSArray *allReservations;
@property(strong, nonatomic) NSArray *allRooms;
@property(strong, nonatomic) NSArray *availableRooms;

-(Reservation *)makeReservationFrom:(NSDate *)startDate to:(NSDate *)endDate forHotel:(Hotel *)hotel andRoom:(Room *)room forFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email;

-(NSArray *)getAvailableRoomsFrom:(NSDate *)startDate to:(NSDate *)endDate;

@end
