//
//  UIImageHM.m
//  MeanWiseUX
//
//  Created by Hardik on 05/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "UIImageHM.h"
#import "Constant.h"

@implementation UIImageHM

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        userDict=nil;
        
        tapHolderBtn=[[UIButton alloc] initWithFrame:self.bounds];
        [tapHolderBtn setBackgroundColor:[UIColor clearColor]];
        [self addSubview:tapHolderBtn];
        tapHolderBtn.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [tapHolderBtn addTarget:self action:@selector(tapPressed:) forControlEvents:UIControlEventTouchUpInside];
        tapHolderBtn.enabled=false;
        [tapHolderBtn setShowsTouchWhenHighlighted:YES];
        self.userInteractionEnabled=false;

        
      
    }
    return self;
}

-(void)setUp:(NSString *)stringURL
{
    [self clearImageAll];
    
   /* if(![stringURL containsString:KK_globalMediaURL])
    {
        stringURL=[NSString stringWithFormat:@"%@%@",KK_globalMediaURL,stringURL];

    }*/
    
    
   // self.image=nil;
    
    mainURL=stringURL;

    self.contentMode=UIViewContentModeScaleAspectFill;
    self.clipsToBounds=YES;
    
    if([self firstTime])
    {
        [self createEmptyArray];
    }
    
    
    NSString *path=[self getCachePathIfExists:stringURL];
    
    if(path!=nil)
    {
        NSLog(@"setting old path");

        [self setImagePath:path];
    }
    else
    {
        
        [self setPlaceHolderImage];
    }
  
    
}
-(void)tapPressed:(id)sender
{
    [target performSelector:onClickFunc withObject:userDict afterDelay:0.01];

 
    NSLog(@"clickEvent");
    
}


-(void)setTarget:(id)targetReceived OnClickFunc:(SEL)func WithObj:(NSDictionary *)obj;
{
    userDict=obj;

    tapHolderBtn.enabled=true;
    self.userInteractionEnabled=true;

    target=targetReceived;
    onClickFunc=func;

    
}
-(BOOL)firstTime
{
    if([[self userDefault] valueForKey:@"DATA_IMAGECACHE"]==nil)
    {
        return true;
    }
    else
    {
        return false;
    }
}
-(void)createEmptyArray
{
    NSArray *array=[[NSArray alloc] init];
    NSUserDefaults *default1=[self userDefault];
    [default1 setObject:array forKey:@"DATA_IMAGECACHE"];
    [default1 synchronize];
    
    NSString *dataPath = [self getDocumentPath];
    NSError *error;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    }

}

-(NSString *)getCachePathIfExists:(NSString *)urlToSearch
{
    NSString *temp=nil;
    int isPending=0;
    
    NSArray *list=[self getArray];
    
    
    NSArray *filtered = [list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(url == %@)", urlToSearch]];
    
    if(filtered.count>=1)
    {
        NSDictionary *item = [filtered objectAtIndex:0];
        
        
        temp=[item valueForKey:@"localPath"];
        
        NSString *documentsDirectory=[self getDocumentPath];
        temp = [NSString stringWithFormat:@"%@/%@", documentsDirectory,temp];
        
      //  NSLog(@"Image from cache");

/*        if([[item valueForKey:@"status"] isEqualToString:@"DONE"])
        {
            
            
        }
        else
        {
            
            //  NSLog(@"Video request sent Already");
            isPending=1;
        }*/
    }
    
    
    
    
    if(temp==nil && isPending==0)
    {
        // NSLog(@"New request sent");
        
        [self downloadImageURL:urlToSearch];
        
    }
    return temp;
}


-(void)clearImageAll
{
    [progressBar removeFromSuperview];
    progressBar=nil;
    self.image=nil;
    mainURL=nil;
    
}
-(void)setPlaceHolderImage
{
    dispatch_async(dispatch_get_main_queue(), ^{

        progressBar=[[UIArcViewProgressBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/4, self.frame.size.width/4)];
        
        [self addSubview:progressBar];
        [progressBar setRadious:self.frame.size.width/9];
        [progressBar setProgress:0];
        progressBar.userInteractionEnabled=false;
        [progressBar startAnimation:nil];
        progressBar.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        progressBar.backgroundColor=[UIColor clearColor];
        progressBar.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        

    self.image=[UIImage imageNamed:@"placeholder.jpg"];
    });

}
-(void)setImagePath:(NSString *)stringPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:stringPath]];
    });
    
}
-(void)setDownloadedImageWithoutAnimation
{
    
    if(self.image!=nil)
    {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
        
        
        NSString *path=[self getCachePathIfExists:mainURL];
        
        if(path!=nil)
        {

            
            NSLog(@"setting downloaded image path");
            
            [self setImagePath:path];
            
           
            
        }
        else
        {
            NSLog(@"snil");
        }
    });

    
}
- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

-(void)setDownloadedImage
{
    dispatch_async(dispatch_get_main_queue(), ^{
    
    NSString *path=[self getCachePathIfExists:mainURL];
    
    if(path!=nil && [self image:self.image isEqualTo:[UIImage imageNamed:@"placeholder.jpg"]])
    {
        self.alpha=0;


        NSLog(@"setting downloaded image path");
        
        [self setImagePath:path];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            if(self!=nil)
            {
            self.alpha=1;
                
                
                [progressBar removeFromSuperview];
                progressBar=nil;
            }
            
        }];
        
    }
    else
    {
        NSLog(@"snil");

    }
    });



}



