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
#import "ColorgyCourse-Swift.h"
#import "HelloViewController.h"
#import "PersonalChatInformationViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define CELL_IDENTIFIER @"cellIdentifier"
#define FOOTER_IDENTIFIER @"footerIdentifier"
#define HEADER_IDENTIFIER @"headerIdentifier"
#define INSET_NUMBER 2
#define PHOTO_KEY @"avatar_blur_2x_url"
#define MESSAGE_KEY @"name"
#define PRELOAD_NUMBER 10

@implementation BlurWallViewController {
    int currentPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    currentPage = 0;
    // self.cachedImages = [[NSMutableDictionary alloc] init];
    
    [self registerForKeyboardNotifications];
    
    // Make RightBarButtonItem
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeButton setImage:[UIImage imageNamed:@"InformationIcon"] forState:UIControlStateNormal];
    [completeButton sizeToFit];
    [completeButton addTarget:self action:@selector(pushToPersonalChatInformationViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:completeButton];
    
    
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
        [self.loadingView finished:^() {}];
    }];
    
    NSLog(@"%lu", (unsigned long)[self.blurWallDataMutableArray count]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 檢查是否回答清晰問
    [ColorgyChatAPI checkUserAvailability:^(ChatUser *chatUser) {
        [ColorgyChatAPI checkAnsweredLatestQuestion:chatUser.userId success:^(BOOL answered) {
            [self.loadingView finished:^() {
                // 取得清晰問
                [ColorgyChatAPI getQuestion:^(NSString *date, NSString *question) {
                    self.questionDate = date;
                    self.cleanAskString = question;
                    if (self.cleanAskString && !answered) {
                        if ([self.cleanAskString length]) {
                            [self cleanAskViewLayout];
                        }
                    }
                } failure:^() {
                    NSLog(@"getQuestion error");
                }];
            }];
        } failure:^() {
            NSLog(@"checkAnswered error");
            [self.loadingView finished:^() {
                // 取得清晰問
                [ColorgyChatAPI getQuestion:^(NSString *date, NSString *question) {
                    self.cleanAskString = question;
                    self.questionDate = date;
                    if (self.cleanAskString) {
                        if ([self.cleanAskString length]) {
                            [self cleanAskViewLayout];
                        }
                    }
                } failure:^() {
                    NSLog(@"getquestion error");
                }];
            }];
        }];
    } failure:^() {
        NSLog(@"check user error");
    }];
}

