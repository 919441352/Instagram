//
//  ViewController.h
//  Instagram
//
//  Created by Ramakrishna Makkena on 2/19/15.
//  Copyright (c) 2015 nwmissouri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate>

@property NSMutableDictionary *responseDic;
@property UIScrollView *scrollView;
@property UIScrollView *imageScrollView;
@property UIView *myView;
@property UIImageView *myImageView;
@property NSData *imageData;


@end

