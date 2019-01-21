//
//  OPLoginViewController.h
//  APIHomework1
//
//  Created by Oleg on 21.01.2018.
//  Copyright © 2018  Oleg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPAccessToken.h"

typedef void(^OPLoginCompletionBlock)(OPAccessToken* token);

@interface OPLoginViewController : UIViewController <UIWebViewDelegate>

- (id) initWithCompletionBlock:(OPLoginCompletionBlock)completionBlock;

@end
