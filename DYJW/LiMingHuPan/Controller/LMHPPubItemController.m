//
//  LMHPPubItemController.m
//  DYJW
//
//  Created by 风筝 on 16/5/16.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "LMHPPubItemController.h"
#import "MDTextField.h"
#import "MDFlatButton.h"
#import "MDAlertView.h"
#import "AFNetworking.h"
#import "UserInfo.h"
#import "AddImageCell.h"
#import "ZYQAssetPickerController.h"
#import <AVFoundation/AVFoundation.h>

@interface LMHPPubItemController () <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ZYQAssetPickerControllerDelegate>
@property (strong, nonatomic) MDTextField *titleField;
@property (strong, nonatomic) UITextView *desc;
@property (strong, nonatomic) UILabel *descPlaceholder;
@property (strong, nonatomic) MDFlatButton *pubButton;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *imageArray;
@end

@implementation LMHPPubItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageArray = [NSMutableArray array];
    [self createView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardNotification:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardNotification:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardNotification:(NSNotification *)notification {
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        // 即将显示键盘
        NSDictionary *info = notification.userInfo;
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        [self setViewFrames:kbSize.height];
    } else if ([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        //即将隐藏键盘
        [self setViewFrames:0];
    }
}

- (void)setViewFrames:(CGFloat)keyboardHeight {
    [UIView animateWithDuration:0.2 animations:^{
        self.desc.frame = CGRectMake(ViewX(self.desc), ViewY(self.desc), ViewWidth(self.desc), ScreenHeight - 76 - ViewHeight(self.titleField) - keyboardHeight - ViewHeight(self.pubButton) - ViewHeight(self.collectionView));
        self.pubButton.frame = CGRectMake(0, ScreenHeight - 76 - 48 - keyboardHeight, ScreenWidth, 48);
        self.collectionView.frame = CGRectMake(0, ScreenHeight - 76 - ViewHeight(self.pubButton) - 64 - keyboardHeight, ScreenWidth, 64);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createView {
    self.view.backgroundColor = [MDColor grey50];
    
    MDTextField *title = [[MDTextField alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 48)];
    title.hasPadding = YES;
    title.placeholder = @"物品标题";
    [self.view addSubview:title];
    self.titleField = title;
    
    MDFlatButton *button = [MDFlatButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"发布" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, ScreenHeight - 76 - 48, ScreenWidth, 48);
    [button addTarget:self action:@selector(pubItem) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.pubButton = button;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, ViewWidth(button), 1);
    layer.backgroundColor = [MDColor grey300].CGColor;
    [button.layer addSublayer:layer];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
    layout.itemSize = CGSizeMake(50, 50);
    layout.minimumLineSpacing = 8;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 76 - ViewHeight(button) - 64, ScreenWidth, 64) collectionViewLayout:layout];
    collectionView.backgroundColor = [MDColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[AddImageCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    UITextView *desc = [[UITextView alloc] initWithFrame:CGRectMake(12, ViewHeight(title) + 12, ScreenWidth - 24, ScreenHeight - 76 - ViewHeight(title) - ViewHeight(button) - ViewHeight(collectionView))];
    desc.font = [UIFont systemFontOfSize:16];
    desc.textColor = [MDColor grey800];
    desc.delegate = self;
    desc.backgroundColor = [MDColor clearColor];
    desc.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:desc];
    self.desc = desc;
    
    UILabel *holder = [[UILabel alloc] initWithFrame:CGRectMake(16, ViewY(desc) + 1, ViewWidth(desc), 18)];
    holder.text = @"物品描述（物品详情以及联系方式等）";
    holder.font = [UIFont systemFontOfSize:16];
    holder.textColor = [MDColor grey500];
    [self.view addSubview:holder];
    self.descPlaceholder = holder;
}

#pragma mark - ColletionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count == 9 ? 9 : self.imageArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AddImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.image = indexPath.row == self.imageArray.count ? nil : self.imageArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.imageArray.count) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"添加图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
        sheet.tag = 0x1000;
        [sheet showInView:self.view];
        [self.view endEditing:YES];
    } else {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"删除图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除图片" otherButtonTitles:nil];
        sheet.tag = 0x2000 + indexPath.row;
        [sheet showInView:self.view];
    }
}

