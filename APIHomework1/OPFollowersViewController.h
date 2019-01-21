//
//  OPFollowersViewController.h
//  APIHomework1
//
//  Created by Oleg on 27.01.2018.
//  Copyright © 2018  Oleg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPMyFollowersViewCell.h"

@interface OPFollowersViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic)NSString* userID;

@end
