//
//  BSMozaikLayout.m
//
//  Created by Bohdan Savych on 7/19/16.
//  Copyright © 2016 BBB. All rights reserved.
//

#import "BSMozaikLayout.h"

@interface BSMozaikLayout ()

@property (nonatomic, strong) NSMutableArray<NSValue *> *sizesArray;
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *layoutMatrix;
@property (nonatomic, strong) NSMutableArray<NSValue *> *rectArray;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat blockSide;
@end

@implementation BSMozaikLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    [self resetLayout];
    
    
    NSInteger columnCount = NSNotFound;
    
    if ([self.delegate respondsToSelector:@selector(countOfColumnInMozaik)])
        columnCount = [self.delegate countOfColumnInMozaik];
    
    if (columnCount <= 0 ||
        ![self.delegate respondsToSelector:@selector(blockPrimitiveSizeForItemAtIndexPath:)] ||
        columnCount == NSNotFound)
        return;
    
    NSInteger allItemsCount = 0;
    
    for (int i = 0; i < self.collectionView.numberOfSections; i++)
    {
        for (int j = 0; j < [self.collectionView numberOfItemsInSection:i]; j++) {
            allItemsCount++;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            CGSize size = [self.delegate blockPrimitiveSizeForItemAtIndexPath:indexPath];
            size = CGSizeMake(MIN(size.width, columnCount), size.height);
            NSValue *sizeValue = [NSValue valueWithCGSize:size];
            [self.sizesArray addObject:sizeValue];
        }
    }
    
    self.blockSide = CGRectGetWidth(self.collectionView.bounds) / columnCount;
    
    NSInteger rowsCount = 0;
    CGFloat previousValue = 0.f;
    CGFloat maxHeightInRows = 0;
    
    for (NSValue *sizeValue in self.sizesArray)
    {
        CGSize size = [sizeValue CGSizeValue];
        
        if (size.width == columnCount)
        {
            rowsCount += size.height;
            previousValue = 0;
            maxHeightInRows = 0;
        }
        else
        {
            
            previousValue += size.width;
            
            if (previousValue > columnCount)
            {
                rowsCount += maxHeightInRows;
                maxHeightInRows = size.height;
                previousValue = size.width;
                
                continue;
            }
            
            maxHeightInRows = MAX(maxHeightInRows, size.height);
            
            if (previousValue == columnCount)
            {
                rowsCount += maxHeightInRows;
                maxHeightInRows = 0;
                previousValue = 0;
            }
        }
    }
    
    if (previousValue > 0)
        rowsCount += maxHeightInRows;
    
    for (int i = 0; i < columnCount; i++)
    {
        self.layoutMatrix[i] = [NSMutableArray new];
        
        for (int j = 0 ; j < rowsCount; j++)
        {
            [self.layoutMatrix[i] addObject:@(0)];
        }
    }
    
    for (NSValue *sizeValue in self.sizesArray)
    {
        CGSize blockSize = [sizeValue CGSizeValue];
        int j = 0, i = 0;
        BOOL shouldAdd = NO;
        
        for (j = 0; j < rowsCount; j++)
        {
            for (i = 0; i < columnCount; i++)
            {
                
                if ([self.layoutMatrix[i][j] isEqual:@(0)])
                {
                    if (i + (int)blockSize.width > columnCount)
                        continue;
                    
                    shouldAdd = YES;
                    
                    for (int i1 = i; i1 < i + (int)blockSize.width && shouldAdd; i1++)
                    {
                        for (int j1 = j; j1 < j + (int)blockSize.height; j1++)
                        {
                            if (![self.layoutMatrix[i1][j1] isEqual:@(0)])
                                shouldAdd = NO;
                        }
                    }
                    
                    if (shouldAdd)
                    {
                        for (int i1 = i; i1 < i+ (int)blockSize.width; i1++)
                        {
                            for (int j1 = j; j1 < j + (int)blockSize.height; j1++)
                            {
                                self.layoutMatrix[i1][j1] = @1;
                            }
                        }
                        
                        break;
                    }
                }
            }
            
            if (shouldAdd)
                break;
        }
        
        CGRect rectForItem = CGRectMake(i * self.blockSide, j * self.blockSide, self.blockSide * blockSize.width, self.blockSide * blockSize.height);
        [self.rectArray addObject:[NSValue valueWithCGRect:rectForItem]];
        self.contentHeight = MAX(self.contentHeight, CGRectGetMaxY(rectForItem));
    }
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), self.contentHeight);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributesInRect = [NSMutableArray new];
    
    for (NSValue *cellRect in self.rectArray)
    {
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[self indexPathAcccordingToPositionInArray:[self.rectArray indexOfObject:cellRect]]];
        attribute.frame = CGRectInset(cellRect.CGRectValue, self.innerCellInset, self.innerCellInset);
        [attributesInRect addObject:attribute];
    }
    
    return attributesInRect;
}

#pragma mark - private methods

- (NSIndexPath *)indexPathAcccordingToPositionInArray:(NSUInteger)index
{
    NSUInteger absoluteValue = 0;
    
    for (int i = 0; i < self.collectionView.numberOfSections; i++)
    {
        NSUInteger currentCountOfRowInSection = [self.collectionView numberOfItemsInSection:i];
        absoluteValue += currentCountOfRowInSection;
        
        if (absoluteValue < index)
            continue;
        else if (absoluteValue > index)
        {
            NSUInteger row = currentCountOfRowInSection - (absoluteValue - index);
            
            return [NSIndexPath indexPathForRow:row inSection:i];
        }
        else
        {
            return [NSIndexPath indexPathForRow:0 inSection:i + 1 < self.collectionView.numberOfSections ? i + 1 : i ];
        }
    }
    
    return nil;
}

- (void)resetLayout
{
    self.rectArray = nil;
    self.layoutMatrix = nil;
    self.sizesArray = nil;
    self.contentHeight = 0;
    self.blockSide = 0;
}

#pragma mark - getters & setters

- (NSMutableArray *)sizesArray
{
    if (!_sizesArray)
        _sizesArray = [@[] mutableCopy];
    
    return _sizesArray;
}

- (NSMutableArray<NSMutableArray *> *)layoutMatrix
{
    if (!_layoutMatrix)
        _layoutMatrix = [@[] mutableCopy];
    
    return _layoutMatrix;
}

- (NSMutableArray *)rectArray
{
    if (!_rectArray)
        _rectArray = [@[] mutableCopy];
    
    return _rectArray;
}

@end