#pragma mark - KeyboardNotifications

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.cleanAskAlertView.center = CGPointMake(self.currentWindow.center.x, (self.currentWindow.bounds.size.height - kbSize.height - statusBarSize.height) / 2 + statusBarSize.height);
    } completion:^(BOOL finished){}];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    self.cleanAskAlertView.center = CGPointMake(self.currentWindow.center.x, self.currentWindow.center.y);
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
        if(self.blurWallDataMutableArray.count > 10 && indexPath.item == (self.blurWallDataMutableArray.count - PRELOAD_NUMBER)){
            NSLog(@"%ld == %lu", (long)indexPath.item, (unsigned long)self.blurWallDataMutableArray.count);
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
    AvailableTarget *availableTarget = [self.blurWallDataMutableArray objectAtIndex:indexPath.item];
    NSString *imageUrl = availableTarget.avatarBlur2XURL;
    
    if ([[ImageCache sharedImageCache]doesExist:imageUrl]) {
        blurImageView.image = [[ImageCache sharedImageCache]getImage:imageUrl];
    } else {
        blurImageView.image = nil;
        [blurImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
        /*[self downloadImageAtURL:imageUrl withHandler:^(UIImage *image) {
         dispatch_sync(dispatch_get_main_queue(), ^{
         blurImageView.image = [[ImageCache sharedImageCache] getImage:imageUrl];
         
         [cell setNeedsLayout];
         });
         }];*/
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
    
    messageLabel.text = availableTarget.lastAnswer;
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
        
        if (self.blurWallDataMutableArray.count > 6) {
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
    HelloViewController *vc = [[HelloViewController alloc] initWithInformaion:[self.blurWallDataMutableArray objectAtIndex:indexPath.item]];
    //ViewController *vc = [[UIViewController alloc] init];
    //[self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

#pragma mark - RefreshData

- (void)refreshDataBySegment {
    // LoadinView Customized
    self.loadingView = [[LoadingView alloc] init];
    self.loadingView.loadingString = @"載入中";
    self.loadingView.finishedString = @"完成";
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
    [self.blurWallDataMutableArray removeAllObjects];
    NSString *currentGender;
    currentPage = 0;
    switch (self.blurWallSegmentedControl.selectedSegmentIndex) {
        case 0:
            currentGender = @"unspecified";
            break;
        case 1:
            currentGender = @"male";
            break;
        case 2:
            currentGender = @"female";
            break;
    }
    
    // 重新整理最新的數據
    [ColorgyChatAPI checkUserAvailability:^(ChatUser *user) {
        [ColorgyChatAPI getAvailableTarget:user.userId gender:currentGender page:currentPage success:^(NSArray *response) {
            self.blurWallDataMutableArray = [[NSMutableArray alloc] initWithArray:response];
            // Tell the collectionView to reload.
            [self.blurWallCollectionView reloadData];
            [self.blurWallRefreshControl endRefreshing];
            if (callbackBlock) {
                callbackBlock();
            }
        } failure:^() {
            NSLog(@"get AvailableTarget fail");
            [self.blurWallCollectionView reloadData];
            [self.blurWallRefreshControl endRefreshing];
            if (callbackBlock) {
                [self.loadingView dismiss:nil];
                self.loadingView = nil;
                callbackBlock();
            }
        }];
    } failure:^() {
        NSLog(@"check user fail");
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"傳輸失敗Q_Q" message:@"請網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        if (callbackBlock) {
            [self.loadingView dismiss:nil];
            self.loadingView = nil;
            callbackBlock();
        }
    }];
    
    // Simulate an async load...
    //    double delayInSeconds = 3;
    //
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
    //        [self.blurWallDataMutableArray removeAllObjects];
    //        // Add the new data to our local collection of data.
    //        for (int i = 19; i >= 0; --i) {
    //            NSDictionary *dataSet;
    //
    //            switch (self.blurWallSegmentedControl.selectedSegmentIndex) {
    //                case 0:
    //                    dataSet = @{ PHOTO_KEY:[self randomImageURL], MESSAGE_KEY:@"愛情片類型的我都愛～" };
    //                    break;
    //                case 1:
    //                    dataSet = @{ PHOTO_KEY:[self randomImageURL], MESSAGE_KEY:@"男：愛情片類型的我都愛～愛情片類型的我都" };
    //                    break;
    //                case 2:
    //                    dataSet = @{ PHOTO_KEY:[self randomImageURL], MESSAGE_KEY:@"女：最喜歡看的是浪漫的電影" };
    //                    break;
    //
    //                default:
    //                    break;
    //            }
    //
    //            [self.blurWallDataMutableArray addObject:dataSet];
    //        }
    //
    //        // Tell the collectionView to reload.
    //        [self.blurWallCollectionView reloadData];
    //        [self.blurWallRefreshControl endRefreshing];
    //        if (callbackBlock) {
    //            callbackBlock();
    //        }
    //    });
    [self.blurWallCollectionView reloadData];
}

#pragma mark - LoadMoreData

- (void)loadMoreData {
    // 載入更多
    currentPage += 1;
    NSString *currentGender;
    switch (self.blurWallSegmentedControl.selectedSegmentIndex) {
        case 0:
            currentGender = @"unspecified";
            break;
        case 1:
            currentGender = @"male";
            break;
        case 2:
            currentGender = @"female";
            break;
    }
    
    // 重新整理最新的數據
    [ColorgyChatAPI checkUserAvailability:^(ChatUser *user) {
        [ColorgyChatAPI getAvailableTarget:user.userId gender:currentGender page:currentPage success:^(NSArray *response) {
            [self.blurWallDataMutableArray addObjectsFromArray:response];
            // Tell the collectionView to reload.
            [self.blurWallCollectionView reloadData];
            [self.blurWallRefreshControl endRefreshing];
        } failure:^() {
            NSLog(@"get AvailableTarget fail");
            [self.blurWallCollectionView reloadData];
            [self.blurWallRefreshControl endRefreshing];
        }];
    } failure:^() {
        NSLog(@"check user fail");
        
        //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"傳輸失敗Q_Q" message:@"請網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
        //
        //        [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //        }]];
        //        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
    // Simulate an async load...
    
    //    double delayInSeconds = 3;
    //
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
    //        // Add the new data to our local collection of data.
    //        for (int i = 19; i >= 0; --i) {
    //            NSDictionary *dataSet;
    //
    //            switch (self.blurWallSegmentedControl.selectedSegmentIndex) {
    //                case 0:
    //                    dataSet = @{ PHOTO_KEY:[self randomImageURL], MESSAGE_KEY:@"愛情片類型的我都愛～" };
    //                    break;
    //                case 1:
    //                    dataSet = @{ PHOTO_KEY:[self randomImageURL], MESSAGE_KEY:@"男：愛情片類型的我都愛～愛情片類型的我都" };
    //                    break;
    //                case 2:
    //                    dataSet = @{ PHOTO_KEY:[self randomImageURL], MESSAGE_KEY:@"女：最喜歡看的是浪漫的電影" };
    //                    break;
    //
    //                default:
    //                    break;
    //            }
    //            [self.blurWallDataMutableArray addObject:dataSet];
    //        }
    //        // Tell the collectionView to reload.
    //        [self.blurWallCollectionView reloadData];
    //    });
}

#pragma mark - Lazy Loading Image

- (void)downloadImageAtURL:(NSString *)imageURL withHandler:(void(^)(UIImage *image))handler {
    if (imageURL) {
        NSURL *urlString = [NSURL URLWithString:imageURL];
        
        dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
        dispatch_async(queue, ^{
            NSError *error = nil;
            NSData *data = [NSData dataWithContentsOfURL:urlString options:NSDataReadingUncached error:&error];
            NSLog(@"%@", urlString);
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

#pragma mark - cleanAskView

- (void)cleanAskViewLayout {
    
    //    if (self.cleanAskString) {
    //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"每日清晰問" message:self.cleanAskString preferredStyle:UIAlertControllerStyleAlert];
    //
    //        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];
    //        [alertController addAction:[UIAlertAction actionWithTitle:@"發送" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    //            [ColorgyChatAPI checkUserAvailability:^(ChatUser *chatUser) {
    //                [ColorgyChatAPI answerQuestion:chatUser.userId answer:alertController.textFields.firstObject.text date:self.questionDate success:^() {
    //                } failure:^() {
    //                    NSLog(@"answerQuestion error");
    //                }];
    //            } failure:^() {
    //                NSLog(@"check user error");
    //
    //                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失敗Q_Q" message:@"請網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
    //
    //                [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    //                }]];
    //                [self presentViewController:alertController animated:YES completion:nil];
    //            }];
    //        }]];
    //        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    //        }];
    //
    //        [self presentViewController:alertController animated:YES completion:nil];
    //    }
    
    // currentWindow
    self.currentWindow = [UIApplication sharedApplication].keyWindow;
    // cleanAskMaskView
    self.cleanAskMaskView = [[UIView alloc] initWithFrame:self.currentWindow.bounds];
    self.cleanAskMaskView.backgroundColor = [UIColor blackColor];
    self.cleanAskMaskView.alpha = 0.75;
    [self.currentWindow addSubview:self.cleanAskMaskView];
    // cleanAskAertView
    self.cleanAskAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.currentWindow.bounds.size.width - 100, 216)];
    self.cleanAskAlertView.center = self.currentWindow.center;
    self.cleanAskAlertView.layer.cornerRadius = 12.5;
    self.cleanAskAlertView.backgroundColor = [UIColor whiteColor];
    [self.currentWindow addSubview:self.cleanAskAlertView];
    // cleanAskTitleLabel
    self.cleanAskTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.cleanAskAlertView.bounds.size.width - 50, 18)];
    NSAttributedString *attributedCleanAskTitleString = [[NSAttributedString alloc] initWithString:@"每日清晰問" attributes:@{NSForegroundColorAttributeName:[self UIColorFromRGB:0.0 green:0.0 blue:0.0 alpha:100.0], NSFontAttributeName:[UIFont fontWithName:@"STHeitiTC-Medium" size:17.0]}];
    self.cleanAskTitleLabel.attributedText = attributedCleanAskTitleString;
    self.cleanAskTitleLabel.textColor = [self UIColorFromRGB:0.0 green:0.0 blue:0.0 alpha:100.0];
    self.cleanAskTitleLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:17.0];
    self.cleanAskTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.cleanAskTitleLabel.center = CGPointMake(self.cleanAskAlertView.bounds.size.width / 2, 30);
    [self.cleanAskAlertView addSubview:self.cleanAskTitleLabel];
    // cleanAskMessageLabel
    self.cleanAskMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.cleanAskAlertView.bounds.size.width - 30, 17)];
    self.cleanAskMessageLabel.center = CGPointMake(self.cleanAskAlertView.bounds.size.width / 2, self.cleanAskTitleLabel.center.y + 35);
    self.cleanAskMessageLabel.numberOfLines = 0;
    self.cleanAskMessageLabel.textAlignment = NSTextAlignmentCenter;
    NSAttributedString *attributedCleanAskMessageString;
    if (self.cleanAskString) {
        attributedCleanAskMessageString = [[NSAttributedString alloc] initWithString:self.cleanAskString attributes:@{NSForegroundColorAttributeName:[self UIColorFromRGB:151.0 green:151.0 blue:151.0 alpha:100.0], NSFontAttributeName:[UIFont fontWithName:@"STHeitiTC-Light" size:14.0]}];
    }
    
    self.cleanAskMessageLabel.attributedText = attributedCleanAskMessageString;
    [self.cleanAskAlertView addSubview:self.cleanAskMessageLabel];
    // cleanAskTextView
    self.cleanAskTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.cleanAskAlertView.frame.size.width - 60, 62)];
    self.cleanAskTextView.center = CGPointMake(self.cleanAskAlertView.bounds.size.width / 2, CGRectGetMaxY(self.cleanAskMessageLabel.frame) + self.cleanAskTextView.frame.size.height / 2 + 20);
    [self.cleanAskAlertView addSubview:self.cleanAskTextView];
    self.cleanAskTextView.layer.borderWidth = 1;
    self.cleanAskTextView.layer.cornerRadius = 3;
    self.cleanAskTextView.textAlignment = NSTextAlignmentCenter;
    self.cleanAskTextView.layer.borderColor = [self UIColorFromRGB:200 green:199 blue:198 alpha:100].CGColor;
    self.cleanAskTextView.delegate = self;
    
    CGSize size;
    if (self.cleanAskString) {
        [self.cleanAskString sizeWithAttributes:@{NSForegroundColorAttributeName:[self UIColorFromRGB:151.0 green:151.0 blue:151.0 alpha:100.0], NSFontAttributeName: [UIFont fontWithName:@"STHeitiTC-Light" size:17.0]}];
        
        if (size.width >= self.cleanAskMessageLabel.frame.size.width) {
            [self.cleanAskMessageLabel sizeToFit];
        }
    }
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.cancelButton.frame = CGRectMake(0, CGRectGetHeight(self.cleanAskAlertView.frame) - 45, self.cleanAskAlertView.frame.size.width / 2, 45);
    self.submitButton.frame = CGRectMake(CGRectGetWidth(self.cleanAskAlertView.frame) / 2, CGRectGetHeight(self.cleanAskAlertView.frame) - 45, self.cleanAskAlertView.frame.size.width / 2, 45);
    //    cancelButton.backgroundColor = [UIColor orangeColor];
    //    submitButton.backgroundColor = [UIColor blueColor];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.submitButton setTitle:@"發送" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[self UIColorFromRGB:151 green:151 blue:151 alpha:100] forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[self UIColorFromRGB:248 green:150 blue:128 alpha:100] forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiTC-Medium" size:17]];
    [self.submitButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiTC-Medium" size:17]];
    
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.cancelButton.bounds byRoundingCorners:(UIRectCornerBottomLeft) cornerRadii:CGSizeMake(12.5, 12.5)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.cancelButton.bounds;
    maskLayer.path = maskPath.CGPath;
    self.cancelButton.layer.mask = maskLayer;
    
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.submitButton.bounds byRoundingCorners:(UIRectCornerBottomRight) cornerRadii:CGSizeMake(12.5, 12.5)];
    
    maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.submitButton.bounds;
    maskLayer.path = maskPath.CGPath;
    self.submitButton.layer.mask = maskLayer;
    
    [self.cleanAskAlertView addSubview:self.cancelButton];
    [self.cleanAskAlertView addSubview:self.submitButton];
    
    [self.cancelButton addTarget:self action:@selector(removeCleanAskViewLayout) forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton addTarget:self action:@selector(answerQuestion) forControlEvents:UIControlEventTouchUpInside];
    
    self.line1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.cancelButton.frame), CGRectGetMinY(self.cancelButton.frame), self.cleanAskAlertView.frame.size.width, 1)];
    [self.line1 setBackgroundColor:[self UIColorFromRGB:139 green:138 blue:138 alpha:100]];
    [self.cleanAskAlertView addSubview:self.line1];
    
    self.line2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.cleanAskAlertView.frame) / 2, CGRectGetMinY(self.cancelButton.frame), 0.5, self.cancelButton.frame.size.height)];
    [self.line2 setBackgroundColor:[self UIColorFromRGB:139 green:138 blue:138 alpha:100]];
    [self.cleanAskAlertView addSubview:self.line2];
    
    // textNumberCunter Customized
    self.textNumberCounterLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.cleanAskTextView.bounds.size.width - 45, self.cleanAskTextView.bounds.size.height - 30, 45, 30)];
    self.textNumberCounterLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:13];
    self.textNumberCounterLabel.textColor = [self UIColorFromRGB:151 green:151 blue:151 alpha:100];
    self.textNumberCounterLabel.text = @"0/20";
    [self.cleanAskTextView addSubview:self.textNumberCounterLabel];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(finishTextView)];
    
    [self.cleanAskMaskView addGestureRecognizer:tapGestureRecognizer];
}

