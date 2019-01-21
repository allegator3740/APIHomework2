//
//  OPWall.m
//  APIHomework1
//
//  Created by Oleg on 24.01.2018.
//  Copyright © 2018  Oleg. All rights reserved.
//

#import "OPWall.h"

@implementation OPWall

// This method is initializing OPWall class object and getting data from server
- (instancetype) initWithServerResponse:(NSDictionary*) responseObject{
    
    self = [super init];
    if (self) {
        self.text = [responseObject objectForKey:@"text"];
        self.unixTime = [[responseObject objectForKey:@"date"] doubleValue];
        self.photoHeight = [[[[responseObject objectForKey:@"attachment"]objectForKey:@"photo"]objectForKey:@"height"] floatValue];
        self.photoWidth = [[[[responseObject objectForKey:@"attachment"]objectForKey:@"photo"]objectForKey:@"width"] floatValue];
        self.arrayOfURL=[NSArray array];
        NSArray* array = [responseObject objectForKey:@"attachments"];
        self.arrayOfURL=[self wallImagesArray:array];
    }
    return self;
}

// This method is used just for initWithServerResponse method and it's for parsing and getting image url of wall content
-(NSMutableArray*)wallImagesArray:(NSArray*)array{
    NSMutableArray* tempArray=[NSMutableArray array];
    if(array.count>0){
        for(NSDictionary* dict in array){
            NSDictionary* dictionary=[dict objectForKey:@"photo"];
            if(dictionary){
                NSString* urlString=[dictionary objectForKey:@"photo_604"];
                [tempArray addObject:urlString];
            }
        }
    }
    return tempArray;
}

@end
