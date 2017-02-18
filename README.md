# BSMozaicFlowLayout

Subclass of UICollectionViewLayout which allow you to create nice Mozaic Layout.

![BSMozaicDemo](http://i.imgur.com/xr4pjFY.png)
![BSMozaicDemo2](http://i.imgur.com/w2XJpAK.png)



## Usage
Set FlowLayoutDelegate

    BSMozaicLayout *bsMozaicLayout = (BSMozaicLayout *)self.collectionView.collectionViewLayout;
    bsMozaicLayout.delegate = self;
    bsMozaicLayout.innerCellInset = 3.f;


Implement UICollectionViewDelegate/DataSource and BSMozaicDelegate.

    - (CGSize)blockPrimitiveSizeForItemAtIndexPath:(NSIndexPath *)indexPath
    {
        CGSize blockSize = [self getSizeForItemAtIndex:indexPath.row];

        return blockSize;
    }

    - (NSInteger)countOfColumnInMozaic
    {
        return 5;
    }

    - (CGSize)getSizeForItemAtIndex:(NSUInteger)index
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
      
      #import "BSMozaicLayout.h"

2) Add the layout as the subclass of your UICollectionViewLayout.
![howto](http://i.imgur.com/6jEb3fP.png)

## Author
Problems ? Suggestions? Send to me! bbbsavych@gmail.com
