//
//  OPProfileTableViewController.m
//  APIHomework1
//
//  Created by  Oleg on 07.01.18.
//  Copyright © 2018  Oleg. All rights reserved.
//

#import "OPProfileTableViewController.h"
#import "OPFirstViewCell.h"
#import "OPWall.h"
#import "OPMyCustomCell.h"
#import <UIImageView+AFNetworking.h>
#import "OPFollowersViewController.h"

@interface OPProfileTableViewController ()

@property(strong, nonatomic)NSMutableArray* usersArray;

@property(strong, nonatomic)NSMutableArray* citiesArray;

@property(strong, nonatomic)NSMutableArray* wallsArray;


@end

@implementation OPProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUserFromUserID:self.userId];
    [self getWall];
    [self getMyCities];
    self.tableView.estimatedRowHeight = 135;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.usersArray=[NSMutableArray array];
    self.citiesArray=[NSMutableArray array];
    self.wallsArray=[NSMutableArray array];

    self.navigationItem.title=[NSString stringWithFormat:@"%@ %@", self.name, self.surname];
}


#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.wallsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString* identifier=nil;
    identifier=@"myFirstCell";

    OPFirstViewCell* cell=[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

    if([self.usersArray count] > 0 && indexPath.row == 0){
        OPFriend* friend=[self.usersArray objectAtIndex:0];
        
        
        NSData* data=[NSData dataWithContentsOfURL:friend.myImageURL];
        cell.myImageView.image=[UIImage imageWithData:data];
        cell.myImageView.layer.cornerRadius=cell.myImageView.bounds.size.width/2;
        cell.myImageView.layer.masksToBounds=YES;
        cell.statusLabel.text=friend.statusString;
        cell.nameLabel.text=[NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
        NSString* cityName=[self.citiesArray firstObject];
        cell.cityLabel.text=cityName;
        cell.lastSeenLabel.text = [NSString stringWithFormat:@"Last seen in %@", [self lastSeenStringFromUnixTime:friend.unixTime]];
        NSLog(@"PLATFORM  = %zd", friend.platform);
        NSLog(@"%@", self.citiesArray);
    }
    if([self.wallsArray count]>0 && indexPath.row > 0 && self.usersArray.count > 0){
        OPFriend* friend=[self.usersArray objectAtIndex:0];
    
        NSData* data=[NSData dataWithContentsOfURL:friend.myImageURL];
       
        OPWall* wall=[self.wallsArray objectAtIndex:indexPath.row];
        NSString* string=[wall.arrayOfURL firstObject];
         NSData* data2=[NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
        identifier=@"OPMyCustomCell";
        
        OPMyCustomCell* wallCell=[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        wallCell.usersPhotoImageView.image=[UIImage imageWithData:data];
        wallCell.usersPhotoImageView.layer.cornerRadius=wallCell.usersPhotoImageView.bounds.size.width/2;
        wallCell.usersPhotoImageView.layer.masksToBounds=YES;
        wallCell.usersNameLabel.text=[NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
        wallCell.myTextLabel.text=wall.text;
        wallCell.usersDateLabel.text=[NSString stringWithFormat:@"Posted in %@", [self lastSeenStringFromUnixTime:wall.unixTime]];
        wallCell.wallImageView.image=[UIImage imageWithData:data2];
        
        return wallCell;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == [self.wallsArray count] - 1){
        [self getWall];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Auxiliary methods

// This method converts unixTime number to NSString
- (NSString*) lastSeenStringFromUnixTime:(double) unixTime {
    
    NSTimeInterval _interval = unixTime;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

#pragma mark - Methods getting various data from server
- (void) getUserFromUserID:(NSString*) userID {
    
    [[OPServerManager sharedManager]getUser:userID onSuccess:^(NSArray *users) {
        
        [self.usersArray addObjectsFromArray:users];
       
        [self.tableView reloadData];
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Error = %@ Status Code = %d", [error localizedDescription], (int)statusCode);
    }];
}

-(void)getWall{
    [[OPServerManager sharedManager]getWall:self.userId withOffset:[self.wallsArray count] andCount:4 onSuccess:^(NSArray *walls) {
        [self.wallsArray addObjectsFromArray:walls];
        [self.tableView reloadData];
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Error = %@ Status Code = %d", [error localizedDescription], (int)statusCode);
    }];
}

-(void)getMyCities{
    [[OPServerManager sharedManager]getCityWithCityID:self.city onSuccess:^(NSArray *citiesArray) {
        self.citiesArray=[NSMutableArray arrayWithArray:citiesArray];
    } onFailure:^(NSError *error, NSInteger sourceCode) {
        NSLog(@"Error = %@ Status Code = %d", [error localizedDescription], (int)sourceCode);
        
    }];
}

#pragma mark - Actions

- (IBAction)followersAction:(UIButton *)sender {
    OPFollowersViewController* followersVC=[self.storyboard instantiateViewControllerWithIdentifier:@"OPFollowersViewController"];
    followersVC.userID=self.userId;
    [self.navigationController pushViewController:followersVC animated:YES];
}
@end
