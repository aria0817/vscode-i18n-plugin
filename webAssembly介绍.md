# webAssembly

## 1. 什么是webAssembly 

WebAssembly (abbreviated Wasm) is a binary instruction format for a stack-based virtual machine. Wasm is designed as a portable target for compilation of high-level languages like C/C++/Rust, enabling deployment on the web for client and server applications.

WebAssembly(缩写 Wasm)是基于堆栈虚拟机的二进制指令格式。Wasm为了一个可移植的目标而设计的，可用于编译C/C+/RUST等高级语言，使客户端和服务器应用程序能够在Web上部署。

* WebAssembly是一个**编译目标**，并为诸如C / C ++等语言提供一个编译目标，以便它们可以在Web上运行。
* 是一种新的编码方式，它是一种低级的类汇编语言，具有紧凑的二进制格式，可以接近原生的性能运行。

<br><br>

## 2.性能瓶颈
### 1. js解析的流程    JIT **compiler**

* 在 JavaScript 引擎中增加一个监视器（也叫分析器）。监视器监控着代码的运行情况，记录代码一共运行了多少次、如何运行的等信息，如果同一行代码运行了几次，这个代码段就被标记成了 “warm”，如果运行了很多次，则被标记成 “hot”。

* （基线编译器）如果一段代码变成了 “warm”，那么 JIT 就把它送到基线编译器去编译，并且把编译结果存储起来。比如，监视器监视到了，某行、某个变量执行同样的代码、使用了同样的变量类型，那么就会把编译后的版本，替换这一行代码的执行，并且存储。

* （优化编译器）如果一个代码段变得 “hot”，监视器会把它发送到优化编译器中。生成一个更快速和高效的代码版本出来，并且存储。例如：循环加一个对象属性时，假设它是 INT 类型，优先做 INT 类型的判断

* （去优化）可是对于 JavaScript 从来就没有确定这么一说，前 99 个对象属性保持着 INT 类型，可能第 100 个就没有这个属性了，那么这时候 JIT 会认为做了一个错误的假设，并且把优化代码丢掉，执行过程将会回到解释器或者基线编译器，这一过程叫做去优化。

![V8](/assest/V8.png)

在项目运行的过程中，引擎会对执行次数较多的function进行优化，引擎将其代码编译成机器码后进行 Just-In-Time(JIT) Compiler ，下次再执行这个function，就会直接执行编译好的机器码。但是由于JavaScript的动态变量，上一秒可能是Array，下一秒就变成了Object。那么上一次引擎所做的优化，就失去了作用，此时又要再一次进行优化。



### 2. ams.js  出现以及做了什么优化

asm.js 是 JavaScript 的一个严格的子集，只能使用后者的一部分语法。

解决了什么问题：asm.js尽可能的明确变量类型，并且当浏览器的JavaScript 引擎发现运行的是 asm.js时，就会跳过语法分析这一步，将其转成汇编语言执行。另外，浏览器还会通过 GPU 调用 WebGL 执行 asm.js，使其运行得更快。

