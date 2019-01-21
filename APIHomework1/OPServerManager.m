//
//  OPServerManager.m
//  APIHomework1
//
//  Created by  Oleg on 05.01.18.
//  Copyright © 2018  Oleg. All rights reserved.
//

#import "OPServerManager.h"
#import <AFNetworking.h>
#import "AFHTTPSessionManager.h"
#import "OPStudent.h"
#import "OPWall.h"

@interface OPServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager* requestOperationManager;

@property(strong, nonatomic)OPAccessToken* accessToken;

@end

@implementation OPServerManager

+(OPServerManager*)sharedManager{
    static OPServerManager* manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[OPServerManager alloc]init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURL* url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        self.requestOperationManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    return self;
}

-(void)setCustomToken:(id)token{
    self.accessToken=token;
}

// This methods begins working if user is not logged in yet and it runs OPLoginViewController
- (void) authorizeUser:(void(^)(OPFriend* user)) completion {
    
    OPLoginViewController* vc = [[OPLoginViewController alloc] initWithCompletionBlock:^(OPAccessToken *token) {
        self.accessToken = token;
        if (token) {
            [self getUser:self.accessToken.userID onSuccess:^(NSArray *users) {
                if (completion) {
                    completion([users firstObject]);
                }
            } onFailure:^(NSError *error, NSInteger statusCode) {
                completion(nil);
            }];
        } else if (completion) {
            completion(nil);
        }
    }];
    UINavigationController* mainVC = (UINavigationController*)[[[[UIApplication sharedApplication]windows]firstObject] rootViewController];
    
    [mainVC pushViewController:vc animated:YES];
}

#pragma mark - Methods for getting data from server
-(void)getMyFriendsWithOffset:(NSInteger)offset andCount:(NSInteger)count onSuccess:(void(^)(NSArray* friends))success onFailure:(void(^)(NSError* error, NSInteger sourceCode))failure{
    
    NSArray* fieldsArray = @[@"online", @"photo_100", @"city"];
    
    NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"1964721",       @"user_id",
                                @"name",            @"order",
                                @(count),           @"count",
                                @(offset),          @"offset",
                                fieldsArray,        @"fields",
                                @"nom",             @"name_case", nil];
    
    [self.requestOperationManager GET:@"friends.get" parameters:dictionary progress:nil
                              success:^(NSURLSessionTask *task, id responseObject) {
                                  
                                  NSLog(@"JSON: %@", responseObject);
                                  id dictsArray = [responseObject objectForKey:@"response"];
                                  NSMutableArray* objectsArray = [NSMutableArray array];
                                  
                                  for (NSDictionary* dict in dictsArray) {
                                      OPStudent* user = [[OPStudent alloc] initWithServerResponse:dict];
                                      [objectsArray addObject:user];
                                  }
                                  NSLog(@"OBJECTS_ARRAY = %zd", objectsArray.count);
                                  if(success) {
                                      success(objectsArray);
                                  }
                              }
                              failure:^(NSURLSessionTask *operation, NSError *error) {
                                  NSLog(@"Error: %@", error);
                                  if (failure) {
                                      failure(error, [(NSHTTPURLResponse *)operation.response statusCode]);
                                  }
                              }];
}

- (void) getUser:(NSString*)userID onSuccess:(void(^)(NSArray* users)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSArray* fieldsArray = @[@"photo_max_orig", @"bdate", @"city", @"last_seen", @"status"];
    NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                userID,             @"user_ids",
                                @"nom",             @"name_case",
                                fieldsArray,        @"fields", nil];
    
    [self.requestOperationManager GET:@"users.get" parameters:dictionary progress:nil
                              success:^(NSURLSessionTask *task, id responseObject) {
                                  NSLog(@"JSON: %@", responseObject);

                                  NSArray* dictsArray = [responseObject objectForKey:@"response"];
                                  NSMutableArray* objectsArray = [NSMutableArray array];
                                  
                                  for (NSDictionary* dict in dictsArray) {
                                      OPFriend* friend = [[OPFriend alloc] initWithServerResponse:dict];
                                      [objectsArray addObject:friend];
                                  }
                                  
                                  if(success) {
                                      success(objectsArray);
                                  }
                              }
                              failure:^(NSURLSessionTask *operation, NSError *error) {
                                  NSLog(@"Error: %@", error);
                                  
                                  if (failure) {
                                      failure(error, [(NSHTTPURLResponse *)operation.response statusCode]);
                                  }
                              }];
}

