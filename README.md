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
 
 
### 计划

 - 网络流播放功能实现

