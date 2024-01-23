[TOC]

# 1、进程、线程与协程

- 进程：程序+资源，即运行中的程序，是操作系统资源分配的最小单位
- 线程：轻量级进程，是操作系统调度执行的最小单位
- 协程：比线程更加轻量级，不是由操作系统管理，而是由程序控制（有点像函数，或者说中断）
- 三者的区分：
  - 线程依赖于进程，一个进程至少有一个线程
  - 进程与进程之间是独立的，不共享全局变量，而一个进程的线程之间是共享资源的
  - 进程和线程都可以实现多任务，但是进程开销更大
  - 进程与线程实现多任务是通过时间片轮转轮流执行，协程实现多任务是通过类似于中断的方式
- 关于进程、线程与协程的介绍以及三者异同，这里不是重点，所以讲得不是很清楚

# 2、多任务

- 时间片轮转：各个进程分配一个时间片，多个进程周期轮流地执行

- 优先级调度：不同进程的优先级不同，优先级高的进程可以抢占cpu资源

- 并行与并发

  - 并行：cpu核数多于任务数		

  - 并发：任务数多于cpu核数

- 线程的执行顺序由操作系统决定

# 3、threading模块实现多任务

<img src="./img/multi threading.png">

- threading模块是通过多线程的方式实现多任务的

- 方法

  - `threading.Thread()`    创建子线程对象（并没有创建子线程），返回一个`threadObject`对象		
  - `threadObject.start()`    创建子线程并开始执行子线程		
  - `threadObject.enumerate()`    查看当前线程信息

- 关键点

  - 子线程可以绑定一个函数，也可以绑定一个对象（通过继承`threading.Thread`）

    ```python
    class Demo(threading.Thread):  # 这里创建一个类Demo，该类继承了threading.Thread
        def run(self):  # 该函数必须写，这是子线程start方法的入口
            pass
        def func1(self):
            pass
    
    t = Demo()
    t.start()  # 在调用start方法时，会自动执行自定义的run方法
    ```

  - 子线程可以通过关键字参数`args`传参（绑定函数）

    ```python
    In [1]: import threading
    
    In [2]: import time
    
    In [3]: num = 0
    
    In [4]: def demo1(temp):
       ...:     global num
       ...:     for i in range(temp):
       ...:         num += 1
       ...:         
    
    In [5]: def demo2(temp):
       ...:     global num
       ...:     for i in range(temp):
       ...:         num += 1
       ...:         
    
    In [6]: def test():
       ...:     t1.start()
       ...:     t2.start()
       ...:     time.sleep(2)
       ...:     
    
    In [7]: t1 = threading.Thread(target=demo1, args=(1000,))  
    # target为子线程绑定的函数
    # args为传递的参数,是一个元祖，关于args如何将参数传递给函数，见下一个例子 
    
    In [8]: t2 = threading.Thread(target=demo2, args=(2000,))
    
    In [9]: test()
    
    In [10]: num
    Out[10]: 3000
      
    
    # args传参的例子
    In [15]: def demo(temp1, temp2, temp3):
        ...:     print(temp1, temp2, temp3)
        ...:     
    
    In [16]: t = threading.Thread(target=demo, args=(1,2,3))
    
    In [17]: t.start()
    1 2 3
    ```

  - 当子线程绑定的函数执行结束时，该子线程结束

  - 子线程之间共享全局变量

  - 主线程必须最后结束，一旦主线程结束，所有子线程也会被杀死

- 子线程共享全局变量带来的问题

  - 子线程共享全局变量可能带来一些问题，如资源抢占，资源分配不合理导致程序错误

