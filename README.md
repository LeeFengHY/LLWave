# 水波纹效果

<img src="https://raw.github.com/LeeFengHY/LLWave/master/LLWave/水波纹.png" width="320">

### 知识点

主要用到数学公式：正弦型函数解析式：y = A * sin(ωx+φ) + h
A：决定峰值（即纵向拉伸压缩的倍数），通俗点叫振幅
h：表示波形在Y轴的位置关系或纵向移动距离（上加下减）
φ：（初相位）：决定波形与X轴位置关系或横向移动距离（左加右减）
ω：决定周期（最小正周期T=2π/|ω|），在实际中一般一个周期就是view的width，可以求出ω = 2 * π/view.bounds.width
x：就是每一个点x的坐标，你所看到的水波纹曲线实际是由系统一个一个点连接而成的。


### 分析
1.如果你想理解绘制原理，在开始的时候可以把A/h/ω 这几个值写成固定值，φ这个值和速度有关系，你可以给定一个初始速度比如：offsetX += waveSpeed。
2.先绘制单个波浪曲线帮助你分析实现原理。
3.绘制类准备：CAShaperLayer和CADisplayLink(这个类比NSTimer好，因为帧率每秒60FPS)。

### 主要代码

```swift
 /**
     处理displaylink事件，比较要注意的是当循环结束添加line
     wavePath1.addLine(to: CGPoint.init(x: bounds.width, y: bounds.height))
     wavePath1.addLine(to: CGPoint.init(x: 0, y: bounds.height))
     因为我的坐标系是自上而下的，因此注意最后两个点绘制坐标。
     */
    @objc private func handleTimer()
    {
        let wavePath1 = UIBezierPath()
        let wavePath2 = UIBezierPath()
        //振幅系数，振幅越大波峰越陡
        waveAmplitude = bounds.height * rate * 0.1
        //正弦型函数解析式：y = A * sin(ωx+φ) + h  ω 读alpha
        var y1 = (1 - rate) * bounds.height
        var y2 = y1
        wavePath1.move(to: CGPoint.init(x: 0, y: y1))
        wavePath2.move(to: CGPoint.init(x: 0, y: y2))
        //波长里面有几个波曲线可设置
        let a = waveCycle
        //当offsetX趋近CGFloat maxValue值时这个值应减减防止奔溃
        if offsetX >= CGFloat.greatestFiniteMagnitude {
            offsetX = offsetX - waveSpeed
        }else {
            offsetX = offsetX + waveSpeed
        }
        //峰值
        let h = (1 - rate) * bounds.height
        for x in 0...Int(bounds.width) {
            //控制波浪1和波浪2的速度不同形成动画效果
            let f1 =  offsetX / bounds.width * .pi
            let f2 =  0.75 * offsetX / bounds.width * .pi
            y1 = waveAmplitude * CGFloat(sin(Double(a * CGFloat(x) + f1))) + (h - 10)
            y2 = waveAmplitude * CGFloat(sin(Double(a * CGFloat(x) + f2))) + h
            wavePath1.addLine(to: CGPoint.init(x: CGFloat(x), y: y1))
            wavePath2.addLine(to: CGPoint.init(x: CGFloat(x), y: y2))
        }
        wavePath1.addLine(to: CGPoint.init(x: bounds.width, y: bounds.height))
        wavePath1.addLine(to: CGPoint.init(x: 0, y: bounds.height))
        wavePath1.close()
        waveLayer1.path = wavePath1.cgPath
        
        wavePath2.addLine(to: CGPoint.init(x: bounds.width, y: bounds.height))
        wavePath2.addLine(to: CGPoint.init(x: 0, y: bounds.height))
        wavePath2.close()
        waveLayer2.path = wavePath2.cgPath
        
    }
```
### 总结
1.主要是要理解正弦函数：y = A * sin(ωx+φ) + h 这几个参数对波纹的影响，你基本都能知道原理了，封装各种样式的水波纹效果离你不远了。
2.同时也要注意我手机的坐标是自上而下，从左往右的，（0，0）、（width，0）、（height，0）和（width，height），在连接最后两个点的时候需要注意下。
