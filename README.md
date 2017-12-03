## 本地音乐播放器

###样图

![样图](https://github.com/YangKa/YKMusicPlayer/blob/master/image/image_01.jpg)

### 功能：

- 歌曲列表
- 歌词渐进
- 播放界面
- 简版栏和播放进度实时更新

### 思路

 - 采用AVPlayer播放本地音频
 - 以manager单例公共管理music播放状态
 - 通过 `-addPeriodicTimeObserverForInterval: queue: usingBlock:`监听播放器进度
 - 通过KVO监听播放时间和进度，同步更新当前所有展示界面
 
 ### 注意点
 
 不管是本地文件还是网络流，都有数据加载的缓存过程，需要监听AVPlayerItem的loadedTimeRanges属性。同时合理控制cacheProgress和playProgress的关系。
 
 AVPlayer提供了AVPlayerTimeControlStatus类型的属性timeControlStatus，表示缓存和播放直接的状态。
 
 因此，播放进度条需要底色、缓存进度、播放进度。为了加快绘制，采用了CALayer自定义进度条，如下：
 
 ![样图](https://github.com/YangKa/YKMusicPlayer/blob/master/image/image_02.jpg)
 
### 计划

 - 网络流播放功能实现
 - 锁屏界面歌词实时显示
