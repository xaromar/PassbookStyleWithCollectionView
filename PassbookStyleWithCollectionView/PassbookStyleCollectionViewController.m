//
//  PassbookStyleCollectionViewController.m
//  PassbookStyleWithCollectionView
//
//  Created by Xavi on 8/4/13.
//  Copyright (c) 2013 Xavier Roman. All rights reserved.
//

#import "PassbookStyleCollectionViewController.h"
#import <QuartzCore/CALayer.h>
#import <QuartzCore/CAGradientLayer.h>
#import <QuartzCore/CAShapeLayer.h>

#define DEFAULT_CELL_HEIGHT 80
#define SIZE_NOT_SELECTED_CELLS 8

@interface PassbookStyleCollectionViewController ()

@property (nonatomic,strong) NSMutableArray *backgroundColors;
@property (nonatomic) BOOL isCellSelected;
@property (nonatomic) NSUInteger positionCellSelected;
@property (nonatomic) BOOL isConstrainedSizeCellsToViewSize;

@end

@implementation PassbookStyleCollectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isCellSelected = false;
    self.isConstrainedSizeCellsToViewSize = false;
    self.positionCellSelected = -1;
    self.backgroundColors = [NSMutableArray arrayWithArray:@[[UIColor redColor],[UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor blueColor], [UIColor purpleColor]]];
    
}

#pragma mark - Collection View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.backgroundColors count];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.isCellSelected)
        if(!self.isConstrainedSizeCellsToViewSize){
            return CGSizeMake(self.view.bounds.size.width, DEFAULT_CELL_HEIGHT);
        }
        else{
            return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height/self.backgroundColors.count);
        }
    else{
        if(indexPath.row == 0){
            return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height - ((self.backgroundColors.count)*SIZE_NOT_SELECTED_CELLS));
        }
        //This is to create the depth appearance for the not selected cells, tweak the default width factor(0.92) and the incremental value (4) as you wish 
        else if (indexPath.row < (self.backgroundColors.count -1))
            return CGSizeMake((0.92f*self.view.bounds.size.width)+4.0f*(indexPath.row), SIZE_NOT_SELECTED_CELLS);
        //And the final cell (double than the others)
        else
            return CGSizeMake(self.view.bounds.size.width, 2*SIZE_NOT_SELECTED_CELLS);
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [self.backgroundColors objectAtIndex:indexPath.row];
    
    if((!self.isCellSelected)||(indexPath.row ==0)){
        cell.layer.shadowColor = [[UIColor blackColor] CGColor];
        cell.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        cell.layer.shadowRadius = 5.0f;
        cell.layer.shadowOpacity = 1.0f;
        
        [cell.layer setShadowPath:[UIBezierPath bezierPathWithRect:cell.bounds].CGPath];
        cell.clipsToBounds = NO;
    }
    if(((indexPath.row == 0) && (self.isCellSelected)) || ((indexPath.row == self.backgroundColors.count -1) && (self.isCellSelected)))
        cell.layer.cornerRadius = 5.0f;
    else
        cell.layer.cornerRadius = 1.0f;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.isCellSelected){
        [self moveObjectFromIndex:0 toIndex:self.positionCellSelected];
    }
    else{
        self.positionCellSelected = indexPath.row;
        [self moveObjectFromIndex:self.positionCellSelected toIndex:0];
    }
    [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section]];
    self.isCellSelected = !self.isCellSelected;
    [self.collectionView performBatchUpdates:^{
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } completion:nil];
    
}

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    if (to != from) {
        id obj = [self.backgroundColors objectAtIndex:from];
        [self.backgroundColors removeObjectAtIndex:from];
        if (to >= [self.backgroundColors count]) {
            [self.backgroundColors addObject:obj];
        } else {
            [self.backgroundColors insertObject:obj atIndex:to];
        }
    }
}

@end
