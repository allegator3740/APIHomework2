//
//  OPStudent.m
//  APIHomework1
//
//  Created by  Oleg on 05.01.18.
//  Copyright © 2018  Oleg. All rights reserved.
//

#import "OPStudent.h"

@implementation OPStudent

-(instancetype)initWithServerResponse:(NSDictionary*)responseObject{
    
    self=[super init];
    if(self){
        self.name=[responseObject valueForKey:@"first_name"];
        self.surname=[responseObject valueForKey:@"last_name"];
        self.isOnline=[[responseObject valueForKey:@"online"]integerValue];
        NSString* urlString=[responseObject valueForKey:@"photo_100"];
        self.urlString=[NSURL URLWithString:urlString];
        self.userID=[responseObject valueForKey:@"uid"];
        self.city=[[responseObject objectForKey:@"city"]integerValue];
                   }
    return self;
}

@end
