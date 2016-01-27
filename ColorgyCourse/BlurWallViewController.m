//
//  BlurWallViewController.m
//  Colorgy
//
//  Created by 張子晏 on 2016/1/20.
//  Copyright © 2016年 張子晏. All rights reserved.
//

#import "BlurwallViewController.h"
#import "UIImage+GaussianBlurUIImage.h"
#import <QuartzCore/QuartzCore.h>
#import "OpeningViewController.h"

#define CELL_IDENTIFIER @"cellIdentifier"
#define FOOTER_IDENTIFIER @"footerIdentifier"
#define HEADER_IDENTIFIER @"headerIdentifier"
#define INSET_NUMBER 2
#define PHOTO_KEY @"photo"
#define MESSAGE_KEY @"message"
#define PRELOAD_NUMBER 10

@implementation BlurWallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // self.cachedImages = [[NSMutableDictionary alloc] init];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    
    self.numberOfColumn = 2;
    
    // blurwallDataMutableArray
    self.blurWallDataMutableArray = [[NSMutableArray alloc] init];
    
    // blurCollectionViewFlowLayout Customized
    self.blurWallCollectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.blurWallCollectionViewFlowLayout.minimumLineSpacing = INSET_NUMBER;
    self.blurWallCollectionViewFlowLayout.minimumInteritemSpacing = INSET_NUMBER;
    self.blurWallCollectionViewFlowLayout.headerReferenceSize = CGSizeMake(0, 0);
    self.blurWallCollectionViewFlowLayout.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 70);
    
    // blurCollectionView Customized
    self.blurWallCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:self.blurWallCollectionViewFlowLayout];
    self.blurWallCollectionView.delegate = self;
    self.blurWallCollectionView.dataSource = self;
    self.blurWallCollectionView.backgroundColor = [self UIColorFromRGB:250 green:247 blue:245 alpha:100];
    self.blurWallCollectionView.alwaysBounceVertical = YES;
    
    [self.blurWallCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    [self.blurWallCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADER_IDENTIFIER];
    [self.blurWallCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FOOTER_IDENTIFIER];
    
    [self.view addSubview:self.blurWallCollectionView];
    
    // Pull to refresh
    self.blurWallRefreshControl = [[UIRefreshControl alloc] init];
    self.blurWallRefreshControl.tintColor = [self UIColorFromRGB:248 green:150 blue:128 alpha:100];
    
    [self.blurWallRefreshControl addTarget:self action:@selector(refreshDataByRefreshCotorl) forControlEvents:UIControlEventValueChanged];
    [self.blurWallCollectionView addSubview:self.blurWallRefreshControl];
    
    // blurWallSegmentedControl
    NSArray *mySegments = [[NSArray alloc] initWithObjects: @"全部", @"男", @"女", nil];
    
    self.blurWallSegmentedControl = [[UISegmentedControl alloc] initWithItems:mySegments];
    self.blurWallSegmentedControl.selectedSegmentIndex = 0;
    self.blurWallSegmentedControl.tintColor = [self UIColorFromRGB:248 green:150 blue:128 alpha:100];
    self.blurWallSegmentedControl.frame = CGRectMake(0, 0, self.view.frame.size.width - 115, 27);
    self.navigationItem.titleView = self.blurWallSegmentedControl;
    [self.blurWallSegmentedControl addTarget:self action:@selector(refreshDataBySegment) forControlEvents:UIControlEventValueChanged];
    
    // LoadinView Customized
    self.loadingView = [[LoadingView alloc] init];
    self.loadingView.loadingString = @"載入中";
    self.loadingView.finishedString = @"完成";
    
    [self.loadingView start];
    [self refreshData:^() {
        [self.loadingView finished:NULL];
    }];
    
    NSLog(@"%lu", (unsigned long)[self.blurWallDataMutableArray count]);
}

#pragma mark - UIColor

