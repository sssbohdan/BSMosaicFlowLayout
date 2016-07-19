//
//  BSMozaikLayout.m
//  customLayout
//
//  Created by Bohdan Savych on 7/18/16.
//  Copyright © 2016 BBB. All rights reserved.
//

#import "BSMozaikLayout.h"

@interface BSMozaikLayout ()

@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *cache;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *xOffsets;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *yOffsets;
@property (nonatomic, strong) NSMutableArray<NSValue *> *sizes;
@property (nonatomic, strong) NSMutableArray<NSValue *> *cellRects;
@property (nonatomic, strong) NSMutableDictionary *sectionDicionary;

@end

@implementation BSMozaikLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    _contentWidth = CGRectGetWidth(self.collectionView.bounds);
    
    for (int i = 0; i < self.collectionView.numberOfSections; i++)
    {
        for (int j = 0; j < [self.collectionView numberOfItemsInSection:i]; j++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            CGSize cellSize = [self.delegate blockSizeForItemAtIndexPath:indexPath];
            CGSize actualSize = CGSizeMake(cellSize.width * self.block.width, cellSize.height * self.block.height);
            [self.sizes addObject:[NSValue valueWithCGSize:actualSize]];
        }
        
        [self.sectionDicionary setObject:@([self.collectionView numberOfItemsInSection:i]) forKey:@(i)];//key-section object - items in section
    }
    
    //first cell always will be on this position so set it before loop
    [self.xOffsets addObject:@(0)];
    [self.yOffsets addObject:@(0)];
    [self.cellRects addObject:[NSValue valueWithCGRect:CGRectMake(0, 0, self.sizes[0].CGSizeValue.width, self.sizes[0].CGSizeValue.height)]];
    
    for (int z = 1; z < self.sizes.count; z++)
    {
        for (int i = 0; i < self.cellRects.count; i++)
        {
            CGFloat currentRightBoundForCell = self.xOffsets[i].floatValue + self.sizes[i].CGSizeValue.width;
            CGFloat currentBottomBoundForCell = self.contentHeight = self.yOffsets[i].floatValue + self.sizes[i].CGSizeValue.height;
            CGFloat xOffsetForNewCell = 0;
            CGFloat yOffsetForNewCell = 0;
            CGRect currentRectForCell = CGRectZero;
            
            if ((currentRightBoundForCell + self.sizes[z].CGSizeValue.width) <= self.contentWidth)
            {
                xOffsetForNewCell = currentRightBoundForCell;//x after previous cell
                yOffsetForNewCell = self.yOffsets[i].floatValue;//on the same row
                currentRectForCell = CGRectMake(xOffsetForNewCell, yOffsetForNewCell, self.sizes[z].CGSizeValue.width , self.sizes[z].CGSizeValue.height);
            }
            else
            {
                xOffsetForNewCell = 0;//on the first col
                yOffsetForNewCell = currentBottomBoundForCell;//y after previous cell
                currentRectForCell = CGRectMake(xOffsetForNewCell, yOffsetForNewCell, self.sizes[z].CGSizeValue.width , self.sizes[z].CGSizeValue.height);
            }
            
            BOOL shouldAdd = YES;
            
            for (int j = 0; j < self.cellRects.count; j++)
            {
                if (CGRectIntersectsRect (self.cellRects[j].CGRectValue,currentRectForCell))
                {
                    shouldAdd = NO;
                    break;
                }
            }
            
            if (shouldAdd)
            {
                [self.xOffsets addObject:@(xOffsetForNewCell)];
                [self.yOffsets addObject:@(yOffsetForNewCell)];
                [self.cellRects addObject:[NSValue valueWithCGRect:currentRectForCell]];
                self.contentHeight = currentBottomBoundForCell + currentRectForCell.size.height;
                
                break;//go to another cell rect
            }
        }
    }
    
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.contentWidth, self.contentHeight);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributesInRect = [NSMutableArray new];
    
    for (NSValue *cellRect in self.cellRects)
    {

        NSIndexPath *indexPath = [self getIndexPathForRectAtIndex:[self.cellRects indexOfObject:cellRect]];
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attribute.frame = CGRectInset(cellRect.CGRectValue, self.distanceBetweenCells, self.distanceBetweenCells);
        [attributesInRect addObject:attribute];
    }
    
    return attributesInRect;
}

#pragma mark - helpers

- (NSIndexPath *)getIndexPathForRectAtIndex:(NSInteger)index
{
    NSInteger absoluteValue = 0;
    
    for (int i = 0; i < self.collectionView.numberOfSections; i++)
    {
        absoluteValue += [self.sectionDicionary[@(i)] integerValue];
        
        if (absoluteValue > index)
        {
            NSInteger row = [self.sectionDicionary[@(i)] integerValue] - (absoluteValue - index);
            
            return [NSIndexPath indexPathForRow:row inSection:i];
        }
    }
    
    return 0;
}

#pragma mark - getters

- (NSMutableArray<NSValue *> *)sizes
{
    if (!_sizes)
        _sizes = [@[] mutableCopy];
    
    return _sizes;
}

- (NSMutableArray<NSValue *> *)cellRects
{
    if (!_cellRects)
        _cellRects = [@[] mutableCopy];
    
    return _cellRects;
}

- (NSMutableArray<NSNumber *> *)yOffsets
{
    if (!_yOffsets)
        _yOffsets = [@[] mutableCopy];
    
    return _yOffsets;
}

- (NSMutableArray<NSNumber *> *)xOffsets
{
    if (!_xOffsets)
        _xOffsets = [@[] mutableCopy];
    
    return _xOffsets;
}

- (NSMutableDictionary *)sectionDicionary
{
    if (!_sectionDicionary)
        _sectionDicionary = [NSMutableDictionary new];

    return _sectionDicionary;
}

@end
