//
//  OPServerManager.h
//  APIHomework1
//
//  Created by  Oleg on 05.01.18.
//  Copyright © 2018  Oleg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPFriend.h"
#import "OPLoginViewController.h"
#import "OPAccessToken.h"

@interface OPServerManager : NSObject

+(OPServerManager*)sharedManager;

@property (strong, nonatomic, readonly)OPFriend* currentUser;

-(void)setCustomToken:(id)token;

- (void) authorizeUser:(void(^)(OPFriend* user)) completion;

-(void)getMyFriendsWithOffset:(NSInteger)offset andCount:(NSInteger)count onSuccess:(void(^)(NSArray* friends))success onFailure:(void(^)(NSError* error, NSInteger sourceCode))failure;

- (void) getUser:(NSString*)userID onSuccess:(void(^)(NSArray* users)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

-(void)getCityWithCityID:(NSInteger)cityID onSuccess:(void(^)(NSArray* citiesArray))success onFailure:(void(^)(NSError* error, NSInteger sourceCode))failure;

- (void) getWall:(NSString*)userID withOffset:(NSInteger)offset andCount:(NSInteger)count onSuccess:(void(^)(NSArray* walls)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getFollowers:(NSString*)userID withOffset:(NSInteger)offset andCount:(NSInteger)count onSuccess:(void(^)(NSArray* followers)) success
            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


@end
