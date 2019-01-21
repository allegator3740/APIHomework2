//
//  OPStudent.h
//  APIHomework1
//
//  Created by  Oleg on 05.01.18.
//  Copyright © 2018  Oleg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPStudent : NSObject

@property(strong, nonatomic)NSString* name;

@property(strong, nonatomic)NSString* surname;

@property(strong, nonatomic)NSURL* urlString;

@property(assign, nonatomic)BOOL isOnline;

@property (strong, nonatomic) NSString* userID;

@property (assign, nonatomic) NSInteger city;

// This method is initializing OPStudent class object and getting data from server
-(instancetype)initWithServerResponse:(NSDictionary*)responseObject;

@end
