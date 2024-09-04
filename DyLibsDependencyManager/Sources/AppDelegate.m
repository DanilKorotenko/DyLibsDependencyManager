//
//  AppDelegate.m
//  DyLibsDependencyManager
//
//  Created by Danil Korotenko on 9/3/24.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{

}

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app
{
    return YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (void)application:(NSApplication *)application openURLs:(NSArray<NSURL *> *)urls
{
    NSLog(@"urls: %@", urls);
    for (NSURL *url in urls)
    {
        NSLog(@"url: %@", url);

        BOOL isDirectory = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager fileExistsAtPath:url.path isDirectory:&isDirectory];

        if (isDirectory)
        {
            NSArray *urlResources = @[NSURLTypeIdentifierKey];
            NSDirectoryEnumerationOptions options =
                NSDirectoryEnumerationSkipsHiddenFiles |
                NSDirectoryEnumerationSkipsPackageDescendants;
            NSError *error = nil;

            NSArray *dirURLs = [fileManager contentsOfDirectoryAtURL:url
                includingPropertiesForKeys:urlResources options:options error:&error];
            if (error)
            {
                [NSApp presentError:error];
            }
            else
            {
                [self application:NSApp openURLs:dirURLs];
            }
        }
        else
        {
            NSError *error = nil;
            NSString *urlType = nil;
            [url getResourceValue:&urlType forKey:NSURLTypeIdentifierKey error:&error];

            NSLog(@"urlType: %@",urlType);

            if(error)
            {
                [NSApp presentError:error];
            }
            else
            {
                [[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:url
                    display:YES completionHandler:
                        ^(NSDocument * _Nullable document, BOOL documentWasAlreadyOpen,
                            NSError * _Nullable error)
                        {
                            if (error)
                            {
                                [NSApp presentError:error];
                            }
                        }];
            }
        }
    }
}
@end