- (void)finishTextView {
    [self.cleanAskTextView resignFirstResponder];
}

- (void)removeCleanAskViewLayout {
    [self.cleanAskView removeFromSuperview];
    [self.cleanAskMaskView removeFromSuperview];
    [self.cleanAskAlertView removeFromSuperview];
    [self.cleanAskTextView removeFromSuperview];
    [self.currentWindow removeFromSuperview];
    [self.cleanAskTitleLabel removeFromSuperview];
    [self.cleanAskMessageLabel removeFromSuperview];
    [self.cancelButton removeFromSuperview];
    [self.submitButton removeFromSuperview];
    [self.line1 removeFromSuperview];
    [self.line2 removeFromSuperview];
    [self.textNumberCounterLabel removeFromSuperview];
}

- (void)answerQuestion {
    [self removeCleanAskViewLayout];
    [ColorgyChatAPI checkUserAvailability:^(ChatUser *chatUser) {
        [ColorgyChatAPI answerQuestion:chatUser.userId answer:self.cleanAskTextView.text date:self.questionDate success:^() {
        } failure:^() {
            NSLog(@"answerQuestion error");
        }];
    } failure:^() {
        NSLog(@"check user error");
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失敗Q_Q" message:@"請網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView == self.cleanAskTextView) {
        self.textNumberCounterLabel.text = [NSString stringWithFormat:@"%ld/20", [self stringCounter:textView.text] / 2];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.cleanAskTextView) {
        if (!self.cleanAskTextView.markedTextRange) {
            self.cleanAskTextView.text = [self stringCounterTo:textView.text number:40.0];
            self.textNumberCounterLabel.text = [NSString stringWithFormat:@"%ld/20", [self stringCounter:textView.text] / 2];
        }
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView == self.cleanAskTextView) {
        self.cleanAskTextView.text = [self stringCounterTo:textView.text number:40.0];
    }
    
    return YES;
}

#pragma mark - StringCounter

- (NSInteger)stringCounter:(NSString *)string {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5);
    NSData *data = [string dataUsingEncoding:enc];
    
    NSLog(@"length:%lu", (unsigned long)string.length);
    NSLog(@"counter:%lu", [data length] / 2);
    return [data length];
}

- (NSString *)stringCounterTo:(NSString *)string number:(CGFloat)number {
    NSString *tempString;
    
    for (NSInteger i = 0; i < string.length; ++i) {
        tempString = [string substringToIndex:string.length - i];
        
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5);
        NSData *data = [tempString dataUsingEncoding:enc];
        
        if ([data length] <= number) {
            break;
        }
    }
    return tempString;
}

#pragma mark - information view
- (void)pushToPersonalChatInformationViewController {
    PersonalChatInformationViewController *vc = [[PersonalChatInformationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
