//
//  OPWall.h
//  APIHomework1
//
//  Created by Oleg on 24.01.2018.
//  Copyright © 2018  Oleg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface OPWall : NSObject

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSURL* imageURL;
@property (assign, nonatomic) double unixTime;
@property (assign, nonatomic) CGFloat photoHeight;
@property (assign, nonatomic) CGFloat photoWidth;
@property (strong, nonatomic) NSArray* arrayOfURL;

- (instancetype) initWithServerResponse:(NSDictionary*) responseObject;

@end