![img](https://static001.infoq.cn/resource/image/cb/73/cbaa14249b1c70d48b2aed355fcfca73.png)

还有什么问题：

但是asm.js对静态类型的问题做的再好，但是生成是的javascript代码，它始终要经过Parser，要经过ByteCode Compiler，而这两步是JavaScript代码在引擎执行过程当中消耗时间最多的两步。



### 3. webAssembly 的出现 https://developer.mozilla.org/zh-CN/docs/WebAssembly

WebAssembly同样的强制静态类型，是二进制格式，其代码体积同asm.js小很多，并且由于已经是面向机器码的格式，不需要在运行前对代码耗费时间进行 JIT 编译操作，更近一步提高了性能。
可以抽象地理解成它是概念机器的机器语言，而不是实际的物理机器的机器语言。正因为如此，WebAssembly 指令有时也被称为虚拟指令。它比 JavaScript 代码更直接地映射到机器码，它也代表了“如何能在通用的硬件上更有效地执行代码”的一种理念。所以它并不直接映射成特定硬件的机器码。
![image-20220121135425854](/assest/webassembly.png)


## 3. webAssembly

### 1. 特点：

* Efficient and fast:  WebAssembly 有一套完整的语义，实际上 wasm 是体积小且加载快的二进制格式， 其目标就是充分发挥硬件能力以达到原生执行效率。

* Safe:  WebAssembly 运行在一个沙箱化的执行环境中，甚至可以在现有的 JavaScript 虚拟机中实现。在web环境中，WebAssembly将会严格遵守同源策略以及浏览器安全策略。【在浏览器的沙箱环境内，WASM模块与浏览器的内存完全隔离，单独管理。】

* Open and debuggable: WebAssembly 设计了一个非常规整的文本格式用来、调试、测试、实验、优化、学习、教学或者编写程序。可以以这种文本格式在web页面上查看wasm模块的源码。

* Part of the open web platform:  WebAssembly 在 web 中被设计成无版本、特性可测试、向后兼容的。WebAssembly 可以被 JavaScript 调用，进入 JavaScript 上下文，也可以像 Web API 一样调用浏览器的功能。


https://developer.mozilla.org/zh-CN/docs/WebAssembly/Concepts 


### 2. WebAssembly是一门不同于JavaScript的语言，它不是用来取代JavaScript的。相反，它被设计为和JavaScript一起协同工作，从而使得网络开发者能够利用两种语言的优势。

- JavaScript是一门高级语言。对于写网络应用程序而言，它足够灵活且富有表达力。它有许多优势——它是动态类型的，不需要编译环节以及一个巨大的能够提供强大框架、库和其他工具的生态系统。
- WebAssembly是一门低级的类汇编语言。它有一种紧凑的二进制格式，使其能够以接近原生性能的速度运行，并且为诸如C++和Rust等拥有低级的内存模型语言提供了一个编译目标以便它们能够在网络上运行。

它们可以相互调用，WebAssembly代码能够导入和同步调用常规的JavaScript函数，javascript也可以通过JavaScript API使用WebAssembly代码提供的函数。WebAssembly代码的基本单元被称作一个模块，并且WebAssembly的模块在很多方面都和ES2015的模块是等价的。


### 3. JavaScript能够完全控制WebAssembly代码如何下载、编译运行，所以，JavaScript开发者甚至可以把WebAssembly想象成一个高效地生成高性能函数的JavaScript特性



### 4. 使用WebAssembly JavaScript API 

WebAssembly关键概念：

- **模块**：表示一个已经被浏览器编译为可执行机器码的WebAssembly二进制代码。一个模块是无状态的，并且像一个[二进制大对象](https://developer.mozilla.org/zh-CN/docs/Web/API/Blob)（Blob）一样能够[被缓存到IndexedDB](https://developer.mozilla.org/zh-CN/docs/WebAssembly/Caching_modules)中或者在windows和workers之间进行共享（通过[postMessage() (en-US)](https://developer.mozilla.org/en-US/docs/Web/API/MessagePort/postMessage)函数）。一个模块能够像一个ES2015的模块一样声明导入和导出。
- **内存**：ArrayBuffer，大小可变。本质上是连续的字节数组，WebAssembly的低级内存存取指令可以对它进行读写操作。
- **表格**：类型数组，大小可变。表格中的项存储了不能作为原始字节存储在内存里的对象的引用（为了安全和可移植性的原因）。
- **实例**：一个模块及其在运行时使用的所有状态，包括内存、表格和一系列导入值。一个实例就像一个已经被加载到一个拥有一组特定导入的特定的全局变量的ES2015模块。



1. JavaScript API为开发者提供了创建模块、内存、表格和实例的能力。给定一个WebAssembly实例，通过把JavaScript函数导入到WebAssembly实例中，任意的JavaScript函数都能被WebAssembly代码同步调用。

2. 内存：可用于JavaScript和WebAssembly的数据共享。JavaScript代码是在V8内进行管理执行的，而wasm不在v8内的，虽然wasm模块是由v8进行实例化的，但是它只是对wasm的整体进行实例化的，无法探查到wasm内部的执行情况，而且wasm是一般都是由后端语言进行编写的，他们也都是有自己的内存管理。 v8的内存是由它的上层浏览器或者Node给提供的，v8即不知道wasm模块是由什么语言写的、也不知道它的内存情况。所以说V8这个范畴和wasm创建的实例里边这相当于两个进程，它们两个的数据交换可以通过函数调用返回一个返回值，但是当想要交换一个对象时就会出现问题，因为他们的对象格式是不一样的，wasm模块内的后端语言可能是一些结构体，这样就会存在问题。 那么它们之间需要有一个共同的内存空间，具体的数据格式由开发者自己来规定。

3. Table：构造函数根据给定的大小和元素类型创建一个Table对象。这是一个包装了WebAssemble Table 的Javascript包装对象，具有类数组结构，存储了多个函数引用。在Javascript或者WebAssemble中创建Table 对象可以同时被Javascript或WebAssemble 访问和更改。

   

### 5. WebAssembly会取代JavaScript？

wasm 模块总是与 JavaScript“胶水”代码一起使用，在必要的时候可以执行一些有用的操作。WebAssembly 可以看做是对 JavaScript 的加强，弥补 JavaScript 在执行效率上的缺陷。

![img](https://static001.infoq.cn/resource/image/fc/0c/fc539957725ee746307b4ce2d4a8ab0c.png)

WebAssembly是被设计成JavaScript的一个完善、补充，而不是一个替代品。

![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2018/11/8/166f12bfd8a03f40~tplv-t2oaga2asx-watermark.awebp)



### 5. 什么时候使用WebAssembly？

1. 大致分为两个点

   * 对性能有很高要求的App/Module/游戏。

   * 在Web中使用C/C++/Rust/Go的库。举个简单的例子。如果你要实现的Web版本的Ins或者Facebook， 你想要提高效率。那么就可以把其中对图片进行压缩、解压缩、处理的工具，用C++实现，然后再编译回WebAssembly。


2. 一些具体应用场景：

   * 更好的让一些语言和工具可以编译到 Web 平台运行。
   * 图片/视频编辑。
   * 游戏：需要快速打开的小游戏，AAA 级，资源量很大的游戏。游戏门户（代理/原创游戏平台）
   * 音乐播放器（流媒体，缓存）
   * 图像识别、视频直播
   * VR 和虚拟现实
   * CAD 软件
   * 开发者工具（编辑器，编译器，调试器…）

   目前使用webAssembly应用：
   https://www.figma.com/
   https://earth.google.com/web/
   ...
   
3. WebAssembly的几个开发工具

   * [AssemblyScript](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2FAssemblyScript%2Fassemblyscript)。支持直接将TypeScript编译成WebAssembly。这对于很多前端同学来说，入门的门槛还是很低的。

   * [Emscripten](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Fkripken%2Femscripten)。可以说是WebAssembly的灵魂工具不为过，上面说了很多编译，这个就是那个编译器。将其他的高级语言，编译成WebAssembly。

   * [WABT](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2FWebAssembly%2Fwabt)。是个将WebAssembly在字节码和文本格式相互转换的一个工具，方便开发者去理解这个wasm到底是在做什么事。

     

### 6. WebAssembly未来特性

*  直接操作 DOM
* 提升浏览器中的 WebAssembly 性能：在 JS 代码中调用 WebAssembly 函数会比预期更慢。这是因为它必须做一种被称为 “蹦床” [1](#fn-1) 的工作。JIT 并不知道如何直接处理 WebAssembly，所以它必须将 WebAssembly 送到一些可以处理的地方。这段代码在引擎中执行很慢，它的功能是 设定运行优化的 WebAssembly 代码
* 共享内存的并发性
* 异常处理： WebAssembly 中异常还没有被规范化



某些未来特性不会影响性能，但是会让开发者使用 WebAssembly 更便利。

- **优秀的源码级开发者工具** 。目前，在浏览器中调试 WebAssembly 就像是在调试原始的汇编代码。没多少开发者能在脑中将 源码 和 汇编代码 对应起来。我们正在研究并改善工具支持，以便开发者能够调试自己的源码。

- **垃圾回收** 。只要提前定义了类型，就可以将代码转换成 WebAssembly。因此，使用 TypeScript 这样的代码应当是可以被编译为 WebAssembly 的。而目前唯一的一个问题是，WebAssembly 不知道如何与现有的垃圾回收器交互，比如 JS 引擎内部的那个。这个未来特性的主要想法是，为 WebAssembly 提供一套底层 GC 原始类型和操作来对 内置 GC 完美地进行访问。

- **ES6 模块集成** 。浏览器正在添加 使用 `script` 标签来加载 JavaScript 模块的支持。新特性添加之后， 即使 `<script src=url type="module">` 中 url 指向 WebAssembly 模块，也可以正常生效。

<br>
## 参考链接：

https://hacks.mozilla.org/2017/07/memory-in-webassembly-and-why-its-safer-than-you-think/

https://codeantenna.com/a/5psNvdffhw

https://webassembly.org/

https://codeantenna.com/a/5psNvdffhw

