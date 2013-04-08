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

@interface PassbookStyleCollectionViewController ()

@property (nonatomic,strong) NSMutableArray *backgroundColors;
@property (nonatomic) BOOL couponSelected;
@property (nonatomic) NSUInteger positionCouponSelected;

@end

@implementation PassbookStyleCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.couponSelected = false;
    self.backgroundColors = [[NSMutableArray alloc]initWithCapacity:6];
    [self.backgroundColors addObject:[UIColor redColor]];
    [self.backgroundColors addObject:[UIColor orangeColor]];
    [self.backgroundColors addObject:[UIColor yellowColor]];
    [self.backgroundColors addObject:[UIColor greenColor]];
    [self.backgroundColors addObject:[UIColor blueColor]];
    [self.backgroundColors addObject:[UIColor purpleColor]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//
//    if((self.couponSelected) && (section ==0))
//        return 10.0;
//    else return 0.0;
//
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    if((self.couponSelected) && (section ==0))
//        return 3.0;
//    else return 0.0;
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.couponSelected)
        return CGSizeMake(320, 80);
    else{
        if(indexPath.row == 0){
            return CGSizeMake(320, 420);
        }
        else if (indexPath.row < (self.backgroundColors.count -1))
            return CGSizeMake(300+4*(indexPath.row), 5);
        else
            return CGSizeMake(320, 40 - 5*(self.backgroundColors.count -2));
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [self.backgroundColors objectAtIndex:indexPath.row];
    if((!self.couponSelected)||(indexPath.row ==0)){
        cell.layer.shadowColor = [[UIColor blackColor] CGColor];
        cell.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        cell.layer.shadowRadius = 5.0f;
        cell.layer.shadowOpacity = 1.0f;
        
        
        //    CAShapeLayer * maskLayer = [CAShapeLayer layer];
        //    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: cell.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){10.0, 10.}].CGPath;
        //
        //    cell.layer.mask = maskLayer;
        
        [cell.layer setShadowPath:[UIBezierPath bezierPathWithRect:cell.bounds].CGPath];
    }
    if(((indexPath.row == 0)&& (self.couponSelected))|| ((indexPath.row == self.backgroundColors.count -1)&& (self.couponSelected)))
        cell.layer.cornerRadius = 5.0f;
    else
        cell.layer.cornerRadius = 0.0f;
    cell.clipsToBounds = NO;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.couponSelected){
        [self moveObjectFromIndex:0 toIndex:self.positionCouponSelected];
        self.positionCouponSelected = nil;
    }
    else{
        self.positionCouponSelected = indexPath.row;
        [self moveObjectFromIndex:self.positionCouponSelected toIndex:0];
    }
    [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section]];
    self.couponSelected = !self.couponSelected;
    [self.collectionView performBatchUpdates:^{
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } completion:^(BOOL finished) {}];
    
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