-(void)getCityWithCityID:(NSInteger)cityID onSuccess:(void(^)(NSArray* citiesArray))success onFailure:(void(^)(NSError* error, NSInteger sourceCode))failure{
    NSDictionary* dictionary=[NSDictionary dictionaryWithObjectsAndKeys:@(cityID), @"city_ids", nil];
                              
    [self.requestOperationManager GET:@"database.getCitiesById" parameters:dictionary progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"CityJSON: %@", responseObject);
        
        NSArray* dictsArray = [responseObject objectForKey:@"response"];
        
        NSMutableArray* objectsArray = [NSMutableArray array];
        
        for (NSDictionary* dict in dictsArray) {
            NSString* cityName = [dict valueForKey:@"name"];
            [objectsArray addObject:cityName];
        }
        
        if(success) {
            success(objectsArray);
            NSLog(@"objectsArray:%@", objectsArray);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error, [(NSHTTPURLResponse *)task.response statusCode]);
        }
    }];
                              
}

- (void) getWall:(NSString*)userID withOffset:(NSInteger)offset andCount:(NSInteger)count onSuccess:(void(^)(NSArray* walls)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{

    NSDictionary* dictionary=[NSDictionary dictionaryWithObjectsAndKeys:userID, @"owner_id",
                              @(offset),              @"offset",
                              @(count),               @"count",
                              @"all",                 @"filter",
                              self.accessToken.token, @"access_token",
                              @(1),                   @"extended",
                              @"5.71",                @"v",
                              nil];

    [self.requestOperationManager GET:@"wall.get" parameters:dictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"WALLS JSON: %@", responseObject);
        id dictsArray=[responseObject objectForKey:@"response"];

        NSMutableArray* objectsArray=[NSMutableArray array];
        for(NSDictionary* dict in [dictsArray objectForKey:@"items"]){
            OPWall* wall=[[OPWall alloc]initWithServerResponse:dict];
            [objectsArray addObject:wall];
        }
        if(success){
            success(objectsArray);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure){
            failure(error, [(NSHTTPURLResponse*)task.response statusCode]);
        }
    }];
}

- (void) getFollowers:(NSString*)userID withOffset:(NSInteger)offset andCount:(NSInteger)count onSuccess:(void(^)(NSArray* followers)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSArray* fieldsArray = @[@"photo_100", @"online"];
    NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                userID,             @"user_id",
                                @(offset),          @"offset",
                                @(count),           @"count",
                                @"name",            @"order",
                                fieldsArray,        @"fields",
                                @"nom",             @"name_case",
                                nil];
    
    
    [self.requestOperationManager GET:@"users.getFollowers" parameters:dictionary progress:nil
     
                              success:^(NSURLSessionTask *task, id responseObject) {
                                  NSLog(@"Followers JSON: %@", responseObject);
                                  
                                  NSDictionary* dictionary = [responseObject objectForKey:@"response"];
                                  NSMutableArray* objectsArray = [NSMutableArray array];
                                  NSArray* dictsArray=[dictionary objectForKey:@"items"];
                                  for (NSDictionary* dict in dictsArray) {
                                      OPStudent* student = [[OPStudent alloc] initWithServerResponse:dict];
                                      [objectsArray addObject:student];
                                  }
                                  
                                  if(success) {
                                      success(objectsArray);
                                  }
                              }
                              failure:^(NSURLSessionTask *operation, NSError *error) {
                                  NSLog(@"Error: %@", error);
                                  
                                  if (failure) {
                                      failure(error, [(NSHTTPURLResponse *)operation.response statusCode]);
                                  }
                              }];
}





@end
