//
//  DBRatingView.h
//  DropBaker
//
//  Created by Zachary Davison on 5/8/14.
//  Copyright (c) 2014 Adaptics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pop/POP.h>

@interface DBCrowdView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger maximum;

- (POPAnimation*)appearAnimation;
- (POPAnimation*)disappearAnimation;

@end
