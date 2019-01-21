//
//  OPProfileTableViewController.h
//  APIHomework1
//
//  Created by  Oleg on 07.01.18.
//  Copyright © 2018  Oleg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPServerManager.h"
#import "OPFriend.h"

@interface OPProfileTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic)NSString* name;

@property(strong, nonatomic)NSString* surname;

@property(strong, nonatomic)NSString* userId;

@property(assign, nonatomic)NSInteger city;
- (IBAction)followersAction:(UIButton *)sender;

@end
