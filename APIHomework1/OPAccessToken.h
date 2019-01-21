//
//  OPAccessToken.h
//  APIHomework1
//
//  Created by Oleg on 21.01.2018.
//  Copyright © 2018  Oleg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPAccessToken : NSObject

@property (strong, nonatomic) NSString* token;

@property (strong, nonatomic) NSDate* expirationDate;

@property (strong, nonatomic) NSString* userID;

@end
