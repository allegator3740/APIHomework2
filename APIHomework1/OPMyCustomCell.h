//
//  OPMyCustomCell.h
//  APIHomework1
//
//  Created by Oleg on 25.01.2018.
//  Copyright © 2018  Oleg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPMyCustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *usersPhotoImageView;
@property (strong, nonatomic) IBOutlet UILabel *usersNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *usersDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *myTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *wallImageView;

@end
