//
//  PBViewController.m
//  POPBug
//
//  Created by Zachary Davison on 5/9/14.
//  Copyright (c) 2014 Zachary Davison. All rights reserved.
//

#import "PBViewController.h"

@interface PBViewController ()

@end

@implementation PBViewController

-(IBAction)plusButtonPressed:(id)sender{
  self.crowdView.value++;
}

- (IBAction)minusButtonPressed:(id)sender{
  self.crowdView.value--;
}

@end
