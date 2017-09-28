//
//  spLayout.m
//  MeanWiseRedesignHelper
//
//  Created by Hardik on 04/09/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "HMMagLayout.h"

@implementation HMMagLayout

-(id)initWithSize:(CGSize)size
{
    self = [super init];
    if (self)
    {
        sizeMaxSize=CGSizeZero;
        _unitSize = CGSizeMake(size.width,size.height);
        _cellLayouts = [[NSMutableDictionary alloc] init];
    }
    return self;
}


-(void)prepareLayout
{

    //3 row
    float wB3=self.unitSize.width/3;
    float hB3=self.unitSize.height/3;
    
    float wB2=self.unitSize.width/2;
    float hB2=self.unitSize.height/2;

    
    
    float yCurrent=0;
    float xCurrent=0;

    for (NSInteger aSection = 0; aSection < [[self collectionView] numberOfSections]; aSection++)
    {
        
        //Create Cells Frames
        for (NSInteger aRow = 0; aRow < [[self collectionView] numberOfItemsInSection:aSection]; aRow++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:aRow inSection:aSection];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            

            CGRect frameX=CGRectZero;

            
            switch (indexPath.row%11)
            {
                    
                
                    
                case 0:
                    frameX=CGRectMake(xCurrent, yCurrent, wB3, hB3);xCurrent=xCurrent+wB3;
                     break;
                case 1:
                    frameX=CGRectMake(xCurrent, yCurrent, wB3, hB3);xCurrent=xCurrent+wB3;
                    break;
                case 2:
                    frameX=CGRectMake(xCurrent, yCurrent, wB3, hB3);yCurrent=yCurrent+hB3;xCurrent=0;
                    break;
                    
               
                    
                case 3:
                    frameX=CGRectMake(xCurrent, yCurrent, wB3, hB3);yCurrent=yCurrent+hB3;
                    break;
                case 4:
                    frameX=CGRectMake(xCurrent, yCurrent, wB3, hB3);xCurrent=xCurrent+wB3;yCurrent=yCurrent-hB3;
                    break;
                case 5:
                    frameX=CGRectMake(xCurrent, yCurrent, 2*wB3, 2*hB3);yCurrent=yCurrent+2*hB3;xCurrent=0;
                    break;
                    
                    
                    
                case 6:
                    frameX=CGRectMake(xCurrent, yCurrent, 2*wB3, 2*hB3);xCurrent=xCurrent+2*wB3;
                    break;
                case 7:
                    frameX=CGRectMake(xCurrent, yCurrent, wB3, hB3);yCurrent=yCurrent+hB3;
                    break;
                case 8:
                    frameX=CGRectMake(xCurrent, yCurrent, wB3, hB3);yCurrent=yCurrent+hB3;xCurrent=0;
                    break;
                    
                case 9:
                    frameX=CGRectMake(xCurrent, yCurrent, wB2, hB2);xCurrent=xCurrent+wB2;
                    break;
                case 10:
                    frameX=CGRectMake(xCurrent, yCurrent, wB2, hB2);yCurrent=yCurrent+hB2;xCurrent=0;
                    break;
                    

                    
                default:
                    break;
            }
            
            
            if(sizeMaxSize.height<frameX.origin.y+frameX.size.height)
            {
                sizeMaxSize=CGSizeMake(sizeMaxSize.width, frameX.origin.y+frameX.size.height);
            }
            
            //CGRect frame = CGRectMake(xCurrent, yCurrent, width, height);
            [attributes setFrame:frameX];
            [_cellLayouts setObject:attributes forKey:indexPath];
        }
        
    }
}



