//
//  BSMozaikLayout.h
//  customLayout
//
//  Created by Bohdan Savych on 7/18/16.
//  Copyright © 2016 BBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BSMozaikLayoutDelegate <NSObject>

- (CGSize)blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BSMozaikLayout : UICollectionViewLayout

@property (nonatomic, assign) CGSize block;
@property (nonatomic, weak) id<BSMozaikLayoutDelegate> delegate;
@property (nonatomic, assign) CGFloat distanceBetweenCells;

@end
