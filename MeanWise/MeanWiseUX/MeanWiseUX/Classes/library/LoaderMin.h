//
//  LoaderMin.h
//  MeanWiseUX
//
//  Created by Hardik on 14/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoaderMin : UIView
{
    
    UIImageView *img1;
    UIImageView *img2;
    UIImageView *img3;

    UIImageView *shadow;
    
    int state;

}
-(void)setUp;
-(void)startAnimation;

@end

/*
 /    LoaderMin *min=[[LoaderMin alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
 //    [self.view addSubview:min];
 //    [min setUp];
 //    min.center=CGPointMake(100, 200);

*/