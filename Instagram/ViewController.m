//
//  ViewController.m
//  Instagram
//
//  Created by Ramakrishna Makkena on 2/19/15.
//  Copyright (c) 2015 nwmissouri. All rights reserved.
//

#import "ViewController.h"

#define TAGS @"selfie"
#define KAUTHURL @"https://api.instagram.com/oauth/authorize/"
#define kAPIURl @"https://api.instagram.com/v1/users/"
#define KACCESS_TOKEN @"6874212.436eb0b.9768fd326f9b423eab7dd260972ee6db"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _imageData = [[NSData alloc] init];
    _responseDic = [[NSMutableDictionary alloc] init];
    
    _imageScrollView = [[UIScrollView alloc] initWithFrame: self.view.frame];
    [_imageScrollView setBackgroundColor:[UIColor whiteColor]];
    
    
    // UITapGestureRecognizer configurations for single tap and double tap
    
    UITapGestureRecognizer *tapOnce =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapOnce:)];
    UITapGestureRecognizer *tapTwice =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapTwice:)];
    
    tapOnce.numberOfTapsRequired = 1;
    tapTwice.numberOfTapsRequired = 2;
    
    [tapOnce requireGestureRecognizerToFail:tapTwice];
    
    [_imageScrollView addGestureRecognizer:tapOnce];
    [_imageScrollView addGestureRecognizer:tapTwice];
    
    // Setting scrollview properties
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 70, self.view.frame.size.width, self.view.frame.size.height)];
    
    [_scrollView setScrollEnabled:YES];
    [_scrollView setShowsVerticalScrollIndicator:YES];
    [_scrollView setBackgroundColor:[UIColor grayColor]];
    
    [self getInstagramData];
    
    [self.view addSubview:_scrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

// Fetches the data from instagram api

-(void)getInstagramData{
    
    NSString *apiURL = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?access_token=%@", TAGS, KACCESS_TOKEN];
    
    NSURL *url = [NSURL URLWithString:apiURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *err;
    
    _responseDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
    
    [self showImages];
}

// Displays the images in grid view with thumbnails

-(void)showImages
{
    int y = 0;
    
    NSString *imageUrl;
    int x = 0;
    
    
    for (int i = 0; i<[[_responseDic objectForKey:@"data"] count]; i++) {
        
        if (i%2 == 0)
            x = 15;
        else
            x = 190;
        
        y = i/2 * 160 + 15;
        
        imageUrl = [[[[[_responseDic objectForKey:@"data"] objectAtIndex:i] objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"url"];
        
        int height = [[[[[[_responseDic objectForKey:@"data"] objectAtIndex:i] objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"height"] intValue];
        
        int width = [[[[[[_responseDic objectForKey:@"data"] objectAtIndex:i] objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"width"] intValue];
        
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
        
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, height, width)];
        [imageButton setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
        [imageButton setTag:i];
        [imageButton addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [_scrollView addSubview:imageButton];
        
    }
    
    
    
    [_scrollView setContentSize:CGSizeMake(320, y+250)];
}


// Action method which displays the image in standard resolutions when the thumbnail is tapped

-(void)tapped:(id)sender
{
    
    NSString *imageUrl = [[[[[_responseDic objectForKey:@"data"] objectAtIndex:[sender tag]] objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"];
    _imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150, 30, 80, 40)];
    [label setText:@"#selfie"];
    [label setFont:[UIFont fontWithName:@"Gill Sans" size:30]];
    
    _myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 340, 340)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(150, 500, 80, 40)];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [_myImageView setImage:[UIImage imageWithData:_imageData]];
    
    [_imageScrollView setContentSize:_myImageView.image.size];
    [_imageScrollView addSubview:label];
    [_imageScrollView addSubview:_myImageView];
    [_imageScrollView addSubview:button];
    
    [_imageScrollView setMaximumZoomScale:3.0f];
    [_imageScrollView setMinimumZoomScale:0.1f];
    
    
    [self.view addSubview:_imageScrollView];
    
}


#pragma mark - IBActions
// Action method for done button

-(void)done:(id)sender
{
    [_imageScrollView removeFromSuperview];
}

// Method will be invoked when the view is tapped once

- (void)tapOnce:(UIGestureRecognizer *)gesture
{
    [_myImageView removeFromSuperview];
    
    [_myImageView setFrame:CGRectMake(-100, -50, 680, 680)];
    [_myImageView setImage:[UIImage imageWithData:_imageData]];
    
    [_imageScrollView setContentSize:CGSizeMake(680, 680)];
    [_imageScrollView addSubview:_myImageView];
}

// Method will be invoked when the view is tapped twice

- (void)tapTwice:(UIGestureRecognizer *)gesture
{
    [_myImageView removeFromSuperview];
    
    [_myImageView setFrame:CGRectMake(10, 100, 340, 340)];
    [_myImageView setImage:[UIImage imageWithData:_imageData]];
    
    [_imageScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    [_imageScrollView addSubview:_myImageView];
    
}

@end







