# BSMozaikFlowLayout

Subclass of UICollectionViewLayout which allow you to create nice Mozaik Layout.

![BSMozaikDemp](http://i.imgur.com/VLZ4lW8.png)
![BSMozaikDemo2](http://i.imgur.com/d3dnOzX.png)



## Usage
Set FlowLayoutDelegate

    BSMozaikLayout *bsMozaikLayout = (BSMozaikLayout *)self.collectionView.collectionViewLayout;
    bsMozaikLayout.delegate = self;
    bsMozaikLayout.innerCellInset = 3.f;


Implement UICollectionViewDelegate/DataSource and BSMozaikDelegate.

    - (CGSize)blockPrimitiveSizeForItemAtIndexPath:(NSIndexPath *)indexPath
    {
      CGSize blockSize = [self getSizeForItemAtIndexPathFourthVariant:indexPath.row];
    
      return blockSize;
    }
    
    - (NSInteger)countOfColumnInMozaik
    {
      return 5;
    }
    
    - (CGSize)getSizeForItemAtIndexPathFourthVariant:(NSUInteger)index
    {
        index %= 5;
    
        if (!index)
            return CGSizeMake(1, 1);
        else if (index == 1)
            return CGSizeMake(1, 2);
        else if (index == 2)
            return CGSizeMake(1, 1);
        else if(index == 3)
            return CGSizeMake(2, 1);
        else if (index == 4)
            return CGSizeMake(1, 1); 
    
        return CGSizeZero;
    }

## Installation
1) Import file 
      
      #import "BSMozaikLayout.h"

2) Add the layout as the subclass of your UICollectionViewLayout.
![howto](http://i.imgur.com/STcVs8u.png)

## Author
Problems ? Suggestions? Send to me! bbbsavych@gmail.com
