//
//  ShareBtn.m
//  ShareMenu
//
//  Created by Hardik on 01/02/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "ShareDialogue.h"

@implementation ShareDialogue

-(void)setOriginPoint:(CGPoint)point
{
    originPoint=point;
}
-(void)setUpAll:(int)directly
{
 
    
    shareDirectly=directly;
    
    btnArrays=[[NSMutableArray alloc] init];
    
    NSArray *array=[[NSArray alloc] initWithObjects:@"SM_email",@"SM_facebook",@"SM_twitter",@"SM_copytoclipboard",@"SM_sms", nil];

    NSArray *titleArray=[[NSArray alloc] initWithObjects:@"Email",@"Facebook",@"Twitter",@"Copy",@"SMS", nil];

    
    for(int i=0;i<[array count];i++)
    {
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self addSubview:button];
        
   // [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[array objectAtIndex:i]] forState:UIControlStateNormal];
        
        [btnArrays addObject:button];
        
        button.layer.cornerRadius=25;
        
        button.center=originPoint;
        
        button.transform=CGAffineTransformMakeRotation(M_1_PI);
        
        button.alpha=0;
        
        button.tag=i;

        [button addTarget:self action:@selector(shareItem:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label=[[UILabel alloc] initWithFrame:button.frame];
        [button addSubview:label];
        label.center=CGPointMake(30, 80);
        label.text=[titleArray objectAtIndex:i];
        label.textColor=[UIColor blackColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont fontWithName:@"Avenir-Black" size:12];

    }
    self.backgroundColor=[UIColor colorWithWhite:1 alpha:0];

    if(shareDirectly==0)
    {
    [self setLayoutCustom];
    }
    isActive=true;

    
}
-(void)setLayoutCustom
{
    
    int width=self.frame.size.width;
    
    int btnsize=width/([btnArrays count]*2);
    
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.backgroundColor=[UIColor colorWithWhite:1 alpha:0.9];
        
        for(int i=0;i<[btnArrays count];i++)
        {
            UIButton *button=(UIButton *)[btnArrays objectAtIndex:i];
            
            button.center=CGPointMake(btnsize*i*2+btnsize, self.frame.size.height/2);
            button.transform=CGAffineTransformMakeRotation(0);
            
            button.alpha=1;
        }
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    
}
-(void)setUpViewController:(UIViewController *)viewcont;
{
    controller=viewcont;
}

#pragma mark - Direct post
-(void)shareDirectly_Email
{
    shareDirectly=1;
    UIButton *button=[[UIButton alloc] init];
    button.tag=0;
    [self shareItem:button];
}
-(void)shareDirectly_Facebook
{
    shareDirectly=1;
    UIButton *button=[[UIButton alloc] init];
    button.tag=1;
    [self shareItem:button];
}
-(void)shareDirectly_Twitter
{
    shareDirectly=1;
    UIButton *button=[[UIButton alloc] init];
    button.tag=2;
    [self shareItem:button];
}
-(void)shareDirectly_Copy
{
    shareDirectly=1;
    UIButton *button=[[UIButton alloc] init];
    button.tag=3;
    [self shareItem:button];
}
-(void)shareDirectly_SMS
{
    shareDirectly=1;
    UIButton *button=[[UIButton alloc] init];
    button.tag=4;
    [self shareItem:button];
}
#pragma mark - General post

-(void)closeDirectly
{
    if(shareDirectly==1)
    {
        [self dismissThisShareDialogue];
    }
}
-(void)shareItem:(UIButton *)btn
{
    int tag=(int)btn.tag;
    
    if(tag==0) //Email
    {
        
        
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
            mail.mailComposeDelegate = self;
            [mail setMessageBody:emailInstance.emailBody isHTML:NO];
    
            NSData *jpegData = UIImageJPEGRepresentation(emailInstance.imageAttachment, 1.0);
            
            NSString *fileName = @"Attachment.jpeg";
            fileName = [fileName stringByAppendingPathExtension:@"jpeg"];
            [mail addAttachmentData:jpegData mimeType:@"image/jpeg" fileName:fileName];

            
            [mail setSubject:emailInstance.emailTitle];
            [controller presentViewController:mail animated:YES completion:nil];
           

  //          [controller presentViewController:mail animated:YES completion:NULL];
//            [mail dismissPopoverAnimated:YES];

        }
        else
        {
            [self showAlertWithTitle:@"Sorry!" andMessage:@"You can't post right now, make sure your device has an internet connection and you have at least Email account setup."];
            [self closeDirectly];
        }
      
       
        
    }
    else if(tag==1) //fb
    {
       
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            SLComposeViewController *fbPostSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [fbPostSheet setInitialText:fbInstance.contentTitle];
            
            [fbPostSheet setCompletionHandler:^(SLComposeViewControllerResult result){
                NSLog(@"Completion handler = %li", (long)result);
                [controller dismissViewControllerAnimated:YES completion:nil];
                if (result == SLComposeViewControllerResultCancelled)
                {
                    [self closeDirectly];
                    
                    NSLog(@"The user cancelled.");
                }
                else if (result == SLComposeViewControllerResultDone)
                {
                    [self closeDirectly];
                    
                    [self showAlertWithTitle:@"Success!" andMessage:@"Tweet Posted!"];
                }
            }];
            
            [controller presentViewController:fbPostSheet animated:YES completion:nil];
            
            
            
            
        }
        else
        {
            [self closeDirectly];
            
            [self showAlertWithTitle:@"Sorry!" andMessage:@"You can't post right now, make sure your device has an internet connection and you have at least one Twitter account setup."];
            
            
            
        }

        
        
    }
    else if(tag==2) //twitter
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *fbPostSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [fbPostSheet setInitialText:twitInsance.textToShare];
            [fbPostSheet addURL:[NSURL URLWithString:twitInsance.urlStringToShare]];
            [fbPostSheet addImage:twitInsance.imageToShare];
            
            [fbPostSheet setCompletionHandler:^(SLComposeViewControllerResult result){
                NSLog(@"Completion handler = %li", (long)result);
                                [controller dismissViewControllerAnimated:YES completion:nil];
                if (result == SLComposeViewControllerResultCancelled)
                {
                    [self closeDirectly];

                    NSLog(@"The user cancelled.");
                }
                else if (result == SLComposeViewControllerResultDone)
                {
                    [self closeDirectly];

                    [self showAlertWithTitle:@"Success!" andMessage:@"Tweet Posted!"];
                }
            }];
            
            [controller presentViewController:fbPostSheet animated:YES completion:nil];
            
            
            
            
        }
        else
        {
            [self closeDirectly];

            [self showAlertWithTitle:@"Sorry!" andMessage:@"You can't post right now, make sure your device has an internet connection and you have at least one Twitter account setup."];

            

        }
        
    }
    else if(tag==3) //copy
    {
        NSString *copyStringverse = clipBoardInstance.clipBoardText;
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:copyStringverse];
        
        [self showAlertWithTitle:@"Success!" andMessage:@"Text Copied."];
        [self closeDirectly];

    }
    else if(tag==4) //sms
    {
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            messageController.body = smsInstance.smsText;
           // messageController.recipients = [NSArray arrayWithObjects:@"1(234)567-8910", nil];
            messageController.messageComposeDelegate = self;
            
            
            if(smsInstance.imageAttachment!=nil)
            {
            NSData *imgData = UIImageJPEGRepresentation(smsInstance.imageAttachment, 1.0);
            
    
           
            BOOL didAttachImage=[messageController addAttachmentData:imgData typeIdentifier:@"image/jpg" filename:@"Tangotab.jpg"];
                
                if (didAttachImage) {
                    NSLog(@"Image Attached.");
                    
                } else {
                    NSLog(@"Image Could Not Be Attached.");
                }

            
            }
            [controller presentViewController:messageController animated:YES completion:nil];

            
            
        }
        else
        {
            [self closeDirectly];

            [self showAlertWithTitle:@"Sorry!" andMessage:@"SMS not supported"];
        }

    }
    
    

}


