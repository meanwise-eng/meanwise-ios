//
//  MXToolTipView.h
//  MeanWiseUX
//
//  Created by Hardik on 08/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXToolTipView : UIView

{
    
    UIView *mainView;
    UILabel *tipLabel;
    UIView *bubbleView;
    UIView *arrowView;
    
}
-(void)setUp;
-(void)setPointDownAt:(CGPoint)point;

@end

/*


 MXToolTipView *tipView=[[MXToolTipView alloc] initWithFrame:self.view.bounds];
 [self.view addSubview:tipView];
 tipView.backgroundColor=[UIColor clearColor];
 [tipView setUp];
 tipView.center=self.view.center;

 */
