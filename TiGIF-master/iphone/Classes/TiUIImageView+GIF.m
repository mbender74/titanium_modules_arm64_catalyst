//
//  TiUIImageView+GIF.m
//  com.enouvo.tigif
//
//  Created by Duy Bao Nguyen on 3/04/2015.
//
//

#import "FLAnimatedImage.h"
#import "TiUIImageView+GIF.h"

@implementation TiUIImageView (GIF)
FLAnimatedImageView *gif;

-(void)runBlock:(void (^)(void))block
{
    block();
}
-(void)runAfterDelay:(CGFloat)delay block:(void (^)(void))block
{
    void (^block_)(void) = [block copy];
    [self performSelector:@selector(runBlock:) withObject:block_ afterDelay:delay];
}


-(void)setGif_:(id)arg
{

    FLAnimatedImageView *gif = [[FLAnimatedImageView alloc] init];
    [self addSubview:gif];

    gif.contentMode = UIViewContentModeScaleAspectFill;
    gif.clipsToBounds = YES;
    
    if ([TiUtils boolValue:[self.proxy valueForUndefinedKey:@"localgif"] def:YES]){
                
          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                
                    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[TiUtils toURL:arg proxy:self.proxy]]];
                    
                       
                   

            //        if (newHeight < [maxHeight floatValue]) {
            //            newHeight = [maxHeight floatValue];
            //            newWidth = newHeight/ratio;
            //        }
                    
                  //  gif.backgroundColor = [UIColor clearColor];


            //        self->height = TiDimensionFromObject([NSNumber numberWithFloat:gif.frame.size.height]);
            //        self->width = TiDimensionFromObject([NSNumber numberWithFloat:gif.frame.size.width]);

                    
              dispatch_async(dispatch_get_main_queue(), ^{

                      gif.alpha = 0.0;
                      gif.tag = 888;
                      id backgroundColor = [self.proxy valueForKey:@"backgroundColor"];
                      UIColor *newBackgroundColor = [[TiUtils colorValue:backgroundColor] _color];
                      gif.backgroundColor = newBackgroundColor;

                    gif.animatedImage = image;

                      gif.opaque = YES;
                      gif.layer.masksToBounds = true;
                      super.opaque = YES;

                  
                    if ([[self proxy] _hasListeners:@"gifloaded"]) {

                        
                        

                        
                        if ([TiUtils boolValue:[[self proxy] valueForUndefinedKey:@"resize"] def:YES]) {
                            id maxHeight = [self.proxy valueForUndefinedKey:@"maxHeight"];
                            id maxWidth = [self.proxy valueForUndefinedKey:@"maxWidth"];
                            if (maxHeight == nil || maxHeight == [NSNull null]){
                                maxHeight = [NSNumber numberWithFloat:image.size.height];
                            }
                            if (maxWidth == nil || maxWidth == [NSNull null]){
                                maxWidth = [NSNumber numberWithFloat:image.size.width];
                            }

                            CGFloat ratio = MIN([maxWidth floatValue] / image.size.width, [maxHeight floatValue] / image.size.height);

                            CGFloat newWidth = image.size.width*ratio;
                            CGFloat newHeight = image.size.height*ratio;
                            
                            gif.frame = CGRectMake(0.0, 0.0, newWidth, newHeight);

                            self.frame = gif.frame;
                           // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                NSMutableDictionary *eventObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithFloat:newWidth], @"width",
                                    [NSNumber numberWithFloat:newHeight], @"height",
                                    nil];
                                [[self proxy] fireEvent:@"gifloaded" withObject:eventObject propagate:NO];
                          //  });
                            }
                          else {
                              NSMutableDictionary *eventObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithFloat:1], @"done",
                                  nil];
                              [[self proxy] fireEvent:@"gifloaded" withObject:eventObject propagate:NO];
                          }
                    }
                    
                    [self runAfterDelay:0.4 block:^{
                        //NSLog(@"two seconds later!");
                        [UIView animateWithDuration:0.3
                                         animations:^{
                            gif.alpha = 1.0;
                        }];
                    }];
              });
        });
    }
    else {
        gif.alpha = 0.0;

       // [self addSubview:gif];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[TiUtils toURL:arg proxy:self.proxy]]];
        
        id maxHeight = [self.proxy valueForUndefinedKey:@"maxHeight"];
        id maxWidth = [self.proxy valueForUndefinedKey:@"maxWidth"];
        if (maxHeight == nil || maxHeight == [NSNull null]){
            maxHeight = [NSNumber numberWithFloat:image.size.height];
        }
        if (maxWidth == nil || maxWidth == [NSNull null]){
            maxWidth = [NSNumber numberWithFloat:image.size.width];
        }

        CGFloat ratio = MIN([maxWidth floatValue] / image.size.width, [maxHeight floatValue] / image.size.height);
        

        CGFloat newWidth = image.size.width*ratio;
        CGFloat newHeight = image.size.height*ratio;

//            if (newHeight < [maxHeight floatValue]) {
//                newHeight = [maxHeight floatValue];
//                newWidth = newHeight/ratio;
//            }
        


        gif.frame = CGRectMake(0.0, 0.0, newWidth, newHeight);

//        self->height = TiDimensionFromObject([NSNumber numberWithFloat:gif.frame.size.height]);
//        self->width = TiDimensionFromObject([NSNumber numberWithFloat:gif.frame.size.width]);
        gif.tag = 888;
        id backgroundColor = [self.proxy valueForKey:@"backgroundColor"];
        UIColor *newBackgroundColor = [[TiUtils colorValue:backgroundColor] _color];
        gif.backgroundColor = newBackgroundColor;

        
        self.frame = gif.frame;

//        [self runAfterDelay:0.1 block:^{
//            //NSLog(@"two seconds later!");
//
//        }];
//
            gif.animatedImage = image;
            
            gif.opaque = YES;
            gif.layer.masksToBounds = true;
            super.opaque = YES;

            if ([[self proxy] _hasListeners:@"gifloaded"]) {
                NSMutableDictionary *eventObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithFloat:newWidth], @"width",
                    [NSNumber numberWithFloat:newHeight], @"height",
                    nil];
                [[self proxy] fireEvent:@"gifloaded" withObject:eventObject propagate:NO];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3
                                 animations:^{
                    gif.alpha = 1.0;
                }];
            });
            //gif.frame = CGRectMake(0.0, 0.0, newWidth, newHeight);

            //        self->height = TiDimensionFromObject([NSNumber numberWithFloat:gif.frame.size.height]);
    //        self->width = TiDimensionFromObject([NSNumber numberWithFloat:gif.frame.size.width]);
            
            //self.frame = gif.frame;
            //gif.backgroundColor = self.backgroundColor;
           
        });
    }
}
#pragma mark Public APIs


-(void)setStopAnimating_:(id)arg
{
    
    for (UIView *i in self.subviews){
          if([i isKindOfClass:[FLAnimatedImageView class]]){
              FLAnimatedImageView *myGifView = (FLAnimatedImageView *)i;
                if(myGifView.tag == 888){
                    [myGifView stopAnimating];
                }
          }
    }
    
}

-(void)setStartAnimating_:(id)arg
{
    
    for (UIView *i in self.subviews){
          if([i isKindOfClass:[FLAnimatedImageView class]]){
              FLAnimatedImageView *myGifView = (FLAnimatedImageView *)i;
                if(myGifView.tag == 888){
                    [myGifView startAnimating];
                }
          }
    }
    
}




@end
