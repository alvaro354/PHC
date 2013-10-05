//
//  SprinFlowLayout.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 19/06/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "SprinFlowLayout.h"

@implementation SprinFlowLayout{
    UIDynamicAnimator *_dynamicAnimator;
}

-(void)prepareLayout{
    
  
     //self.itemSize = self.collectionView.bounds.size;
    
    [super prepareLayout];
    
     // return;
    
    if (!_dynamicAnimator) {
        
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];

    
    CGSize contentSize = [self collectionViewContentSize];
    NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];
    
    
    for (UICollectionViewLayoutAttributes *item in items) {
        UIAttachmentBehavior *spring = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:[item center]];
        spring.length=1;
        spring.damping=0.5;
        spring.frequency=0.8;
        
        [_dynamicAnimator addBehavior:spring];
    }
    
    }

    
}

-(NSArray *) layoutAttributesForElementsInRect:(CGRect)rect{
  //  return [super layoutAttributesForElementsInRect:rect];
    return [_dynamicAnimator itemsInRect:rect];
}



-(UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
  
    
    return [_dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}

-(BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    
    UIScrollView *scrollView = self.collectionView;
    CGFloat scrollDelta = newBounds.origin.y - scrollView.bounds.origin.y;
    CGPoint touchLocation = [scrollView.panGestureRecognizer locationInView:scrollView];
    
    
    for (UIAttachmentBehavior * spring in _dynamicAnimator.behaviors) {
        
        CGPoint anchorPoint = spring.anchorPoint;
        CGFloat distanceFromTouch = fabsf(touchLocation.y - anchorPoint.y);
        CGFloat scrollResistence = distanceFromTouch / 500;
        
        
        UICollectionViewLayoutAttributes *item = [spring.items firstObject];
        CGPoint center = item.center;
        if (scrollDelta > 0)
            center.y += MIN(scrollDelta, scrollDelta * scrollResistence);
        else
            center.y -= MIN(-scrollDelta, -scrollDelta * scrollResistence);
        item.center=center;
        
        
       [_dynamicAnimator updateItemUsingCurrentState:item];

    }
    return NO;
}








@end
