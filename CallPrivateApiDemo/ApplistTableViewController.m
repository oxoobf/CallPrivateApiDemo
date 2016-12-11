//
//  ViewController.m
//  CallPrivateApiDemo
//
//  Created by Henray Luo on 2016/12/11.
//  Copyright © 2016年 Henray Luo. All rights reserved.
//

#import "ApplistTableViewController.h"
#import "AppInfoTableViewCell.h"
#import <dlfcn.h>

#define kApplicationIdentifier          @"applicationIdentifier"
#define kBundleVersion                  @"bundleVersion"
#define kTeamID                         @"teamID"
#define kOriginalInstallType            @"originalInstallType"
#define kInstallType                    @"installType"
#define kitemID                         @"itemID"
#define kDescription                    @"description"
#define kIconStyleDomain                @"iconStyleDomain"
#define kLocalizedShortName             @"localizedShortName"
#define kLocalizedName                  @"localizedName"
#define kPrivateDocumentTypeOwner       @"privateDocumentTypeOwner"
#define kPrivateDocumentIconNames       @"privateDocumentIconNames"
#define kResourcesDirectoryURL          @"resourcesDirectoryURL"
#define kInstallProgress                @"installProgress"
#define kAppStoreReceiptURL             @"appStoreReceiptURL"
#define kStoreFront                     @"storeFront"
#define kStaticDiskUsage                @"staticDiskUsage"
#define kRequiredDeviceCapabilities     @"requiredDeviceCapabilities"
#define kAppTags                        @"appTags"
#define kPlugInKitPlugins               @"plugInKitPlugins"
#define kVPNPlugins                     @"VPNPlugins"
#define kExternalAccessoryProtocols     @"externalAccessoryProtocols"
#define kAudioComponents                @"audioComponents"
#define kUIBackgroundModes              @"UIBackgroundModes"
#define kDirectionsModes                @"directionsModes"
#define kGroupContainers                @"groupContainers"
#define kVendorName                     @"vendorName"
#define kKapplicationType               @"applicationType"
#define kSdkVersion                     @"sdkVersion"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff \
_Pragma("clang diagnostic pop") \
} while (0)

@interface ApplistTableViewController()

@property (nonatomic, strong) NSArray *appList;

@end

@implementation ApplistTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Applications";
    
    self.tableView.rowHeight = 65;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.appList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MY_CELL";
    AppInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AppInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.appBundleIDLabel.text = self.appList[indexPath.row][kApplicationIdentifier];
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self openApplicationWithBundleID:self.appList[indexPath.row][kApplicationIdentifier]];
}

/**
 1. MobileCoreServices.framework : Public framework .
 */
- (NSArray *)appListForIOS8Later
{
    // 这些类在 MobileCoreServices.framework 中 ， 默认程序会自动加载这个 FrameWork 。
    Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
    id workSpace = [LSApplicationWorkspace valueForKey:@"defaultWorkspace"];
    
    // 数组中的是 <LSApplicationProxy *> 。
    NSArray *appList = [workSpace valueForKey:@"allApplications"];
    
    // 枚举数组，组装 Dict 。
    
    NSMutableArray *appInfoArr = [@[] mutableCopy];
    [appList enumerateObjectsUsingBlock:^(id  _Nonnull applicationProxy, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *appInfo = [@{} mutableCopy];
        
        appInfo[kApplicationIdentifier]         = [applicationProxy valueForKey:kApplicationIdentifier];
        appInfo[kBundleVersion]                 = [applicationProxy valueForKey:kBundleVersion];
        appInfo[kTeamID]                        = [applicationProxy valueForKey:kTeamID];
        appInfo[kOriginalInstallType]           = [applicationProxy valueForKey:kOriginalInstallType];
        appInfo[kInstallType]                   = [applicationProxy valueForKey:kInstallType];
        appInfo[kDescription]                   = [applicationProxy valueForKey:kDescription];
        appInfo[kIconStyleDomain]               = [applicationProxy valueForKey:kIconStyleDomain];
        appInfo[kLocalizedShortName]            = [applicationProxy valueForKey:kLocalizedShortName];
        appInfo[kLocalizedName]                 = [applicationProxy valueForKey:kLocalizedName];
        appInfo[kPrivateDocumentTypeOwner]      = [applicationProxy valueForKey:kPrivateDocumentTypeOwner];
        appInfo[kPrivateDocumentIconNames]      = [applicationProxy valueForKey:kPrivateDocumentIconNames];
        appInfo[kResourcesDirectoryURL]         = [applicationProxy valueForKey:kResourcesDirectoryURL];
        appInfo[kInstallProgress]               = [applicationProxy valueForKey:kInstallProgress];
        appInfo[kStoreFront]                    = [applicationProxy valueForKey:kStoreFront];
        appInfo[kStaticDiskUsage]               = [applicationProxy valueForKey:kStaticDiskUsage];
        appInfo[kRequiredDeviceCapabilities]    = [applicationProxy valueForKey:kRequiredDeviceCapabilities];
        appInfo[kAppTags]                       = [applicationProxy valueForKey:kAppTags];
        appInfo[kPlugInKitPlugins]              = [applicationProxy valueForKey:kPlugInKitPlugins];
        appInfo[kExternalAccessoryProtocols]    = [applicationProxy valueForKey:kExternalAccessoryProtocols];
        appInfo[kAudioComponents]               = [applicationProxy valueForKey:kAudioComponents];
        appInfo[kUIBackgroundModes]             = [applicationProxy valueForKey:kUIBackgroundModes];
        appInfo[kDirectionsModes]               = [applicationProxy valueForKey:kDirectionsModes];
        appInfo[kGroupContainers]               = [applicationProxy valueForKey:kGroupContainers];
        appInfo[kVendorName]                    = [applicationProxy valueForKey:kVendorName];
        appInfo[kKapplicationType]              = [applicationProxy valueForKey:kKapplicationType];
        appInfo[kSdkVersion]                    = [applicationProxy valueForKey:kSdkVersion];
        [appInfoArr addObject:appInfo];
        
    }];
    
    return appInfoArr;
}

