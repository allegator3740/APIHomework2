//
//  ViewController.m
//  APIHomework1
//
//  Created by  Oleg on 05.01.18.
//  Copyright © 2018  Oleg. All rights reserved.
//

#import "ViewController.h"
#import "OPServerManager.h"
#import "OPStudent.h"
#import "OPProfileTableViewController.h"




@interface ViewController ()

@property(strong, nonatomic)NSMutableArray* friendsArray;
@property(assign, nonatomic)BOOL isNotfirstTimeAppear;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    OPAccessToken* token=[[OPAccessToken alloc]init];
    token.token=[defaults objectForKey:@"token"];

    if(!token.token){
    [[OPServerManager sharedManager]authorizeUser:^(OPFriend *friend) {
        NSLog(@"Autherized at last!!");
    }] ;
    }else{
        [[OPServerManager sharedManager]setCustomToken:token];
        NSLog(@"token=%@", token.token);
    }

    self.friendsArray=[NSMutableArray array];
    [self getFriendsFromServer];
    
}

-(void)getFriendsFromServer{
    [[OPServerManager sharedManager]getMyFriendsWithOffset:[self.friendsArray count] andCount:5 onSuccess:^(NSArray *friends) {
        [self.friendsArray addObjectsFromArray:friends];
        NSMutableArray* newPaths = [NSMutableArray array];
        for (int i = (int)[self.friendsArray count] - (int)[friends count]; i < [self.friendsArray count]; i++) {
            [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            NSLog(@"iii = -------------------------------------------------------  %zd", i);
        }
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
    } onFailure:^(NSError *error, NSInteger sourceCode) {
        NSLog(@"error = %@, code = %zd", [error localizedDescription], sourceCode);
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.friendsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier=@"Cell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
    }
    OPStudent* student=[self.friendsArray objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@ %@", student.name, student.surname];

    NSData* data=[[NSData alloc]initWithContentsOfURL:student.urlString];
    
    cell.imageView.image=[UIImage imageWithData:data];
    cell.imageView.layer.cornerRadius=40;
    cell.backgroundColor=[UIColor colorWithRed:100/255.f green:149/255.f blue:237/255.f alpha:1.0f];
    cell.imageView.layer.masksToBounds=YES;
    if(student.isOnline == 1){
    cell.detailTextLabel.text=@"isOnline";
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.4f green:0.9f blue:0.5f alpha:1];
    }
    if (student.isOnline == 0) {
        cell.detailTextLabel.text=@"offLine";
        cell.detailTextLabel.textColor=[UIColor grayColor];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==[self.friendsArray count]-1){
        [self getFriendsFromServer];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OPStudent* student=[self.friendsArray objectAtIndex:indexPath.row];
    OPProfileTableViewController* profileVC=[self.storyboard instantiateViewControllerWithIdentifier:@"OPProfileVC"];
    profileVC.name=student.name;
    profileVC.surname=student.surname;
    profileVC.userId=student.userID;
    profileVC.city = student.city;
    [self.navigationController pushViewController:profileVC animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}




@end
