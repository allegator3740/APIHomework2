//
//  OPFriend.h
//  APIHomework1
//
//  Created by  Oleg on 10.01.18.
//  Copyright © 2018  Oleg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPFriend : NSObject

@property(strong, nonatomic)NSURL* myImageURL;

@property(strong, nonatomic)NSString* firstName;

@property(strong, nonatomic)NSString* lastName;

@property(assign, nonatomic)NSDate* bdate;

@property(strong, nonatomic)NSString* statusString;

@property (assign, nonatomic) double unixTime;

@property(assign, nonatomic)NSInteger platform;

-(instancetype)initWithServerResponse:(NSDictionary*)request;

@end
