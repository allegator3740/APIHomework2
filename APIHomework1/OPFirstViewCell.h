//
//  OPFirstViewCell.h
//  APIHomework1
//
//  Created by  Oleg on 10.01.18.
//  Copyright © 2018  Oleg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPFirstViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;

@property (strong, nonatomic) IBOutlet UILabel *lastSeenLabel;

@end