/**
 适用于 iOS7 的 applist 。
 */
- (NSArray *)appListForIOS7
{
    const char *path="/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation";
    void* lib = dlopen(path, RTLD_LAZY);
    
    if (!lib) return nil;
    
    NSDictionary* (*func_mobileInstallationLookup)(NSDictionary* params, id callback_unknown_usage);
    func_mobileInstallationLookup = dlsym(lib, "MobileInstallationLookup");
    
    if (!func_mobileInstallationLookup) return nil;
    
    NSDictionary* params = [NSDictionary dictionaryWithObject:@"User" forKey:@"ApplicationType"];
    NSMutableArray* appList = [NSMutableArray array];
    NSDictionary* dict = func_mobileInstallationLookup(params, NULL);
    NSArray* allkeys = [dict allKeys];
    
    for (NSString *key in allkeys) {
        
        NSDictionary* value = [dict objectForKey:key];
        NSString* bundleVersion = [value objectForKey:@"CFBundleVersion"];
        NSString* bundleShortVersion = [value objectForKey:@"CFBundleShortVersionString"];
        NSString* bundleDisplayName = [value objectForKey:@"CFBundleDisplayName"];
        if (bundleVersion == nil) {
            bundleVersion = @"1.0";
        }
        if (bundleShortVersion == nil) {
            bundleShortVersion = @"1.0";
        }
        
        if (bundleDisplayName == nil) {
            bundleDisplayName = @"Unknown";
        }
        
        NSDictionary* appDictionary = @{
                                        @"bundleid" : key,
                                        @"bundleShortVersion" : bundleShortVersion,
                                        @"bundleVersion" : bundleVersion,
                                        @"appName" : bundleDisplayName
                                        };
        
        [appList addObject:appDictionary];
    }
    
    return appList;
}

/**
 以 Bundle 的方式加载私有 FrameWork 。
 */
- (void)loadPrivateFrameWork
{
    NSBundle *bundle = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/FTServices.framework"];
    BOOL success = [bundle load];
    
    if (success) {
        
        Class FTDeviceSupport = NSClassFromString(@"FTDeviceSupport");
        id deviceSupport = [FTDeviceSupport valueForKey:@"sharedInstance"];
        NSLog(@"-- %@", [deviceSupport valueForKey:@"CTNetworkInformation"]);
        NSLog(@"-- %@", [deviceSupport valueForKey:@"userAgentString"]);
        NSLog(@"-- %@", [deviceSupport valueForKey:@"model"]);
        NSLog(@"-- %@", [deviceSupport valueForKey:@"deviceColor"]);
        NSLog(@"-- %@", [deviceSupport valueForKey:@"deviceInformationString"]);
        NSLog(@"-- %@", [deviceSupport valueForKey:@"deviceName"]);
        NSLog(@"-- %@", [deviceSupport valueForKey:@"deviceIDPrefix"]);
    }
    
}

/**
 通过 BundleID 打开一个应用。

 @param bundleID bundleID ，真机模拟器都可以打开。
 */
- (void)openApplicationWithBundleID:(NSString *)bundleID
{
    Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
    id workSpace = [LSApplicationWorkspace valueForKey:@"defaultWorkspace"];
    SEL selector = NSSelectorFromString(@"openApplicationWithBundleID:");
    
    NSInvocation *invocation =
    [NSInvocation invocationWithMethodSignature:[LSApplicationWorkspace instanceMethodSignatureForSelector:selector]];
    
    [invocation setSelector:selector];
    [invocation setTarget:workSpace];
    [invocation setArgument:&bundleID atIndex:2];
    [invocation invoke];
}


/**
 通过 BundleID 卸载一个应用 ，真机卸载不掉 。

 @param bundleID bundleID 。
 */
- (void)unInstallApplicationWithBundleID:(NSString *)bundleID
{
    Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
    id workSpace = [LSApplicationWorkspace valueForKey:@"defaultWorkspace"];
    SEL selector = NSSelectorFromString(@"uninstallApplication:withOptions:");
    SuppressPerformSelectorLeakWarning(
        [workSpace performSelector:selector withObject:bundleID withObject:nil];
    );
}

#pragma mark - Property

- (NSArray *)appList
{
    if (!_appList) {
        _appList = [self appListForIOS8Later];
    }
    return _appList;
}

@end
