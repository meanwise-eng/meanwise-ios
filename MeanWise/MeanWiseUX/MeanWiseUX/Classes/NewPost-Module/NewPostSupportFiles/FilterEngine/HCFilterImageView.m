//
//  HCFilterImageView.m
//  Exacto
//
//  Created by Hardik on 18/07/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "HCFilterImageView.h"
#import "FTIndicator.h"



@implementation HCFilterImageView

-(void)setUp
{
    helper=[[HCFilterHelper alloc] init];
    [helper setForView:self];

    CorefilterDB=[helper setUpCoreFilterData];
    MasterFilterDB=[helper setUpMasterImageFilterData];
    
    keyImage=nil;
    


 //   keyImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://www.imore.com/sites/imore.com/files/styles/xlarge/public/field/image/2016/09/iphone-7-selfie-indoors_0.jpg?itok=oHu-Q1Ym"]]];

//    keyImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://boygeniusreport.files.wordpress.com/2015/03/s6-8.jpg?quality=98&strip=all"]]];

  //  keyImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://cdn03.androidauthority.net/wp-content/uploads/2016/10/iphone-7-camera-samples-20-of-25.jpg"]]];
    
    keyImageView=[[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:keyImageView];
    keyImageView.contentMode=UIViewContentModeScaleAspectFill;
    
    
    imageOverLay=[[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:imageOverLay];
    imageOverLay.contentMode=UIViewContentModeScaleAspectFill;
    imageOverLay.userInteractionEnabled=false;

    
    gLayer=[helper flavescentGradientLayer:[UIColor clearColor] andColor2:[UIColor clearColor] andPoints:nil];
    [imageOverLay.layer insertSublayer:gLayer atIndex:0];
    
    cFilterNo=0;

   
    
    
   /* filterListIB=[[HCFilterList alloc] initWithFrame:CGRectMake(0, self.frame.size.height-120, self.frame.size.width, 50)];
    [self addSubview:filterListIB];
    [filterListIB setUp:MasterFilterDB];
    [filterListIB setTarget:self OnFilterSelect:@selector(onFilterSelect:)];
    */
    
}
-(void)setUpPath:(NSString *)path
{
    keyImage=[UIImage imageWithContentsOfFile:path];

    //keyImage=[UIImage imageNamed:@"imageFilterTest1.jpg"];
    keyImageView.image=keyImage;
    [self createAllImages:keyImage withType:2];

}
-(void)cleanUp
{
    keyImage=nil;
    keyImageView.image=nil;
    
}
-(void)onFilterSelect:(NSDictionary *)dict
{
    
    

    CGRect rect=[[dict valueForKey:@"rect"] CGRectValue];
    
    CGPoint point=CGPointMake(rect.origin.x + ( rect.size.width / 2 ), rect.origin.y + ( rect.size.height / 2 +filterListIB.center.y));
    
    cFilterNo=[[dict valueForKey:@"filterNo"] intValue];
    [self applyMasterFilter:point];


}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint location=[touch locationInView:self];
    

    if(touch.tapCount==2)
    {
        if(location.x>self.frame.size.width/2)
        {
            cFilterNo++;
            if(cFilterNo>MasterFilterDB.count-1)
            {
                cFilterNo=0;
            }
            [self applyMasterFilter:location];
        }
        else
        {
            cFilterNo--;
            if(cFilterNo<0)
            {
                cFilterNo=(int)MasterFilterDB.count-1;
            }
            [self applyMasterFilter:location];

        }
    }
}

-(void)createAllImages:(UIImage *)imageSource withType:(int)type
{
    
    NSLog(@"1");
    for(int filNo=0;filNo<CorefilterDB.count;filNo++)
    {
        
        NSDictionary *filterDict=[CorefilterDB objectAtIndex:filNo];
        
        NSArray *filterSteps=[filterDict valueForKey:@"DATA"];
        NSString *filterName=[filterDict valueForKey:@"ENAME"];
//        NSLog(@"%@",filterName);

        
        
            UIImage *image=imageSource;
            CIImage *sourceImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];
            
            for(int i=0;i<filterSteps.count;i++)
            {
                
                NSDictionary *filterAttributes=[filterSteps objectAtIndex:i];
                
                NSString *filterName=[filterAttributes objectForKey:@"filter"];
                
                
                CIFilter *filterTemp = [CIFilter filterWithName:filterName];
                
                
                [filterTemp setValue:sourceImage forKey:kCIInputImageKey];
                
                
                NSArray *keys=[filterAttributes allKeys];
                for(int k=0;k<keys.count;k++)
                {
                    NSString *keyName=[keys objectAtIndex:k];
                    
                    if([keyName isEqualToString:@"inputBackgroundImage"])
                    {
                        
                        CIImage *image=[filterAttributes valueForKey:keyName];
                        image=[image imageByCroppingToRect:sourceImage.extent];
                        image = [image imageByCroppingToRect:CGRectMake(sourceImage.extent.origin.x, sourceImage.extent.origin.y, sourceImage.extent.size.width, sourceImage.extent.size.height)];
                        image=[image imageByPremultiplyingAlpha];
                        
                        [filterTemp setValue:image forKey:keyName];
                        
                    }
                    else if(![keyName isEqualToString:@"filter"] && ![keyName isEqualToString:@"inputCenter"])
                    {
                        [filterTemp setValue:[filterAttributes valueForKey:keyName] forKey:keyName];
                    }
                    else if([keyName isEqualToString:@"inputCenter"])
                    {
                        CIVector *vector=[CIVector vectorWithX:sourceImage.extent.size.width/2 Y:sourceImage.extent.size.height/2];
                        [filterTemp setValue:vector forKey:@"inputCenter"];
                    }
                    
                }
                sourceImage=[filterTemp.outputImage imageByCroppingToRect:sourceImage.extent];
            }
            UIImage *image2=[helper makeUIImageFromCIImage:sourceImage];
            
            NSString *fileName=[NSString stringWithFormat:@"%@.jpg",filterName];
            [helper saveFile:image2 withName:fileName];
            [filteredImageName addObject:[NSString stringWithFormat:@"%@.jpg",filterName]];
            
        
        
    }
        NSLog(@"2");
    

    [FTIndicator showToastMessage:@"DONE!"];
    
}




