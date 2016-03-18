//
// PersonalChatInformationViewController.m
//  ColorgyCourse
//
//  Created by 張子晏 on 2016/2/2.
//  Copyright © 2016年 David. All rights reserved.
//

#import "PersonalChatInformationViewController.h"
#import "ColorgyCourse-Swift.h"
#import "UIImage+GaussianBlurUIImage.h"
#import "ColorgyChatAPIOC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UselessView.h"

@interface PersonalChatInformationViewController () {
    UIBarButtonItem *submitBarButtonItem;
    UIScrollView *scrollView;
    UIView *notificationView;
    UIImageView *userImageView;
    UIButton *editUserImageButton;
    UILabel *nameLabel;
    UITextField *nameTextField;
    UILabel *textNumberCounterLabel;
    UIView *checkedView;
    BOOL nameIsOk;
    UIActivityIndicatorView *checkingView;
    UILabel *aboutHoroscopeLabel;
    UITextField *aboutHoroscopeTextField;
    UILabel *aboutSchoolLabel;
    UITextField *aboutSchoolTextField;
    UILabel *aboutHabitancyLabel;
    UITextField *aboutHabitancyTextField;
    UILabel *aboutConversationLabel;
    UITextView *aboutConversationTextView;
    UILabel *aboutPassionLabel;
    UITextView *aboutPassionTextView;
    UILabel *aboutExpertiseLabel;
    UITextView *aboutExpertiseTextView;
    
    ChatMeUserInformation *userInformation;
    NSArray *horoscpoeArray;
    NSArray *addressArray;
}

@end

