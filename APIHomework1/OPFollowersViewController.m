//
//  OPFollowersViewController.m
//  APIHomework1
//
//  Created by Oleg on 27.01.2018.
//  Copyright © 2018  Oleg. All rights reserved.
//

#import "OPFollowersViewController.h"
#import "OPServerManager.h"
#import "OPStudent.h"

@interface OPFollowersViewController ()

@property(strong, nonatomic)NSMutableArray* followersArray;

@end

@implementation OPFollowersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.followersArray=[NSMutableArray array];
    self.view.backgroundColor=[UIColor colorWithRed:100/255.f green:149/255.f blue:237/255.f alpha:1.0f];
    [self getFollowers];
    NSLog(@"%@", self.userID);
}

//This method gets user's followers from server
-(void)getFollowers{
    [[OPServerManager sharedManager]getFollowers:self.userID withOffset:[self.followersArray count] andCount:15 onSuccess:^(NSArray *followers) {
        [self.followersArray addObjectsFromArray:followers];
        NSMutableArray* newPaths=[NSMutableArray array];
        for( int i = (int)[self.followersArray count] - (int)[followers count]; i < [self.followersArray count]; i++){
            [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        //[self.tableView reloadData];
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Error = %@ Status Code = %d", [error localizedDescription], (int)statusCode);
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.followersArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* identifier=@"OPMyFollowersViewCell";
    OPMyFollowersViewCell* followersCell=[tableView dequeueReusableCellWithIdentifier:identifier];
    OPStudent* student=[self.followersArray objectAtIndex:indexPath.row];
    NSData* data=[NSData dataWithContentsOfURL:student.urlString];
    followersCell.backgroundColor=[UIColor colorWithRed:100/255.f green:149/255.f blue:237/255.f alpha:1.0f];
    followersCell.avaImageView.image=[UIImage imageWithData:data];
    followersCell.avaImageView.layer.cornerRadius=followersCell.avaImageView.bounds.size.width/2;
    followersCell.avaImageView.layer.masksToBounds=YES;

    followersCell.nameLabel.text=[NSString stringWithFormat:@"%@ %@", student.name, student.surname];
  
    
    return followersCell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == [self.followersArray count]-1){
        [self getFollowers];
    }
}



@end
