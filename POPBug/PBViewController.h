//
//  PBViewController.h
//  POPBug
//
//  Created by Zachary Davison on 5/9/14.
//  Copyright (c) 2014 Zachary Davison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBCrowdView.h"

@interface PBViewController : UIViewController

@property (nonatomic, weak) IBOutlet DBCrowdView *crowdView;

@end
