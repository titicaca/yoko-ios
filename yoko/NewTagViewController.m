//
//  NewTagViewController.m
//  yoko
//
//  Created by BlueSun on 15/8/2.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "NewTagViewController.h"
#import "NewTagCollectionViewCell.h"
#import "TableFriendTag.h"

@interface NewTagViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionViewOfTag;

@end

@implementation NewTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.friendList = [TableFriendTag getFriendArrayByTagId:self.selectedTagId];
    [self.CollectionViewOfTag registerClass:[NewTagCollectionViewCell class] forCellWithReuseIdentifier:@"NewTagCollectionViewCell"];
    self.deleteFlag = 0;
    [self.CollectionViewOfTag setPagingEnabled:NO];
    [self.CollectionViewOfTag setContentOffset:CGPointMake(0, 200000)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NewTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewTagCollectionViewCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 0.8;
    cell.layer.masksToBounds = true;
    cell.backgroundColor=[UIColor orangeColor];
    cell.LabelOfName.text = @"hehe";
    cell.ImageViewOfPhoto.image=[UIImage imageNamed:@"1.png"];
    cell.ButtonOfDelete.tag = indexPath.row;
    [cell.ButtonOfDelete addTarget:self action:@selector(ButtonOfDeleteClick:) forControlEvents:UIControlEventTouchUpInside];

    
    return cell;
}

- (void)ButtonOfDeleteClick:(UIButton *)sender{
    NSLog(@"delete %ld",sender.tag);
  //  NewTagCollectionViewCell *cell = [self.CollectionViewOfTag dequeueReusableCellWithReuseIdentifier:@"NewTagCollectionViewCell" forIndexPath:self.CollectionViewOfTag .indexPathsForVisibleItems[sender.tag]];
    [self.CollectionViewOfTag reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.friendList count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",collectionView.indexPathsForVisibleItems.count);
    NSLog(@"%ld",indexPath.row);
    
    if(indexPath.row == collectionView.indexPathsForVisibleItems.count-1){
        if(self.deleteFlag == 0)
            [self showDeleteSign];
        else
            [self hiddenDeleteSign];
    }
    else if(indexPath.row == collectionView.indexPathsForVisibleItems.count-2){
        
    }
    else{
        [self hiddenDeleteSign];
    }
}



- (void)showDeleteSign{
    for(NSIndexPath *indexPath in self.CollectionViewOfTag .indexPathsForVisibleItems){
        NewTagCollectionViewCell *cell = (NewTagCollectionViewCell *)[self.CollectionViewOfTag  cellForItemAtIndexPath:indexPath];
        cell.ButtonOfDelete.hidden = NO;
        [cell reloadInputViews];
    }
    self.deleteFlag = 1;
    

    
}

- (void)hiddenDeleteSign{
    for(NSIndexPath *indexPath in self.CollectionViewOfTag .indexPathsForVisibleItems){
        NewTagCollectionViewCell *cell = (NewTagCollectionViewCell *)[self.CollectionViewOfTag  cellForItemAtIndexPath:indexPath];
        cell.ButtonOfDelete.hidden = YES;
        [cell reloadInputViews];
    }
    self.deleteFlag = 0;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"test");
}

@end
