//
//  BSMozaikLayout.h
//
//  Created by Bohdan Savych on 7/19/16.
//  Copyright © 2016 BBB. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol BSMozaikDelegate <NSObject>

- (CGSize)blockPrimitiveSizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)countOfColumnInMozaik;

@end

@interface BSMozaikLayout : UICollectionViewLayout

@property (nonatomic, weak) id<BSMozaikDelegate> delegate;
@property (nonatomic, assign) CGFloat innerCellInset;//space between cells

@end
