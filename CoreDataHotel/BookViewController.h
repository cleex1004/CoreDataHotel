//
//  BookViewController.h
//  CoreDataHotel
//
//  Created by Christina Lee on 4/25/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"
#import <CoreData/CoreData.h>

@interface BookViewController : UIViewController

@property(strong, nonatomic) Room *room;
@property(strong, nonatomic) NSDate *startDate;
@property(strong, nonatomic) NSDate *endDate;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@end