#pragma mark - ActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 0x1000) {
        if (buttonIndex == 0) {
            // 拍照
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus ==AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleDialog];
                alertView.message = @"请在“设置-东油教务”中开启东油教务访问相机的权限";
                [alertView setPositiveButton:@"好的" andAction:nil];
                [alertView show];
                return;
            } else {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.delegate = self;
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:controller animated:YES completion:nil];
            }
        } else if (buttonIndex == 1) {
            // 相册
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if (author == AVAuthorizationStatusRestricted || author ==AVAuthorizationStatusDenied) {
                MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleDialog];
                alertView.message = @"请在“设置-东油教务”中开启东油教务访问相册的权限";
                [alertView setPositiveButton:@"好的" andAction:nil];
                [alertView show];
                return;
            } else {
                ZYQAssetPickerController *controller = [[ZYQAssetPickerController alloc] init];
                controller.maximumNumberOfSelection = 9 - self.imageArray.count;
                controller.minimumNumberOfSelection = 1;
                controller.isFinishDismissViewController = YES;
                controller.delegate = self;
                [self presentViewController:controller animated:YES completion:nil];
            }
        }
    } else if (actionSheet.tag > 0x2000) {
        if (buttonIndex == 0) {
            // 删除照片
            [self.imageArray removeObjectAtIndex:actionSheet.tag - 0x2000];
            [self.collectionView reloadData];
        }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    dispatch_queue_t queue = dispatch_queue_create("compress", NULL);
    dispatch_async(queue, ^{
        UIImage *image = [self compressImage:info[UIImagePickerControllerOriginalImage]];
        image = [self compressImage:image];
        [self.imageArray addObject:image];
        [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    });
}

- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    //    [self.imageArray removeAllObjects];
    dispatch_queue_t queue = dispatch_queue_create("compress", NULL);
    dispatch_async(queue, ^{
        for (ALAsset *asset in assets) {
            UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];;
            image = [self compressImage:image];
            [self.imageArray addObject:image];
            [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    });
}

- (UIImage *)compressImage:(UIImage*)image {
    CGFloat maxWidthOrHeight = 1536;
    CGFloat width = image.size.width > image.size.height ? maxWidthOrHeight  : image.size.width * maxWidthOrHeight / image.size.height;
    CGFloat height = image.size.height > image.size.width ? maxWidthOrHeight : image.size.height * maxWidthOrHeight / image.size.width;
    CGSize newSize = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 发布物品
- (void)pubItem {
    if (self.titleField.text.length == 0) {
        MDAlertView *alert = [MDAlertView alertViewWithStyle:MDAlertViewStyleDialog];
        alert.message = @"请输入物品标题";
        [alert show];
        return;
    } else if (self.desc.text.length == 0) {
        MDAlertView *alert = [MDAlertView alertViewWithStyle:MDAlertViewStyleDialog];
        alert.message = @"请输入物品描述";
        [alert show];
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    UserInfo *user = [UserInfo userInfo];
    NSDictionary *param = @{
                            @"username" : user.username,
                            @"last_jid" : [UserInfo cookie].value,
                            @"title" : self.titleField.text,
                            @"description" : self.desc.text,
                            @"type_id" : @"1",
                            @"price" : @(123.45)
                            };
    [manager POST:@"http://dyjw.fly-kite.com/app/lmhp/post_item.aspx" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSInteger length = 0;
        for (UIImage *image in self.imageArray) {
            NSString *filename = [NSString stringWithFormat:@"image%p.jpg", image];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
            [formData appendPartWithFileData:imageData name:@"pictures" fileName:filename mimeType:@"image/jpeg"];
            length += imageData.length;
        }
        NSLog(@"contentSize=%ld", (long)length);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([json[@"code"] integerValue] == 200) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        MDAlertView *alert = [MDAlertView alertViewWithStyle:MDAlertViewStyleDialog];
        alert.message = json[@"msg"];
        [alert show];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@", error);
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    [UIView animateWithDuration:0.3 animations:^{
        self.descPlaceholder.alpha = textView.text.length == 0;
    }];
}
@end
