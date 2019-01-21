//
//  OPFriend.m
//  APIHomework1
//
//  Created by  Oleg on 10.01.18.
//  Copyright © 2018  Oleg. All rights reserved.
//

#import "OPFriend.h"

@implementation OPFriend

// This method is initializing OPFriend class object and getting data from server

-(instancetype)initWithServerResponse:(NSDictionary*)request{
    self=[super init];
    self.firstName=[request objectForKey:@"first_name"];
    self.lastName=[request objectForKey:@"last_name"];
    self.statusString=[request objectForKey:@"status"];
    self.bdate=[request objectForKey:@"bdate"];
    
    NSString* urlString=[request objectForKey:@"photo_max_orig"];
    self.myImageURL=[NSURL URLWithString:urlString];
    self.unixTime = [[[request objectForKey:@"last_seen"] objectForKey:@"time"] doubleValue];
    self.platform = [[[request objectForKey:@"last_seen"] objectForKey:@"platform"]integerValue];


    
    return self;
}

@end
