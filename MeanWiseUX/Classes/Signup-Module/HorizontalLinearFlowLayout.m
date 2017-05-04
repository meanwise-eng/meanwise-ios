//
//  HorizontalLinearFlowLayout.m
//  MeanWiseUX
//
//  Created by Mohamed Aas on 3/19/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "HorizontalLinearFlowLayout.h"

@interface HorizontalLinearFlowLayout ()

@property (assign, nonatomic) CGSize lastCollectionViewSize;

@end

@implementation HorizontalLinearFlowLayout

#pragma mark - Configuration

+ (HorizontalLinearFlowLayout *)layoutConfiguredWithCollectionView:(UICollectionView *)collectionView
                                                            itemSize:(CGSize)itemSize
                                                  minimumLineSpacing:(CGFloat)minimumLineSpacing {
    HorizontalLinearFlowLayout *layout = [HorizontalLinearFlowLayout new];
    collectionView.collectionViewLayout = layout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = minimumLineSpacing;
    layout.itemSize = itemSize;
    layout.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    return layout;
}

#pragma mark - Init/Defaults

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureDefaults];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureDefaults];
}

- (void)configureDefaults {
    self.scalingOffset = 200;
    self.minimumScaleFactor = 0.9;
    self.scaleItems = YES;
    self.noOffset = NO;
}

#pragma mark - Invalidation

- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context {
    [super invalidateLayoutWithContext:context];
    
    CGSize currentCollectionViewSize = self.collectionView.bounds.size;
    if (!CGSizeEqualToSize(currentCollectionViewSize, self.lastCollectionViewSize)) {
        [self configureInset];
        self.lastCollectionViewSize = currentCollectionViewSize;
    }
}

- (void)configureInset {
    CGFloat inset = self.collectionView.bounds.size.width/2 - self.itemSize.width/2;
    
    if(self.noOffset){
        inset = 20.0;
    }
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset);
    self.collectionView.contentOffset = CGPointMake(-inset, 0);
}

#pragma mark - UICollectionViewLayout (UISubclassingHooks)

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGSize collectionViewSize = self.collectionView.bounds.size;
    CGFloat proposedContentOffsetCenterX = proposedContentOffset.x + collectionViewSize.width / 2;
    CGRect proposedRect = CGRectMake(proposedContentOffset.x, 0, collectionViewSize.width, collectionViewSize.height);
    
    UICollectionViewLayoutAttributes *candidateAttributes;
    for (UICollectionViewLayoutAttributes *attributes in [self layoutAttributesForElementsInRect:proposedRect]) {
        if (attributes.representedElementCategory != UICollectionElementCategoryCell) continue;
        
        if (!candidateAttributes) {
            candidateAttributes = attributes;
            continue;
        }
        
        if (fabs(attributes.center.x - proposedContentOffsetCenterX) < fabs(candidateAttributes.center.x - proposedContentOffsetCenterX)) {
            candidateAttributes = attributes;
        }
    }
    
    proposedContentOffset.x = candidateAttributes.center.x - self.collectionView.bounds.size.width / 2;
    
    CGFloat offset = proposedContentOffset.x - self.collectionView.contentOffset.x;
    
    if ((velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0)) {
        CGFloat pageWidth = self.itemSize.width + self.minimumLineSpacing;
        proposedContentOffset.x += velocity.x > 0 ? pageWidth : -pageWidth;
    }
    
    return proposedContentOffset;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    if (!self.scaleItems) return [super layoutAttributesForElementsInRect:rect];
    
    NSArray *attributesArray = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect]
                                                    copyItems:YES];
    
    CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
    CGFloat visibleCenterX = CGRectGetMidX(visibleRect);
    
    [attributesArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        CGFloat distanceFromCenter = visibleCenterX - attributes.center.x;
        CGFloat absDistanceFromCenter = MIN(ABS(distanceFromCenter), self.scalingOffset);
        CGFloat scale = absDistanceFromCenter * (self.minimumScaleFactor - 1) / self.scalingOffset + 1;
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1);
    }];
    
    return attributesArray;
}

#pragma mark -

@end