- (UIColor *)UIColorFromRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:(alpha / 100)];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    //    return [self.blurwallDataMutableArray count] + self.numberOfColumn;
    return [self.blurWallDataMutableArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld/%ld", (long)indexPath.item, (long)self.blurWallDataMutableArray.count - 1);
    
    if (indexPath.item < self.blurWallDataMutableArray.count) {
        
        // pre-fetch the next 'page' of data.
        if(indexPath.item == (self.blurWallDataMutableArray.count - PRELOAD_NUMBER)){
            [self loadMoreData];
        }
        
        return [self itemCellForIndexPath:indexPath];
    } else {
        [self loadMoreData];
        return [self loadingCellForIndexPath:indexPath];
    }
}

- (UICollectionViewCell *)itemCellForIndexPath:(NSIndexPath *)indexPath {
    // get Cell
    UICollectionViewCell *cell = [self.blurWallCollectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    // set Image
    UIImageView *blurImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    
    //blurImageView.image = [[self.blurWallDataMutableArray objectAtIndex:indexPath.item] objectForKey:PHOTO_KEY];
    NSString *imageUrl = [[self.blurWallDataMutableArray objectAtIndex:indexPath.item] objectForKey:PHOTO_KEY];
    
    if ([[ImageCache sharedImageCache]doesExist:imageUrl]) {
        blurImageView.image = [[ImageCache sharedImageCache]getImage:imageUrl];
    } else {
        blurImageView.image = nil;
        [self downloadImageAtURL:imageUrl withHandler:^(UIImage *image) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                blurImageView.image = [[ImageCache sharedImageCache] getImage:imageUrl];
                [cell setNeedsLayout];
            });
        }];
    }
    
    blurImageView.center = CGPointMake(cell.bounds.size.width / 2, cell.bounds.size.height / 2);
    [cell addSubview:blurImageView];
    
    // set gradient
    UIView *gradientView = [[UIView alloc] initWithFrame:cell.frame];
    
    gradientView.alpha = 0.5;
    gradientView.center = CGPointMake(cell.bounds.size.width / 2, cell.bounds.size.height / 2);
    
    [cell addSubview:gradientView];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = gradientView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil]; // 由上到下的漸層顏色
    [gradientView.layer insertSublayer:gradient atIndex:0];
    
    // set messageRect
    UIImageView *messageRect = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageRect"]];
    
    messageRect.frame = CGRectMake(0, 0, cell.bounds.size.width - 20, 60);
    messageRect.center = CGPointMake(cell.bounds.size.width / 2, cell.bounds.size.height - messageRect.bounds.size.height / 2 - 10);
    
    [cell addSubview:messageRect];
    
    // set message
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, messageRect.bounds.size.width - 16, messageRect.bounds.size.height - 10)];
    
    messageLabel.text = [[self.blurWallDataMutableArray objectAtIndex:indexPath.item] objectForKey:MESSAGE_KEY];
    messageLabel.numberOfLines = 2;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12.0];
    
    [messageRect addSubview:messageLabel];
    
    return cell;
}

