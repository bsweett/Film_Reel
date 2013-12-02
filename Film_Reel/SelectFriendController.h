//
//  SelectFriendController.h
//  Film_Reel
//
//  Created by Ben Sweett on 11/29/2013.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Networking.h"
#import "AppDelegate.h"
#import "ImageUploadEngine.h"

@interface SelectFriendController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) Networking *sendReelRequest;
@property(nonatomic, strong) UIAlertView *alert;
@property(nonatomic, strong) NSData* imageToSend;
@property(nonatomic, strong) NSArray *tableElements;
@property (strong, nonatomic) AppDelegate* shared;

@property(nonatomic, strong) IBOutlet UIBarButtonItem *Cancel;

@property (strong, nonatomic) ImageUploadEngine* imageUploadEngine;
@property (strong, nonatomic) MKNetworkOperation* imageUpload;

@end
