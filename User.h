//
//  User.h
//  MyDoctor
//
//  Created by wxhl_zy012 on 14-12-8.
//  Copyright (c) 2014年 www.716.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSNumber * drugCount;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * mother;

@end
