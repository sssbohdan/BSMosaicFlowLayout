//
//  BSMozaicLayout.h
//
//  Created by Bohdan Savych on 7/19/16.
//  Copyright © 2016 BBB. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol BSMozaicDelegate <NSObject>

- (CGSize)blockPrimitiveSizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)countOfColumnInMozaic;

@end

@interface BSMozaicLayout : UICollectionViewLayout

@property (nonatomic, weak) id<BSMozaicDelegate> delegate;
@property (nonatomic, assign) CGFloat innerCellInset;//space between cells

@end