@implementation PersonalChatInformationViewController

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    // result.text = [array objectAtIndex:row];
    if (self.activeTextField == aboutHoroscopeTextField) {
        aboutHoroscopeTextField.text = [horoscpoeArray objectAtIndex:row];
    } else if (self.activeTextField == aboutHabitancyTextField) {
        aboutHabitancyTextField.text = [addressArray objectAtIndex:row];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.activeTextField == aboutHoroscopeTextField) {
        return [horoscpoeArray objectAtIndex:row];
    } else if (self.activeTextField == aboutHabitancyTextField) {
        return [addressArray objectAtIndex:row];
    } else {
        return nil;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.activeTextField == aboutHoroscopeTextField) {
        return [horoscpoeArray count];
    } else if (self.activeTextField == aboutHabitancyTextField) {
        return [addressArray count];
    } else {
        return 0;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [ColorgyChatAPI me:^(ChatMeUserInformation *information) {
        userInformation = information;
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        activityIndicatorView.center = CGPointMake(userImageView.bounds.size.width / 2, userImageView.bounds.size.height / 2);
        [userImageView addSubview:activityIndicatorView];
        
        // [activityIndicatorView startAnimating];
        [userImageView sd_setImageWithURL:[NSURL URLWithString:userInformation.avatarURL]];
        nameTextField.text = userInformation.name;
        aboutSchoolTextField.placeholder = information.organizationCode;
        [self showCheck];
        
        nameTextField.text = information.name;
        NSLog(@"%@", information.name);
        textNumberCounterLabel.text = [NSString stringWithFormat:@"%ld/8", (long)[self stringCounter:nameTextField.text]];
        [self showCheck];
        aboutConversationTextView.text = information.aboutConversation;
        aboutExpertiseTextView.text = information.aboutExpertise;
        aboutHabitancyTextField.text = information.aboutHabitancy;
        aboutHoroscopeTextField.text = information.aboutHoroscope;
        aboutPassionTextView.text = information.aboutPassion;
        aboutSchoolTextField.text = information.aboutSchool;
        
        
        submitBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(submitMethod)];
        self.navigationItem.rightBarButtonItem = submitBarButtonItem;
        
        
        
        CGFloat buttonHeight = 16;
        
        editUserImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [editUserImageButton setFrame:CGRectMake(userImageView.frame.origin.x, CGRectGetMaxY(userImageView.frame) - buttonHeight * 2, userImageView.bounds.size.width, buttonHeight)];
        [editUserImageButton setTitle:@"編輯" forState:UIControlStateNormal];
        [editUserImageButton.titleLabel setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:16.0]];
        [editUserImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [editUserImageButton addTarget:self action:@selector(showPhotoMeunAlert) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:editUserImageButton];
    } failure:^() {
        NSLog(@"get me error");
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"傳輸失敗Q_Q" message:@"請網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
    [self.tabBarController.tabBar setHidden:YES];
    
    // keyboard and tapGesture
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchViewToReturn)];
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    // Navigation Customized
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[self UIColorFromRGB:74.0 green:74.0 blue:74.0 alpha:100.0], NSFontAttributeName:[UIFont fontWithName:@"STHeitiTC-Medium" size:17.0]};
    [self.navigationController.navigationBar setTintColor:[self UIColorFromRGB:248 green:150 blue:128 alpha:100]];
    [self setTitle:@"個人資料"];
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [self UIColorFromRGB:250 green:247 blue:245 alpha:100];
    [self.view addSubview:scrollView];
    
    // notificationView
    //    notificationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 48)];
    //    notificationView.backgroundColor = [self UIColorFromRGB:<#(CGFloat)#> green:<#(CGFloat)#> blue:<#(CGFloat)#> alpha:<#(CGFloat)#>]
    
    // userImageview
    CGFloat imageViewLength = 150;
    
    userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - imageViewLength / 2, self.view.bounds.origin.y + 100, imageViewLength, imageViewLength)];
    //    [userImageView sd_setImageWithURL:[NSURL URLWithString:[UserSetting UserAvatarUrl]]];
    [userImageView.layer setCornerRadius:imageViewLength / 2];
    [userImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [userImageView.layer setBorderWidth:3];
    [userImageView.layer setMasksToBounds:YES];
    [scrollView addSubview:userImageView];
    
    CGFloat sectionY = 30;
    CGFloat marginX = 25;
    CGFloat marginY = 10;
    CGFloat height = 32;
    CGFloat width = self.view.bounds.size.width - marginX * 2;
    CGRect textFieldPaddingRect = CGRectMake(0, 0, 5, 20);
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(userImageView.frame) + 50, width, height)];
    nameLabel.text = @"暱稱";
    nameLabel.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    nameLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17.0];
    [scrollView addSubview:nameLabel];
    
    nameTextField = [[UITextField alloc] initWithFrame: CGRectMake(marginX, CGRectGetMaxY(nameLabel.frame) + marginY, width, height)];
    nameTextField.backgroundColor = [UIColor whiteColor];
    nameTextField.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    //    nameTextField.text = [UserSetting UserNickyName];
    nameTextField.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16.0];
    nameTextField.leftView = [[UIView alloc] initWithFrame:textFieldPaddingRect];
    nameTextField.leftViewMode = UITextFieldViewModeAlways;
    [nameTextField.layer setBorderColor:[self UIColorFromRGB:200 green:199 blue:198 alpha:100].CGColor];
    [nameTextField.layer setBorderWidth:1];
    [nameTextField.layer setCornerRadius:3];
    [nameTextField.layer setMasksToBounds:YES];
    [nameTextField setDelegate:self];
    [scrollView addSubview:nameTextField];
    
    [self registerForUITextFieldTextDidChangeNotification];
    
    checkedView = [[UIView alloc] initWithFrame:CGRectMake(nameTextField.frame.size.width - nameTextField.frame.size.height, 0, nameTextField.frame.size.height, nameTextField.frame.size.height)];
    
    checkedView.backgroundColor = [UIColor clearColor];
    
    UIImageView *checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckIcon"]];
    
    checkImageView.center = CGPointMake(checkedView.frame.size.width / 2, checkedView.frame.size.height / 2);
    [checkedView addSubview:checkImageView];
    
    // textNumberCounter Customized
    textNumberCounterLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameTextField.frame.size.width - 50, 30, 45, 30)];
    textNumberCounterLabel.center = CGPointMake(nameTextField.frame.size.width - 50 / 2, nameTextField.frame.size.height / 2);
    textNumberCounterLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:13];
    textNumberCounterLabel.textColor = [self UIColorFromRGB:151 green:151 blue:151 alpha:100];
    textNumberCounterLabel.text = @"0/8";
    
    [nameTextField addSubview:textNumberCounterLabel];
    nameIsOk = NO;
    
    
    aboutHoroscopeLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(nameTextField.frame) + sectionY, width, 32)];
    aboutHoroscopeLabel.text = @"星座";
    aboutHoroscopeLabel.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    aboutHoroscopeLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17.0];
    [scrollView addSubview:aboutHoroscopeLabel];
    
    aboutHoroscopeTextField = [[UITextField alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(aboutHoroscopeLabel.frame) + marginY, width, height)];
    aboutHoroscopeTextField.tag = 2;
    [aboutHoroscopeTextField setDelegate:self];
    aboutHoroscopeTextField.backgroundColor = [UIColor whiteColor];
    aboutHoroscopeTextField.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    aboutHoroscopeTextField.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16.0];
    aboutHoroscopeTextField.leftView = [[UIView alloc] initWithFrame:textFieldPaddingRect];
    aboutHoroscopeTextField.leftViewMode = UITextFieldViewModeAlways;
    [aboutHoroscopeTextField.layer setBorderColor:[self UIColorFromRGB:200 green:199 blue:198 alpha:100].CGColor];
    [aboutHoroscopeTextField.layer setBorderWidth:1];
    [aboutHoroscopeTextField.layer setCornerRadius:3];
    [aboutHoroscopeTextField.layer setMasksToBounds:YES];
    [scrollView addSubview:aboutHoroscopeTextField];
    
    aboutSchoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(aboutHoroscopeTextField.frame) + sectionY, width, 32)];
    aboutSchoolLabel.text = @"學校";
    aboutSchoolLabel.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    aboutSchoolLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17.0];
    [scrollView addSubview:aboutSchoolLabel];
    
    aboutSchoolTextField = [[UITextField alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(aboutSchoolLabel.frame) + marginY, width, height)];
    //aboutSchoolTextField.backgroundColor = [UIColor whiteColor];
    aboutSchoolTextField.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    aboutSchoolTextField.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17.0];
    //    aboutSchoolTextField.placeholder = [UserSetting UserOrganization];
    aboutSchoolTextField.enabled = NO;
    aboutSchoolTextField.leftView = [[UIView alloc] initWithFrame:textFieldPaddingRect];
    aboutSchoolTextField.leftViewMode = UITextFieldViewModeAlways;
    //    [aboutSchoolTextField.layer setBorderColor:[self UIColorFromRGB:200 green:199 blue:198 alpha:100].CGColor];
    //    [aboutSchoolTextField.layer setBorderWidth:1];
    //    [aboutSchoolTextField.layer setCornerRadius:3];
    //    [aboutSchoolTextField.layer setMasksToBounds:YES];
    [scrollView addSubview:aboutSchoolTextField];
    
    aboutHabitancyLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(aboutSchoolTextField.frame) + sectionY, width, 32)];
    aboutHabitancyLabel.text = @"居住地";
    aboutHabitancyLabel.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    aboutHabitancyLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17.0];
    [scrollView addSubview:aboutHabitancyLabel];
    
    aboutHabitancyTextField = [[UITextField alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(aboutHabitancyLabel.frame) + marginY, width, height)];
    [aboutHabitancyTextField setDelegate:self];
    aboutHabitancyTextField.backgroundColor = [UIColor whiteColor];
    aboutHabitancyTextField.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    aboutHabitancyTextField.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16.0];
    aboutHabitancyTextField.leftView = [[UIView alloc] initWithFrame:textFieldPaddingRect];
    aboutHabitancyTextField.leftViewMode = UITextFieldViewModeAlways;
    [aboutHabitancyTextField.layer setBorderColor:[self UIColorFromRGB:200 green:199 blue:198 alpha:100].CGColor];
    [aboutHabitancyTextField.layer setBorderWidth:1];
    [aboutHabitancyTextField.layer setCornerRadius:3];
    [aboutHabitancyTextField.layer setMasksToBounds:YES];
    [scrollView addSubview:aboutHabitancyTextField];
    
    aboutConversationLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(aboutHabitancyTextField.frame) + sectionY, width, height)];
    aboutConversationLabel.text = @"關於我";
    aboutConversationLabel.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    aboutConversationLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17.0];
    
    aboutConversationTextView = [[UITextView alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(aboutConversationLabel.frame) + marginY, width, height * 2.5)];
    aboutConversationTextView.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    aboutConversationTextView.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16.0];
    [aboutConversationTextView.layer setBorderColor:[self UIColorFromRGB:200 green:199 blue:198 alpha:100].CGColor];
    [aboutConversationTextView.layer setBorderWidth:1];
    [aboutConversationTextView.layer setCornerRadius:3];
    [aboutConversationTextView.layer setMasksToBounds:YES];
    [aboutConversationTextView setDelegate:self];
    [scrollView addSubview:aboutConversationLabel];
    [scrollView addSubview:aboutConversationTextView];
    
    aboutPassionLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(aboutConversationTextView.frame) + sectionY, width, height)];
    aboutPassionLabel.text = @"現在熱衷的事情";
    aboutPassionLabel.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    aboutPassionLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17.0];
    [scrollView addSubview:aboutPassionLabel];
    
    aboutPassionTextView = [[UITextView alloc] initWithFrame:
                            CGRectMake(marginX, CGRectGetMaxY(aboutPassionLabel.frame) + marginY, width, height  *2.5)];
    aboutPassionTextView.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    aboutPassionTextView.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16.0];
    [aboutPassionTextView setDelegate:self];
    [aboutPassionTextView.layer setBorderColor:[self UIColorFromRGB:200 green:199 blue:198 alpha:100].CGColor];
    [aboutPassionTextView.layer setBorderWidth:1];
    [aboutPassionTextView.layer setCornerRadius:3];
    [aboutPassionTextView.layer setMasksToBounds:YES];
    [scrollView addSubview:aboutPassionTextView];
    
    aboutExpertiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(aboutPassionTextView.frame) + sectionY, width, height)];
    aboutExpertiseLabel.text = @"專精的事情";
    aboutExpertiseLabel.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    aboutExpertiseLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17.0];
    [scrollView addSubview:aboutExpertiseLabel];
    
    aboutExpertiseTextView = [[UITextView alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(aboutExpertiseLabel.frame) + marginY, width, height * 2.5)];
    aboutExpertiseTextView.textColor = [self UIColorFromRGB:74 green:74 blue:74 alpha:100];
    aboutExpertiseTextView.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16.0];
    [aboutExpertiseTextView setDelegate:self];
    [aboutExpertiseTextView.layer setBorderColor:[self UIColorFromRGB:200 green:199 blue:198 alpha:100].CGColor];
    [aboutExpertiseTextView.layer setBorderWidth:1];
    [aboutExpertiseTextView.layer setCornerRadius:3];
    [aboutExpertiseTextView.layer setMasksToBounds:YES];
    [scrollView addSubview:aboutExpertiseTextView];
    
    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(aboutExpertiseTextView.frame) + 80);
    
    
    
    
    self.pickerViewHoroscope = [[UIPickerView alloc] init];
    self.pickerViewHoroscope.delegate = self;
    self.pickerViewHoroscope.dataSource = self;
    aboutHoroscopeTextField.inputView = self.pickerViewHoroscope;
    
    self.pickerViewAddress = [[UIPickerView alloc] init];
    self.pickerViewAddress.delegate = self;
    self.pickerViewAddress.dataSource = self;
    aboutHabitancyTextField.inputView = self.pickerViewAddress;
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.barTintColor = [UIColor lightGrayColor];
    toolbar.translucent = NO;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(touchViewToReturn)];
    UIBarButtonItem *flexibleSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[flexibleSeparator, doneButton];
    aboutHoroscopeTextField.inputAccessoryView = toolbar;
    aboutHabitancyTextField.inputAccessoryView = toolbar;
    horoscpoeArray = [[NSArray alloc] initWithObjects:@"牡羊", @"金牛", @"雙子", @"巨蟹", @"獅子", @"處女", @"天秤", @"天蠍", @"射手", @"摩羯", @"水瓶", @"雙魚", nil];
    //    白羊宮（Aries, ♈）
    //    金牛宮（Taurus, ♉）
    //    雙子宮（Gemini, ♊）
    //    巨蟹宮（Cancer, ♋）
    //    獅子宮（Leo, ♌）
    //    處女宮（Virgo, ♍）
    //    天秤宮（Libra, ♎）
    //    天蠍宮（Scorpio, ♏）
    //    蛇夫宮（Ophiuchus, Ophiuchus zodiac.svg）
    //    人馬宮（Sagittarius, ♐）
    //    摩羯宮（Capricornus, ♑）
    //    水瓶宮（Aquarius, ♒）
    //    雙魚宮（Pisces, ♓）
    
    addressArray = [[NSArray alloc] initWithObjects:@"基隆", @"臺北", @"新北", @"桃園", @"新竹", @"苗栗", @"臺中", @"彰化", @"南投", @"雲林", @"嘉義", @"臺南", @"高雄", @"屏東", @"宜蘭", @"花蓮", @"臺東", @"連江", @"金門", @"澎湖", nil];
    
    
    UselessView *uselessView = [[UselessView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, 50) withMessage:@"新增更多個人資訊～讓對的人找到你！"];
    
    [self.view addSubview:uselessView];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Submit

