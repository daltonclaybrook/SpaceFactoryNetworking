# SpaceFactoryNetworking

A collection of classes useful for fetching and persisting file data. Built on top of **NSURLSession**.

## Features

- Download data directly to disk from an **NSURL** or **NSURLRequest**.
- Files continue to download when the app is suspended.
- Data is automatically moved to persistent storage on disk.
- Data can be encrypted using standard iOS disk encryption.
- If protected file access is unavailable, data is queued for encryption at a later date.
- Specify a disk size limit in bytes. If data on disk exceeds this limit, specific files are chosen and evicted using a combination of the file's **last access date** and **file size**.
- Specify an **identifier** when fetching a file. This identifier can be used to check for the existence of a file on disk, or to evict a file.
- Specify an optional **file group** for each file to associate it with other files.
- Specify a **task priority** for a fetch.
- Initiate a manual eviction of a file with an **identifier** and **file group**, evict all files in a **file group**, or evict the entire disk cache.
- Ignore the results of a currently running fetch operation. This uninstalls the completion handler, but continues downloading the file.
- If a fetch is in progress, and another fetch is initiated for the same resource, the second completion handler is installed on the currently running fetch, preventing duplicate data.
- Inject existing data to be persisted by the file manager.
- **Image manager** uses a **file manager** to fetch / persist image data specifically.

## Usage

Initialization & Configuration:

    self.fileManager = [[SFSFileManager alloc] init];
    self.fileManager.usesEncryptionByDefault = YES;
    self.fileManager.diskSizeLimit = 512 * 1024 * 1024; // 512 MB
    
Simplest Fetch:

    NSURL *url = [NSURL URLWithString:@"http://placekitten/600/500"];
    [self.fileManager fetchFileDataAtURL:url withCompletion:^(NSURL *fileURL, NSError *error) {
    
        // data fetched using '[url absoluteString]' as the identifier 
        // and 'SFSFileManagerDefaultFileGroup' as the file group
    }];
    
Complex Fetch:

    NSURL *url = [NSURL URLWithString:@"http://myapi.com/users"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [request setValue:<#auth string#> forHTTPHeaderField:@"Authorization"];
    
    SFSFileFetchRequest *request = [SFSFileFetchRequest request];
    request.urlRequest = urlRequest;
    request.identifier = @"12345";
    request.fileGroup = @"userDataGroup";
    request.encryptionPolicy = SFSFileFetchRequestEncryptionPolicyUseEncryption;
    request.taskPriority = SFSFileFetchRequestTaskPriorityHigh;
    
    __typeof__(self) __weak weakSelf = self;
    id<SFSTask> task = [self.fileManager fetchFileDataUsingFetchRequest:request withCompletion:^(NSURL *fileURL, NSError *error) {
        
        [weakSelf useFileAtURL:fileURL error:error];
    }];
    
    // Some time later...
    
    if ([task isRunning])
    {
        [task ignoreResults]; //will cause the above completion block to not be called, but will not cancel the request.
        // or
        [task cancelRequest];
    }
    
Image Manager:
    
    // using 'nil' causes a file manager to be created for you.
    self.imageManager = [[SFSImageManager alloc] initWithFileManager:nil]; 
    
    NSURL *url = [NSURL URLWithString:@"http://placekitten/600/500"];
    
    __typeof__(self) __weak weakSelf = self;
    [self.imageManager fetchImageAtURL:url withCompletion:^(UIImage *image, NSError *error) {
        
        // completion is executed on the main thread.
        weakSelf.imageView.image = image;
    }];
    
## Integration

By far, the easiest way to integrate **SpaceFactoryNetworking** is using [CocoaPods](http://cocoapods.org):

    # Example Podfile
    pod 'SpaceFactoryNetworking'
    
Otherwise, you can clone this repo, and import files from the **'SpaceFactoryNetworking/Core'** folder.

## Collaborate

You are welcome to submit pull requests to this project. If you are considering doing so, please reach out to me at [daltonclaybrook@gmail.com](mailto:daltonclaybrook@gmail.com). I'd like to touch base.

##### Potential additions:

- Unit Tests (much needed)
- More screens in the **Example app** to demonstrate functionality
- Callbacks to report progress on a download

##### Known Issues:

- File access may not fail gracefully if the protected file is accessed while the app is in the background and the device is locked.