//-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSMutableArray *retAttributes = [[NSMutableArray alloc] init];
//    
//    for (NSIndexPath *anIndexPath in [self cellLayouts])
//    {
//        UICollectionViewLayoutAttributes *attributes = [self cellLayouts][anIndexPath];
//        if (CGRectIntersectsRect(rect, [attributes frame]))
//        {
//            [retAttributes addObject:attributes];
//        }
//    }
//    return retAttributes;
//}
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray* attributes = [NSMutableArray array];
    for(NSInteger i=0 ; i < self.collectionView.numberOfSections; i++)
    {
        for (NSInteger j=0 ; j < [self.collectionView numberOfItemsInSection:i]; j++)
        {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    return attributes;
}


-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [self cellLayouts][indexPath];
}

-(CGSize)collectionViewContentSize
{
    //3 row
    float wB3=self.unitSize.width/3;
    float hB3=self.unitSize.height/3;
    
    float wB2=self.unitSize.width/2;
    float hB2=self.unitSize.height/2;
    
    NSMutableArray *allCellRect=[[NSMutableArray alloc] init];
    
    float yCurrent=0;
    float xCurrent=0;
    
    for (NSInteger aSection = 0; aSection < [[self collectionView] numberOfSections]; aSection++)
    {
        
        //Create Cells Frames
        for (NSInteger aRow = 0; aRow < [[self collectionView] numberOfItemsInSection:aSection]; aRow++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:aRow inSection:aSection];
            
            
            CGRect frameX=CGRectZero;
            
            
            switch (indexPath.row%11)
            {
                    
                    
                    
                case 0:
                    frameX=CGRectMake(xCurrent, yCurrent, wB3, hB3);xCurrent=xCurrent+wB3;
                    break;
                case 1:
                    frameX=CGRectMake(xCurrent, yCurrent, wB3, hB3);xCurrent=xCurrent+wB3;
                    break;
                case 2:
                    frameX=CGRectMake(xCurrent, yCurrent, wB3, hB3);yCurrent=yCurrent+hB3;xCurrent=0;
                    break;
                    
                    
                    
                case 3:
                    frameX=CGRectMake(xCurrent, yCurrent, wB3, hB3);yCurrent=yCurrent+hB3;
                    break;
                case 4:
                    frameX=CGRectMake(xCurrent, yCurrent, wB3, hB3);xCurrent=xCurrent+wB3;yCurrent=yCurrent-hB3;
                    break;
                case 5:
                    frameX=CGRectMake(xCurrent, yCurrent, 2*wB3, 2*hB3);yCurrent=yCurrent+2*hB3;xCurrent=0;
                    break;
                    
                    
                    
                case 6:
                    frameX=CGRectMake(xCurrent, yCurrent, 2*wB3, 2*hB3);xCurrent=xCurrent+2*wB3;
                    break;
                case 7:
                    frameX=CGRectMake(xCurrent, yCurrent, wB3, hB3);yCurrent=yCurrent+hB3;
                    break;
                case 8:
                    frameX=CGRectMake(xCurrent, yCurrent, wB3, hB3);yCurrent=yCurrent+hB3;xCurrent=0;
                    break;
                    
                case 9:
                    frameX=CGRectMake(xCurrent, yCurrent, wB2, hB2);xCurrent=xCurrent+wB2;
                    break;
                case 10:
                    frameX=CGRectMake(xCurrent, yCurrent, wB2, hB2);yCurrent=yCurrent+hB2;xCurrent=0;
                    break;
                    
                    
                    
                default:
                    break;
            }
            
            
            if(sizeMaxSize.height<frameX.origin.y+frameX.size.height)
            {
                sizeMaxSize=CGSizeMake(sizeMaxSize.width, frameX.origin.y+frameX.size.height);
            }
            
            //CGRect frame = CGRectMake(xCurrent, yCurrent, width, height);
            [allCellRect addObject:[NSValue valueWithCGRect:frameX]];
        }
        
    }
    
    CGRect fullSize=CGRectZero;
    
    for(int i=0;i<[allCellRect count];i++)
    {
        
        CGRect cellRect=[[allCellRect objectAtIndex:i] CGRectValue];
        
        fullSize=CGRectUnion(fullSize, cellRect);
        
        
    }
    
    
    return CGSizeMake(_unitSize.width,fullSize.size.height);
}