- (void)submitMethod {
    
    // 檢查名字可不可用
    if (nameIsOk) {
        
        // 開始上傳
        self.loadingView = [[LoadingView alloc] init];
        self.loadingView.loadingString = @"上傳中";
        self.loadingView.finishedString = @"成功";
        [self.loadingView start];
        
        // 檢查使用者
        [ColorgyChatAPI checkUserAvailability:^(ChatUser *chatUser) {
            
            // Update about
            [ColorgyChatAPI updateAbout:chatUser.userId horoscope:aboutHoroscopeTextField.text school:aboutSchoolTextField.text habitancy:aboutHabitancyTextField.text conversation:aboutConversationTextView.text passion:aboutPassionTextView.text expertise:aboutExpertiseTextView.text success:^() {
            } failure:^() {
                NSLog(@"updateabout error");
                // 使用者檢查失敗，尚未註冊或是網路連線不正常，通常為後者
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"儲存失敗Q_Q" message:@"請網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
            
            // Update name
            [ColorgyChatAPI updateName:nameTextField.text userId:chatUser.userId success:^() {
                [self.loadingView finished:^() {}];
                [ColorgyChatAPI updateFromCore:^() {
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^() {
                    NSLog(@"updatefrom core error");
                    [self.loadingView finished:^() {}];
                }];
            } failure:^() {
                NSLog(@"update name error");
                // 上傳名字失敗
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"儲存失敗Q_Q" message:@"請網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
        } failure:^() {
            NSLog(@"check use error");
            // 使用者檢查失敗，尚未註冊或是網路連線不正常，通常為後者
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"儲存失敗Q_Q" message:@"請網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
        
        // 結束Loading
        [self.loadingView finished:^() {}];
    } else {
        
        // 名字是重複的
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"名字不可用Q_Q" message:@"請換個新名字吧！！" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
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

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
    
    if (textField == nameTextField) {
        [self dismissCheck];
        textNumberCounterLabel.text = [NSString stringWithFormat:@"%ld/8", [self stringCounter:nameTextField.text] / 2];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.activeTextField = nil;
    
    if (textField == nameTextField) {
        [self dismissCheck];
        nameTextField.text = [self stringCounterTo:nameTextField.text number:16];
        
        // 檢查名字 尚需修改
        if (nameTextField.text.length) {
            [self showChecking];
            if ([nameTextField.text isEqualToString:userInformation.name]) {
                [self showCheck];
                return YES;
            }
            [ColorgyChatAPI checkNameExists:nameTextField.text success:^(NSString *status) {
                if ([status isEqualToString:@"ok"]) {
                    [self showCheck];
                } else {
                    [self dismissCheck];
                }
            } failure:^() {
                NSLog(@"check name exists");
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"傳輸失敗Q_Q" message:@"請網路連線是否正常" preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
        }
    }
    return YES;
}

#pragma mark - UITextFieldTextDidChangeNotification

- (void)registerForUITextFieldTextDidChangeNotification {
    // UITextFieldTextDidChangeNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:)name:@"UITextFieldTextDidChangeNotification" object:nil];
}

- (void)textChange:(NSNotification *)noti {
    if (nameTextField.markedTextRange) {
        return;
    }
    if (self.activeTextField == nameTextField) {
        NSString *string = nameTextField.text;
        
        if ([self stringCounter:string] > 10) {
            nameTextField.text = [self stringCounterTo:string number:16];
        }
        textNumberCounterLabel.text = [NSString stringWithFormat:@"%ld/8", [self stringCounter:nameTextField.text] / 2];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.activeTextView = textView;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.activeTextView = textView;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.activeTextView = nil;
}

#pragma mark - CheckView

- (void)showChecking {
    checkingView = [[UIActivityIndicatorView alloc] initWithFrame:checkedView.frame];
    
    [checkingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [checkingView startAnimating];
    [textNumberCounterLabel removeFromSuperview];
    [checkedView removeFromSuperview];
    [nameTextField addSubview:checkingView];
    nameIsOk = YES;
}

- (void)showCheck {
    [checkingView removeFromSuperview];
    [textNumberCounterLabel removeFromSuperview];
    [nameTextField addSubview:checkedView];
    nameIsOk = YES;
}

- (void)dismissCheck {
    [checkingView removeFromSuperview];
    [checkedView removeFromSuperview];
    [nameTextField addSubview:textNumberCounterLabel];
    nameIsOk = NO;
}

#pragma mark - UploadButtonAction

- (void)showPhotoMeunAlert {
    // UIAlertController AnctionSheetStyle Initializing
    UIAlertController *photoMeunAlertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [photoMeunAlertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    //    [photoMeunAlertController addAction:[UIAlertAction actionWithTitle:@"使用FB大頭照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    //
    //        // FBImageSticker button tapped.
    //        [self dismissViewControllerAnimated:YES completion:^{
    //        }];
    //        [self removeUploadLayout];
    //        [self uploadPreviewLayout];
    //        UIActivityIndicatorView *indView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //        [indView startAnimating];
    //        indView.center = CGPointMake(self.userImageView.bounds.size.width / 2, self.userImageView.bounds.size.height / 2);
    //        [userImageView addSubview:indView];
    //        [self downloadImageAtURL:[UserSetting UserAvatarUrl] withHandler:^(UIImage *image) {
    //            self.uploadImage = image;
    //            dispatch_sync(dispatch_get_main_queue(), ^{
    //                self.userImageView.image = [image gaussianBlurImage:image andInputRadius:4];
    //                [indView removeFromSuperview];
    //                [self.userImageView setNeedsLayout];
    //            });
    //        }];
    //    }]];
    [photoMeunAlertController addAction:[UIAlertAction actionWithTitle:@"從相簿選擇" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // PhotoAlbumr button tapped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        [self openPhotoLibrary];
    }]];
    [photoMeunAlertController addAction:[UIAlertAction actionWithTitle:@"拍攝照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // TakePhoto button tapped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        [self openPhotoCamera];
    }]];
    [self presentViewController:photoMeunAlertController animated:YES completion:nil];
}

- (void)openPhotoLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        UIAlertController *alertError = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"存取相簿失敗" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertError addAction:[UIAlertAction actionWithTitle:@"好吧..." style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }]];
        [self presentViewController:alertError animated:YES completion:nil];
    }
}

- (void)openPhotoCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        UIAlertController *alertError = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"存取相機失敗" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertError addAction:[UIAlertAction actionWithTitle:@"好吧..." style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }]];
        [self presentViewController:alertError animated:YES completion:nil];
    }
}

#pragma mark - ImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.loadingView = [[LoadingView alloc] init];
    self.loadingView.loadingString = @"上傳中";
    self.loadingView.finishedString = @"成功";
    [self.loadingView start];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    self.uploadImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.uploadImage = [self reSizeImage:self.uploadImage toSize:CGSizeMake(512, 512)];
    userImageView.image = [self.uploadImage gaussianBlurImage:self.uploadImage andInputRadius:4];
    ColorgyChatAPIOC *chatapioc = [[ColorgyChatAPIOC alloc] init];
    // 這裡上傳
    CGRect chopRect = CGRectMake(0, 0, self.uploadImage.size.width, self.uploadImage.size.height);
    
    [chatapioc patchUserImage:self.uploadImage chopRect:chopRect success:^(NSDictionary *response) {
        NSLog(@"%@", [response valueForKey:@"avatar_url"]);
        [self.loadingView finished:^() {}];
        [ColorgyChatAPI updateFromCore:^() {
            [self.loadingView finished:^() {}];
        } failure:^() {
            NSLog(@"update from core error");
            [self.loadingView finished:^() {}];
        }];
    } failure:^() {
        NSLog(@"patch user image error");
        [self.loadingView finished:^() {}];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"imagePickerControllerDidCancel");
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UIImage Resize

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize {
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

#pragma mark - UIColor

- (UIColor *)UIColorFromRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:(alpha / 100)];
}

#pragma mark - TouchViewToReturn

- (void)touchViewToReturn {
    if (self.activeTextField == aboutHoroscopeTextField) {
        aboutHoroscopeTextField.text = [horoscpoeArray objectAtIndex:[self.pickerViewHoroscope selectedRowInComponent:0]];
    } else if (self.activeTextField == aboutHabitancyTextField) {
        aboutHabitancyTextField.text = [addressArray objectAtIndex:[self.pickerViewAddress selectedRowInComponent:0]];
    }
    [self.activeTextField resignFirstResponder];
    [self.activeTextView resignFirstResponder];
}

#pragma mark - KeyboardNotifications

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + statusBarSize.height, 0.0);
    
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.bounds;
    
    aRect.size.height -= kbSize.height;
    aRect.size.height -= statusBarSize.height;
    
    NSLog(@"%f", ([UIApplication sharedApplication].statusBarFrame.size.height));
    
    if (CGRectGetMaxY(self.activeTextField.frame) > CGRectGetMaxY(self.activeTextView.frame)) {
        if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, self.activeTextField.frame.origin.y - kbSize.height - statusBarSize.height + 90);
            [scrollView setContentOffset:scrollPoint animated:YES];
        }
    } else {
        if (!CGRectContainsPoint(aRect, self.activeTextView.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, CGRectGetMaxY(self.activeTextView.frame) - kbSize.height + 60 - statusBarSize.height);
            [scrollView setContentOffset:scrollPoint animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

@end