- (UICollectionViewCell *)loadingCellForIndexPath:(NSIndexPath *)indexPath {
    
    // get Cell
    UICollectionViewCell *cell = [self.blurWallCollectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    UIView *maskView = [[UIView alloc] initWithFrame:cell.bounds];
    
    maskView.center = CGPointMake(cell.bounds.size.width / 2, cell.bounds.size.height / 2);
    maskView.backgroundColor = [UIColor grayColor];
    
    [cell addSubview:maskView];
    
    // set gradient
    UIView *gradientView = [[UIView alloc] initWithFrame:cell.frame];
    
    gradientView.alpha = 0.5;
    gradientView.center = CGPointMake(cell.bounds.size.width / 2, cell.bounds.size.height / 2);
    
    [cell addSubview:gradientView];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = gradientView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil]; // 由上到下的漸層顏色
    [gradientView.layer insertSublayer:gradient atIndex:0];
    
    // set messageRect
    UIImageView *messageRect = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageRect"]];
    
    messageRect.frame = CGRectMake(0, 0, cell.bounds.size.width - 20, 60);
    messageRect.center = CGPointMake(cell.bounds.size.width / 2, cell.bounds.size.height - messageRect.bounds.size.height / 2 - 10);
    
    [cell addSubview:messageRect];
    
    // set message
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, messageRect.bounds.size.width - 8, messageRect.bounds.size.height - 10)];
    
    messageLabel.text = @"Loading...";
    messageLabel.numberOfLines = 2;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:13.0];
    //    messageLabel.backgroundColor = [UIColor orangeColor];
    
    [messageRect addSubview:messageLabel];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicator.center = CGPointMake(cell.bounds.size.width / 2, cell.bounds.size.height / 2);
    
    [cell addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)theCollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)theIndexPath {
    UICollectionReusableView *reusableView;
    
    if (kind == UICollectionElementKindSectionHeader) {
        reusableView = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADER_IDENTIFIER forIndexPath:theIndexPath];
    } else {
        reusableView = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FOOTER_IDENTIFIER forIndexPath:theIndexPath];
        
        if (self.blurWallDataMutableArray.count) {
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            activityIndicator.color = [self UIColorFromRGB:248 green:150 blue:128 alpha:100];
            activityIndicator.center = CGPointMake(reusableView.bounds.size.width / 2, reusableView.bounds.size.height / 2);
            
            [reusableView addSubview:activityIndicator];
            [activityIndicator startAnimating];
        } else {
            for(UIView *subview in reusableView.subviews) {
                [subview removeFromSuperview];
            }
        }
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellSize = (self.blurWallCollectionView.bounds.size.width - INSET_NUMBER * (self.numberOfColumn - 1)) / self.numberOfColumn;
    
    return CGSizeMake(cellSize, cellSize);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"You Touch: %ld, %ld -> %ld", indexPath.row / self.numberOfColumn, indexPath.row % self.numberOfColumn, indexPath.item);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

#pragma mark - RefreshData

- (void)refreshDataBySegment {
    [self.loadingView start];
    [self.blurWallDataMutableArray removeAllObjects];
    [self refreshData:^() {
        [self.loadingView finished:NULL];
    }];
}

- (void)refreshDataByRefreshCotorl {
    self.blurWallSegmentedControl.userInteractionEnabled = NO;
    [self refreshData:^() {
        self.blurWallSegmentedControl.userInteractionEnabled = YES;
    }];
}

- (void)refreshData:(void (^)(void))callbackBlock {
    
    // 重新整理最新的數據
    // Simulate an async load...
    double delayInSeconds = 3;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self.blurWallDataMutableArray removeAllObjects];
        // Add the new data to our local collection of data.
        for (int i = 19; i >= 0; --i) {
            NSDictionary *dataSet;
            
            switch (self.blurWallSegmentedControl.selectedSegmentIndex) {
                case 0:
                    dataSet = @{ PHOTO_KEY:[self randomImageURL], MESSAGE_KEY:@"愛情片類型的我都愛～" };
                    break;
                case 1:
                    dataSet = @{ PHOTO_KEY:[self randomImageURL], MESSAGE_KEY:@"男：愛情片類型的我都愛～愛情片類型的我都" };
                    break;
                case 2:
                    dataSet = @{ PHOTO_KEY:[self randomImageURL], MESSAGE_KEY:@"女：最喜歡看的是浪漫的電影" };
                    break;
                    
                default:
                    break;
            }
            
            [self.blurWallDataMutableArray addObject:dataSet];
        }
        
        // Tell the collectionView to reload.
        [self.blurWallCollectionView reloadData];
        [self.blurWallRefreshControl endRefreshing];
        if (callbackBlock) {
            callbackBlock();
        }
    });
    [self.blurWallCollectionView reloadData];
}

#pragma mark - LoadMoreData