#pragma mark - Direct close

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller1 didFinishWithResult:(MessageComposeResult)result;
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    switch (result) {
        case MessageComposeResultSent:
            [self showAlertWithTitle:@"Success!" andMessage:@"SMS sent."];
            
            break;
        case MessageComposeResultCancelled:
            //  [self showAlertWithTitle:@"Error!" andMessage:@"SMS cancelled."];
            
            break;
            
        case MessageComposeResultFailed:
            [self showAlertWithTitle:@"Sorry!" andMessage:@"SMS Failed."];
            
            break;
            
        default:
            break;
    }
    [self closeDirectly];

    
}
- (void)mailComposeController:(MFMailComposeViewController *)controller1 didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    switch (result) {
        case MFMailComposeResultSent:
            [self showAlertWithTitle:@"Success!" andMessage:@"Email sent."];
            
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            [self showAlertWithTitle:@"" andMessage:@"Draft saved."];
            
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            //    [self showAlertWithTitle:@"" andMessage:@"Email cancelled."];
            break;
        case MFMailComposeResultFailed:
            [self showAlertWithTitle:@"Mail Failed" andMessage:@"An error occurred when trying to compose this email"];
            
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            [self showAlertWithTitle:@"Mail Failed" andMessage:@"An error occurred when trying to compose this email"];
            
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    [self closeDirectly];

}


#pragma mark - Dismiss manually
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissThisShareDialogue];
    
}
-(void)dismissThisShareDialogue
{
    if(isActive)
    {
        [self HideItWithAnimation];
        isActive=false;
    }
    
}
-(void)HideItWithAnimation
{
    
    
    
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.backgroundColor=[UIColor colorWithWhite:1 alpha:0];
        
        for(int i=0;i<[btnArrays count];i++)
        {
            UIButton *button=(UIButton *)[btnArrays objectAtIndex:i];
            
            button.center=originPoint;
            button.transform=CGAffineTransformMakeRotation(M_1_PI);
            
            button.alpha=0;
            
        }
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}
#pragma mark - Other
-(void)setVariables
{
}
-(void)viewOpen
{
}
-(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //Handel no, thanks button
                                   
                               }];
    
    [alert addAction:noButton];
    
    [controller presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - Objects
-(void)setFBInstance:(SHARE_fbObject *)obj
{
    fbInstance=obj;
}
-(void)setTwitterInstance:(SHARE_twitterObject *)obj
{
    twitInsance=obj;
}
-(void)setEmailInstance:(SHARE_emailObject *)obj
{
    emailInstance=obj;
}
-(void)setSMSInstance:(SHARE_smsObject *)obj
{
    smsInstance=obj;
}
-(void)setClipBoardInstance:(SHARE_clipBoardObject *)obj
{
    clipBoardInstance=obj;
}



@end

