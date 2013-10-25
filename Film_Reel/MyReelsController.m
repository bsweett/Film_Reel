//
//  MyReelsController.m
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "MyReelsController.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@interface MyReelsController ()

@end

@implementation MyReelsController

@synthesize imagePicker;
@synthesize assets;
@synthesize urlStoreArr;
@synthesize library;
@synthesize imageview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        imagePicker = [[UIImagePickerController alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadAllReels];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadAllReels
{
    urlStoreArr = [[NSMutableArray alloc] init];
    assets = [[NSMutableArray alloc] init];
    library = [[ALAssetsLibrary alloc] init];
    
    void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != NULL) {
            NSLog(@"See Asset: %@", result);
            [assets addObject:result];
            // Here storing the asset's image URL's in NSMutable array urlStoreArr
            NSURL *url = [[result defaultRepresentation] url];
            [urlStoreArr addObject:url];
        }
    };
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) =  ^(ALAssetsGroup *group, BOOL *stop)
    {
        if(group != nil)
        {
            [group enumerateAssetsUsingBlock:assetEnumerator];
        }
    };
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum
                            usingBlock:assetGroupEnumerator
                          failureBlock: ^(NSError *error) {
                              NSLog(@"Failure");
                          }];
    [self loadImages];
    
}

-(void)loadImages
{
    
    UIImage *img;
    for (int i=0; i<[urlStoreArr count]; i++)
    {
        // To get the each image URL here...
        
        NSString *str = [urlStoreArr objectAtIndex:i];
        NSLog(@"str: %@",str);
        NSURL*url = [NSURL URLWithString:str];
        NSData *data = [NSData dataWithContentsOfURL:url];
        img = [[UIImage alloc] initWithData:data];
        // Need to upload the images to my server..
    }
    
    imageview.image = img;
    //for (ALAssetsGroup *assetGroup in self.assetGroups) {
    //  for (int i = 0; i<[self.assetGroups count]; i++) {
    
     /*   ALAssetsGroup *assetGroup = [self.assetGroups objectAtIndex:0];
        NSLog(@"ALBUM NAME:;%@",[assetGroup valueForProperty:ALAssetsGroupPropertyName]);
    
        [assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
         {
             if(result == nil)
             {
                 return;
             }
             UIImage *img = [UIImage imageWithCGImage:[[result defaultRepresentation] fullScreenImage] scale:1.0 orientation:(UIImageOrientation)[[result valueForProperty:@"ALAssetPropertyOrientation"] intValue]];
         
         }];  
    */
    
    //  }
}

@end
