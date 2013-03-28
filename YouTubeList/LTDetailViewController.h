//
//  LTDetailViewController.h
//  YouTubeList
//
//  Created by SalesTech on 3/27/13.
//  Copyright (c) 2013 SalesTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