-(void)applyMasterFilter:(CGPoint)point
{
    NSDictionary *dict=[MasterFilterDB objectAtIndex:cFilterNo];
    
    
    
    
    NSString *name=[dict valueForKey:@"MNAME"];
    
    NSArray *colors=[dict valueForKey:@"colors"];

    NSArray *points=[dict valueForKey:@"points"];

    
    
    
    if(colors.count!=0)
    {
    UIColor *colorA=[colors objectAtIndex:0];
    UIColor *colorB=[colors objectAtIndex:1];
    
    CGFloat red1 = 0.0, green1 = 0.0, blue1 = 0.0, alpha1 =0.0;
    [colorA getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];

    CGFloat red2 = 0.0, green2 = 0.0, blue2 = 0.0, alpha2 =0.0;
    [colorB getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];

    
    NSLog(@"\n\n %d\n[UIColor colorWithRed:%1.2f green:%1.2f blue:%1.2f alpha:%1.2f]\n[UIColor colorWithRed:%1.2f green:%1.2f blue:%1.2f alpha:%1.2f];\n\n",[[dict valueForKey:@"filter"] intValue],red1,green1,blue1,alpha1,red2,green2,blue2,alpha2);
        
//        UIColor *color1=[UIColor colorWithRed:red1 green:green1 blue:blue1 alpha:0.6f];
//        UIColor *color2=[UIColor colorWithRed:red2 green:green2 blue:blue2 alpha:0.6f];
//        
//        [helper rippleWithView:self center:point colorFrom:color1 colorTo:color2];

    }
    
        [helper rippleWithView:self center:point colorFrom:[UIColor whiteColor] colorTo:[UIColor whiteColor]];

    [helper showFancyToastWithMessage:name];
    
    NSString *imageName=[NSString stringWithFormat:@"%d",[[dict valueForKey:@"filter"] intValue]];
    [keyImageView setImage:[helper getUIImageFromName:imageName]];
    

    [gLayer removeFromSuperlayer];
    
    if(colors.count!=0)
    {
    gLayer=[helper flavescentGradientLayer:[colors objectAtIndex:0] andColor2:[colors objectAtIndex:1] andPoints:points];
    [imageOverLay.layer insertSublayer:gLayer atIndex:0];
    }

    
}


@end