- (void)loadMoreData {
    // 載入更多
    
    // Simulate an async load...
    
    double delayInSeconds = 3;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        // Add the new data to our local collection of data.
        for (int i = 19; i >= 0; --i) {
            NSDictionary *dataSet;
            
            switch (self.blurWallSegmentedControl.selectedSegmentIndex) {
                case 0:
                    dataSet = @{ PHOTO_KEY:[self randomImageURL], MESSAGE_KEY:@"愛情片類型的我都愛～" };
                    break;
                case 1:
                    dataSet = @{ PHOTO_KEY:[self randomImageURL], MESSAGE_KEY:@"男：愛情片類型的我都愛～愛情片類型的我都" };
                    break;
                case 2:
                    dataSet = @{ PHOTO_KEY:[self randomImageURL], MESSAGE_KEY:@"女：最喜歡看的是浪漫的電影" };
                    break;
                    
                default:
                    break;
            }
            [self.blurWallDataMutableArray addObject:dataSet];
        }
        // Tell the collectionView to reload.
        [self.blurWallCollectionView reloadData];
    });
}

#pragma mark - Lazy Loading Image

- (void)downloadImageAtURL:(NSString *)imageURL withHandler:(void(^)(UIImage *image))handler {
    NSURL *urlString = [NSURL URLWithString:imageURL];
    
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    dispatch_async(queue, ^{
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:urlString options:NSDataReadingUncached error:&error];
        
        if (!error) {
            UIImage *downloadedImage = [UIImage imageWithData:data];
            // Add the image to the cache
            [[ImageCache sharedImageCache] addImage:imageURL image:downloadedImage];
            handler(downloadedImage); // pass back the image in a block
        } else {
            NSLog(@"%@", [error localizedDescription]);
            handler(nil); // pass back nil in the block
        }
    });
}

- (NSString *)randomImageURL {
    NSString *url;
    switch (arc4random() % 14) {
        case 0:
            url = @"http://ext.pimg.tw/francefans/1365590066-1885725527.jpg";
            break;
            
        case 1:
            url = @"https://pbs.twimg.com/profile_images/582851166188363777/wH0ceFD6.jpg";
            break;
            
        case 2:
            url = @"http://improvethesetting.com/wp-content/uploads/25b096baf616cf2297c60fb6f047648a.jpg";
            break;
            
        case 3:
            url = @"http://static1.squarespace.com/static/5150c9fce4b0e340ec530545/5563e708e4b0e65363eb8a8e/5563e70be4b0cc18bc6dde74/1432610571705/zoo-portraits-3.jpg";
            break;
            
        case 4:
            url = @"http://artistsinspireartists.com/wp-content/uploads/2014/07/tumblr_mv8fh6Upbv1s7aky5o1_1280.jpg";
            break;
            
        case 5:
            url = @"http://40.media.tumblr.com/36e7db691595280b3cdbd326efc27c06/tumblr_mkonw7cBIa1s92kf9o5_500.jpg";
            break;
            
        case 6:
            url = @"https://pbs.twimg.com/media/CVnjdGoUwAANhyL.jpg";
            break;
            
        case 7:
            url = @"http://farm3.staticflickr.com/2840/11811663313_9b6da77368_o.jpg";
            break;
            
        case 8:
            url = @"http://farm4.staticflickr.com/3774/11811661673_d658733752_o.jpg";
            break;
            
        case 9:
            url = @"https://inspirationfeeed.files.wordpress.com/2013/04/zoo-portraits-by-yago-partal-6.jpg";
            break;
            
        case 10:
            url = @"http://36.media.tumblr.com/a48b389e4b438fa2820a5ebb3aa8aa9f/tumblr_nl5plyWrn31r1tvwso5_1280.jpg";
            break;
            
        case 11:
            url = @"http://www.picamemag.com/wp-content/uploads/zoo-portraits-picame9.jpg";
            break;
            
        case 12:
            url = @"http://trendland.com/wp-content/uploads/2013/03/zoo-portraits-by-yago-partal-08.jpg";
            break;
            
        case 13:
            url = @"https://s-media-cache-ak0.pinimg.com/736x/18/87/c1/1887c113eb1651b1d84c7492524a2cf5.jpg";
            break;
            
        default:
            break;
    }
    return url;
}

@end