-(void)prepareLayout2
{
    
    for (NSInteger i = 0; i < [[self collectionView] numberOfItemsInSection:0]; i ++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        CGRect frame;
        
        
        switch (indexPath.row%9)
        {
            case 0:
                frame = CGRectMake(0, 0, _unitSize.width*3, _unitSize.height*2.5);
                break;
            case 1:
                frame = CGRectMake(0, _unitSize.height*2.5, _unitSize.width, _unitSize.height);
                break;
            case 2:
                frame = CGRectMake(_unitSize.width, _unitSize.height*2.5, _unitSize.width*2, _unitSize.height*2);
                break;
            case 3:
                frame = CGRectMake(0, _unitSize.height*2.5+_unitSize.height, _unitSize.width, _unitSize.height);
                break;
            case 4:
                frame = CGRectMake(0, _unitSize.height*2.5+_unitSize.height+_unitSize.height, _unitSize.width*2, _unitSize.height);
                break;
            case 5:
                frame = CGRectMake(_unitSize.width*2, _unitSize.height*2.5+_unitSize.height+_unitSize.height, _unitSize.width, _unitSize.height);
                break;
            case 6:
                frame = CGRectMake(0, _unitSize.height*2.5+_unitSize.height+_unitSize.height+_unitSize.height, _unitSize.width, _unitSize.height);
                break;
            case 7:
                frame = CGRectMake(_unitSize.width, _unitSize.height*2.5+_unitSize.height+_unitSize.height+_unitSize.height, _unitSize.width*2, _unitSize.height);
                break;
            case 8:
                frame = CGRectMake(0, _unitSize.height*2.5+_unitSize.height+_unitSize.height+_unitSize.height+_unitSize.height, _unitSize.width*3, _unitSize.height*2.5);
                break;
            default:
                frame = CGRectZero;
                break;
        }
        [attributes setFrame:frame];
        [[self cellLayouts] setObject:attributes forKey:indexPath];
    }
}

-(void)prepareLayout1
{
    
    for (NSInteger i = 0; i < [[self collectionView] numberOfItemsInSection:0]; i ++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        CGRect frame;
        
        switch ([indexPath item])
        {
            case 0:
                frame = CGRectMake(0, 0, _unitSize.width*3/2, _unitSize.height*3/2);
                break;
            case 1:
                frame = CGRectMake(_unitSize.width*3/2, 0,  _unitSize.width*3/2, _unitSize.height*3/2);
                break;
                
                
            case 2:
                frame = CGRectMake(0*_unitSize.width, _unitSize.height*3/2, _unitSize.width, _unitSize.height);
                break;
            case 3:
                frame = CGRectMake(1*_unitSize.width, _unitSize.height*3/2, _unitSize.width, _unitSize.height);
                break;
            case 4:
                frame = CGRectMake(2*_unitSize.width, _unitSize.height*3/2, _unitSize.width, _unitSize.height);
                break;
                
                
            case 5:
                frame = CGRectMake(0*_unitSize.width, _unitSize.height*5/2, _unitSize.width, _unitSize.height);
                break;
            case 6:
                frame = CGRectMake(1*_unitSize.width, _unitSize.height*5/2, _unitSize.width, _unitSize.height);
                break;
            case 7:
                frame = CGRectMake(2*_unitSize.width, _unitSize.height*5/2, _unitSize.width, _unitSize.height);
                break;
                
                
                
            case 8:
                frame = CGRectMake(0, _unitSize.height*2.5+_unitSize.height+_unitSize.height+_unitSize.height+_unitSize.height, _unitSize.width*3, _unitSize.height*2.5);
                break;
            default:
                frame = CGRectZero;
                break;
        }
        [attributes setFrame:frame];
        [[self cellLayouts] setObject:attributes forKey:indexPath];
    }
}

@end