-(void)downloadImageURL:(NSString *)videoUrl
{
    NSString *documentsDirectory=[self getDocumentPath];

    NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSData *yourVideoData=[NSData dataWithContentsOfURL:[NSURL URLWithString:videoUrl]];
        
        if (yourVideoData) {
            
            NSString *stringUnique = [[NSUUID new] UUIDString];
            
            NSString *PathTime1=[NSString stringWithFormat:@"tempImgCache_%@.jpg",stringUnique];
            NSString  *filePath1 = [NSString stringWithFormat:@"%@/%@", documentsDirectory,PathTime1];
            
            
            if([yourVideoData writeToFile:filePath1 atomically:YES])
            {
                
              //  NSLog(@"One image downloaded");
                
                
                NSDictionary *dict1=@{@"url":videoUrl,@"localPath":PathTime1,@"date":[NSDate date],@"status":@"DONE"};
                [self addImageDict:dict1];
                
                

                [self setDownloadedImage];

               // [self setImagePath:filePath1];
                
            }
            else{
                NSLog(@"write failed");
            }
        }
        
    }];
    completionOperation.queuePriority=NSOperationQueuePriorityHigh;
    completionOperation.name=videoUrl;
    completionOperation.qualityOfService=NSQualityOfServiceUserInitiated;
  
    [[self getVideoQueue] addOperationAtFrontOfQueue:completionOperation];
    
//    [[self getVideoQueue] addOperation:completionOperation];
    

}

-(void)downloadImageURL1:(NSString *)videoUrl
{
    //  NSLog(@"New request sent");
    
    
    NSString *stringUnique = [[NSUUID new] UUIDString];

    NSString *PathTime=[NSString stringWithFormat:@"tempImgCache_%@.jpg",stringUnique];
    
    NSString *documentsDirectory=[self getDocumentPath];
  //  NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,PathTime];
    //NSLog(@"%@",filePath);
    NSDictionary *dict=@{@"url":videoUrl,@"localPath":PathTime,@"date":[NSDate date],@"status":@"PENDING"};
    
    [self addImageDict:dict];
    
    // NSLog(@"file path - %@",filePath);
    
    
    
    
    
    NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSData *yourVideoData=[NSData dataWithContentsOfURL:[NSURL URLWithString:videoUrl]];
        
        if (yourVideoData) {
            
            NSString *stringUnique = [[NSUUID new] UUIDString];

            NSString *PathTime1=[NSString stringWithFormat:@"tempImgCache_%@.jpg",stringUnique];
            NSString  *filePath1 = [NSString stringWithFormat:@"%@/%@", documentsDirectory,PathTime1];
            
            
            if([yourVideoData writeToFile:filePath1 atomically:YES])
            {
                
             //   NSLog(@"One image downloaded");
                
                [self removeImageDict:dict];
                
                NSDictionary *dict1=@{@"url":videoUrl,@"localPath":PathTime1,@"date":[NSDate date],@"status":@"DONE"};
                
                [self addImageDict:dict1];
                
                
                [self setImagePath:filePath1];
                
            }
            else{
             //   NSLog(@"write failed");
            }
        }
        
    }];
    completionOperation.queuePriority=NSOperationQueuePriorityHigh;
    completionOperation.name=videoUrl;
    completionOperation.qualityOfService=NSQualityOfServiceUserInitiated;
    
    [[self getVideoQueue] addOperation:completionOperation];
    
}
-(void)removeImageDict:(NSDictionary *)dict
{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[self getArray]];
    [array removeObject:dict];
    NSUserDefaults *default1=[self userDefault];
    [default1 setObject:array forKey:@"DATA_IMAGECACHE"];
    [default1 synchronize];
    
    
}
-(void)addImageDict:(NSDictionary *)dict
{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[self getArray]];
    [array addObject:dict];
    
    NSUserDefaults *default1=[self userDefault];
    [default1 setObject:array forKey:@"DATA_IMAGECACHE"];
    [default1 synchronize];
    
    // NSLog(@"%ld",array.count);
    
}
-(NSUserDefaults *)userDefault
{
    return [NSUserDefaults standardUserDefaults];
}




-(AppDelegate *)getAppDelegate
{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate;
}
-(NSOperationQueue *)getVideoQueue
{
    return [self getAppDelegate].MeanWise_ImageQueue;
}
-(NSArray *)getArray
{
    return [[self userDefault] valueForKey:@"DATA_IMAGECACHE"];
    
}
-(int)getNumberOfCacheItems
{
    return (int)[self getArray].count;
    
}
-(void)clearImageCache;
{
    NSArray *list=[self getArray];
    
    for (int i=0; i<list.count; i++) {
        
        NSString *localPath=[[list objectAtIndex:i] valueForKey:@"localPath"];
        
        NSString *documentsDirectory=[self getDocumentPath];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,localPath];
        
        
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    [self createEmptyArray];
}
-(NSString *)getDocumentPath
{
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    
    documentsDirectory=[documentsDirectory stringByAppendingPathComponent:@"/ImageCache"];
    
    return documentsDirectory;
    
}
-(NSString *)getDocumentPath1
{
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
    
}

@end
