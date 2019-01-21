//
//  OPLoginViewController.m
//  APIHomework1
//
//  Created by Oleg on 21.01.2018.
//  Copyright © 2018  Oleg. All rights reserved.
//

#import "OPLoginViewController.h"

@interface OPLoginViewController ()

@property(copy, nonatomic)OPLoginCompletionBlock completionBlock;

@property (weak, nonatomic) UIWebView* webView;


@end

@implementation OPLoginViewController

- (instancetype)initWithCompletionBlock:(OPLoginCompletionBlock) completionBlock {
    
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = self.view.bounds;
    rect.origin = CGPointZero;
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:rect];
    
    
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:webView];
    
    webView.delegate = self;
    
    self.webView = webView;
    self.webView.backgroundColor=[UIColor yellowColor];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancel:)];
    
    [self.navigationItem setRightBarButtonItem:item animated:YES];
    
    [self.navigationItem setTitle:@"Login"];
    
    NSString* urlString =
    @"https://oauth.vk.com/authorize?"
    "client_id=6339483&"
    "display=mobile&"
    "redirect_uri=https://oauth.vk.com/blank.html&"
    "scope=139286&"
    "response_type=token&v=5.71";
    
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"URL %@", [request URL]);
    
    if ([[[request URL] description]rangeOfString:@"#access_token="].location != NSNotFound) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        
        OPAccessToken* token = [[OPAccessToken alloc] init];
        
        NSString* query = [[request URL] description];
        
        NSArray* array = [query componentsSeparatedByString:@"#"];
        
        if ([array count] > 1) {
            query = [array lastObject];
        }
        
        NSArray* pairs = [query componentsSeparatedByString:@"&"];
        
        for (NSString* pair in pairs) {
            
            NSArray* values = [pair componentsSeparatedByString:@"="];
            
            if ([values count] == 2) {
                
                NSString* key = [values firstObject];
                
                if ([key isEqualToString:@"access_token"]) {
                    
                    token.token = [values lastObject];
                    
                } else if ([key isEqualToString:@"expires_in"]) {
                    
                    NSTimeInterval interval = [[values lastObject] doubleValue];
                    
                    token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                    
                } else if ([key isEqualToString:@"user_id"]) {
                    
                    token.userID = [values lastObject];
                    [defaults setObject:token.token forKey:@"token"];
                    [defaults synchronize];

                }
                
            }
            
        }
        NSLog(@"token= %@", token.token);
        self.webView.delegate = nil;
        
        if (self.completionBlock) {
            self.completionBlock(token);
        }
   
        [self.navigationController popToRootViewControllerAnimated:YES];
        return NO;
    }
    
    return YES;
}

#pragma mark - Actions

- (void) actionCancel:(UIBarButtonItem*) sender {
    
    if (self.completionBlock) {
        self.completionBlock(nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
