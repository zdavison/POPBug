//
//  DBRatingView.m
//  DropBaker
//
//  Created by Zachary Davison on 5/8/14.
//  Copyright (c) 2014 Adaptics. All rights reserved.
//

#import "DBCrowdView.h"

typedef void (^POPAnimationCompletionBlock)(POPAnimation *anim, BOOL finished);

@interface DBCrowdView()

@property (nonatomic, strong) NSMutableArray *imageLayers;

@end

@implementation DBCrowdView

const char *kObjectAssociationKey = "DBRatingViewObjectAssociationKey";

#pragma mark -
#pragma mark Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder{
  if(self = [super initWithCoder:aDecoder]){
    [self setup];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame{
  if(self = [super initWithFrame:frame]){
    [self setup];
  }
  return self;
}

- (void)setup{
  _maximum = NSNotFound;
  _image = [UIImage imageNamed:@"icon_servings_person"];
  _imageLayers = [NSMutableArray array];
}

#pragma mark Set

- (void)setImage:(UIImage *)image{
  _image = image;
  [self update];
}

- (void)setValue:(NSInteger)value{
  _value = value;
  [self update];
}

#pragma mark Get

- (NSInteger)maximum{
  if(_maximum == NSNotFound && self.image){
    CGFloat area = self.bounds.size.width * self.bounds.size.height;
    CGFloat imageArea = self.image.size.width * self.image.size.height;
    return floor(area / imageArea);
  }
  return _maximum;
}

- (CGPoint)currentInsertPoint{
  if(!self.image){
    return CGPointZero;
  }

  NSInteger numberOfImagesPerRow = self.bounds.size.width / self.image.size.width;
  NSInteger currentColumn = self.imageLayers.count % numberOfImagesPerRow;
  NSInteger currentRow  = self.imageLayers.count / numberOfImagesPerRow;
  CGFloat x = currentColumn * self.image.size.width;
  CGFloat y = currentRow * self.image.size.height;
  return CGPointMake(x, y);
}

- (POPAnimation*)appearAnimation{
  POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleY];
  animation.springBounciness = 14;
  animation.springSpeed = 12;
  animation.fromValue = @0;
  animation.toValue   = @1;
  return animation;
}

- (POPAnimation*)disappearAnimation{
  POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleY];
  animation.springSpeed = 20;
  animation.fromValue = @1;
  animation.toValue   = @0;
  return animation;
}

#pragma mark Private

- (void)removeLastImageLayer{
  [self removeImageLayerAtIndex:self.imageLayers.count - 1];
}

- (void)removeImageLayerAtIndex:(NSInteger)index{
  
  CALayer *layer = self.imageLayers[index];
  
  POPAnimation *animation = [self disappearAnimation];
  animation.completionBlock = ^(POPAnimation *animation, BOOL completed){
    [layer performSelector:@selector(removeFromSuperlayer) withObject:nil afterDelay:1];
    [self.imageLayers removeObject:layer];
  };
  
  if(animation){
    [layer pop_addAnimation:animation forKey:@"disappear"];
  }else{
    [layer removeFromSuperlayer];
  }
  
}

- (void)appendImageLayer{
  
  UIImage *image = self.image;
  
  CALayer *layer = [[CALayer alloc] init];
  layer.anchorPoint = CGPointMake(0.5, 1);
  layer.frame = CGRectMake(self.currentInsertPoint.x,
                           self.currentInsertPoint.y,
                           image.size.width,
                           image.size.height);
  layer.contents = (id)image.CGImage;
  
  POPAnimation *animation = [self appearAnimation];
  
  if(animation){
    [layer pop_addAnimation:animation forKey:@"appear"];
  }
  
  [self.layer addSublayer:layer];
  [self.imageLayers addObject:layer];
  
}

- (void)update{
  if(!self.image){
    return;
  }
  
  NSInteger i = self.value;
  while(i < self.imageLayers.count){
    [self removeLastImageLayer];
  }
  
  while(i > self.imageLayers.count){
    [self appendImageLayer];
  }
}

@end