- 解决资源分配不合理的方法

  - 将每一步必要操作分为原子性操作，每一个原子性操作必须在一个子线程内完成，不能中途退出
  - python中使用下面方法来锁定线程
    - `threadingObject.Lock()`    
      - 创建一个线程锁对象（``threadingObject`为线程对象），返回一个`lockObject`对象			
    - `lockObject.acquire()`    
      - 给该线程上锁，当执行这个方法后，除非释放线程锁，该进程的资源都被这个线程占有			
    - `lockObject.release()`    
      - 释放线程锁
  - 注意：哪个线程先执行acquire()，该线程就先上锁

# 4、multiprocessing模块实现多任务

- multiprocessing模块通过多进程实现多任务

- 基本使用

  ```python
  import multiprocessing
  def f1(parameter1, parameter2, ...):
      pass
  def f2():
      pass
  p1 = multiprocessing.Process(target=f1, args=(parameter1, parameter2, ...))  
  # 类似多线程的使用
  
  p2 = multiprocessing.Process(target=f2)
  p1.start()  # 新创建一个子进程，相当于系统把主进程的资源拷贝一份给子进程
  p2.start()
  ```

- 使用队列完成多进程之间通信

  ```python
  import multiprocessing
  q = multiprocessing.Queue()  # 创建队列，可以传递参数n，表示队列的最大存储单元数
  q.put(111)  
  # 方法put可以向队列中添加数据，可以添加任何类型数据，当队列满时，put方法会一直阻塞程序，直到队列有空
  
  q.put_nowait(111)  # 方法put_nowait和put类似，只是当队列满时，put_nowait会直接抛出异常告知队列已满
  q.get()  # 取出队列数据，队列是先进先出
  q.get_nowait()
  q.empty()  # 返回bull值，告知队列是否为空
  q.full()  # 类似方法empty
  ```

- 例子

  ```python
  In [28]: import multiprocessing
    
  In [29]: import time
  
  In [30]: def recv_data(q, data):
      ...:     if not q.full():
      ...:         print("队列未满，可放数据")
      ...:         q.put(data)
      ...:     else:
      ...:         print("队列已满！")
      ...:         
  
  In [31]: def get_data(q):
      ...:     if q.empty():
      ...:         print("队列为空！")
      ...:     else:
      ...:         print("队列中第一个数据为：%s" % q.get())
      ...:         
  
  In [38]: def main():
      ...:     q = multiprocessing.Queue(5)  # 创建队列，该队列由进程1和进程2共享
      ...:     p1 = multiprocessing.Process(target=recv_data, args=(q, 'data1'))  # 进程1
      ...:     p2 = multiprocessing.Process(target=recv_data, args=(q, 'data2'))  # 进程2
      ...:     p3 = multiprocessing.Process(target=recv_data, args=(q, 'data3'))  # 进程3
      ...:     p4 = multiprocessing.Process(target=get_data, args=(q,))  # 进程42
      ...:     p1.start()
      ...:     time.sleep(1)
      ...:     p2.start()
      ...:     time.sleep(1)
      ...:     p3.start()
      ...:     time.sleep(1)
      ...:     p4.start()
      ...: 
  
  In [39]: main()
  队列未满，可放数据
  队列未满，可放数据
  队列未满，可放数据
  队列中第一个数据为：data1    
  ```


# 5、进程池实现多任务

- 如果使用手动创建进程的方法，当有较多的进程要被创建时，会消耗系统大量的资源（进程的创建和销毁会消耗系统资源）
- 进程池：一次直接创建多个进程备用，每个进程处理完自己的任务后，不会立即被销毁，而是会等待执行下一个任务，除非主进程决定关闭进程池，这样便减少了创建和销毁进程所消耗的资源，举个例子，有100个任务需要完成，如果手动创建进程来执行的话，需要创建100个进程，但是如果使用进程池的话，可能10个进程都够用了，这100个任务在一个长度为10的队列里，轮流等待进入到进程池里执行
- 初始化一个进程池时，可以指定一个最大进程数，当有新的请求提交到进程池时，如果进程池还没有满，就会创建一个新的进程来执行该请求；若进程池里的进程数已达到最大值，那么该请求就会等待，直到有进程结束，才会使用刚才结束的进程来执行新的请求
- python中使用进程池的方法
  - `from multiprocessing import Pool`    
  - `p = Pool(3)`    返回一个进程池对象，这里的进程池里有3个进程备用
  - `p.apply(func, args=(), kwds={}, callback=None, error_callback=None)`
    - 绑定函数，args和kwds为传递给绑定的函数的位置参数和关键字参数
  - `p.close()`    关闭进程池，关闭后不再接受新的请求
  - `p.join()`    等待所有子进程完成，作用是阻塞主进程，必须放在`p.close()`后面

- 进程池里的进程之间的通信
  - `q = multiprocessing.Manager().Queue()`
    - 类似于`multiprocessing.Queue()`
  - `q.get()`和`q.put()`    类似`multiprocessing.Queue().get()`和`multiprocessing.Queue().put()`



