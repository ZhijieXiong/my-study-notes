[TOC]

# 1、var、let、const

- let声明将变量限制在一个作用域中（代码块，语句或表达式），在同一个作用域中，使用let声明的变量不能重名

- var只会把变量声明为全局变量或者函数局部变量（如for循环对于var声明的变量来说就不是一个作用域）

- 在一个作用域中可以使用"use strict"开启严格模式，这样所有新变量必须使用let或const声明

- 例子

  ```javascript
  // ES5
  var fun;
  for (var i = 0; i < 3; i++) {
  	if (i === 1) {
          fun = function () {
              return i;
          }
      }
  }
  console.log(fun());  // 结果为：3
  console.log(i);  // 结果为：3
  
  // ES6
  let fun;
  for (let i = 0; i < 3; i++) {
  	if (i === 1) {
          fun = function () {
              return i;
          }
      }
  }
  console.log(fun());  // 结果为：1
  console.log(i);  // 结果为：i不存在/未定义
  ```

- 使用const声明的非对象变量不可更改，例子如下

  ```javascript
  const TEST_DATA = 10;
  TEST_DATA = 100;  // 报错
  const ARR = [1, 2, 3];
  ARR = 100;  // 报错
  ARR[1] = 100;  // 不会报错
  ```

  - ES6中使用Object.freeze()冻结对象（即该对象的属性不能被增删改）

# 2、箭头函数

```javascript
// 例子1:有函数体
const fun = (a, b) => {
	c = a * b;
	return c;
}

// 例子2:无参数，无函数体，且只有一个返回值
const fun = () => 100;

// 例子3:一个参数，无函数体，返回一个值
const fun = x => x*2;
```

- 柯里化函数（高阶函数的应用）

  - 把接受多个参数的函数`func`变换成接受一个单一参数（原函数的第一个参数）的函数`func1`，并且返回一个接受余下参数的新函数`func2`，并且`func2`会返回结果（即`func`返回的结果）。

    ```javascript
    function func(x, y) {
        return x+y;
    }
    
    function func1(x) {
        return function func2(y) {
            return x+y;
        };
    }
    
    func(1, 2);  // 3
    func1(1)(2);  // 3
    ```

  - 上面例子在ES6中为

    ```javascript
    let func = (x) => {
        return (y) => {
    		return x + y;
    	};
    };
    
    // 简略写法
    let func = x => y => x+y;
    ```

  - n 个连续箭头组成的函数实际上就是柯里化了 n - 1次，例如

    ```javascript
    let func = x => y => z => x+y+z;  // 前两个箭头只是在传参数
    func(1)(2)(3);  // 6
    ```


# 3、rest接受多个参数到一个变量

```javascript
function howMany(...args) {
  return "You have passed " + args.length + " arguments.";
}
console.log(howMany(0, 1, 2)); // 输出：You have passed 3 arguments.
console.log(howMany("string", null, [1, 2, 3], { })); // 输出：You have passed 4 arguments.
```

# 4、spread展开一个数组：用在数组作函数参数时

```javascript
// 例子1
const arr = [6, 89, 3, 45];
const maximus = Math.max(...arr); // 返回 89

// 例子2
const arr1 = ['JAN', 'FEB', 'MAR', 'APR', 'MAY'];
let arr2;
(function() {
  "use strict";
  arr2 = [...arr1]; // 改变这一行
})();
```

# 5、解构语法

```javascript
// 例子1
let voxel = {x: 3.6, y: 7.4, z: 6.54 };
const { x, y, z } = voxel;  // x = 3.6, y = 7.4, z = 6.54
const { x : a, y : b, z : c } = voxel;  // a = 3.6, b = 7.4, c = 6.54

// 例子2
const a = {
  start: { x: 5, y: 6},
  end: { x: 6, y: -9 }
};
const { start : { x: startX, y: startY }} = a;
console.log(startX, startY); // 5, 6

// 例子3
const [a, b] = [1, 2, 3, 4, 5, 6];
console.log(a, b); // 1, 2
const [a, b,,, c] = [1, 2, 3, 4, 5, 6];
console.log(a, b, c); // 1, 2, 5

// 例子4
const [a, b, ...arr] = [1, 2, 3, 4, 5, 7];
console.log(a, b); // 1, 2
console.log(arr); // [3, 4, 5, 7]

// 例子5：在函数参数中解构对象
const profileUpdate = ({ name, age, nationality, location }) => {
  /* 对这些参数执行某些操作 */
}
```

# 6、模版字面量

```javascript
const person = {
  name: "Zodiac Hasbro",
  age: 56
};

// string interpolation
// ${}为占位符，``扩起来的字符串可以换行
const greeting = `Hello, my name is ${person.name}! 
I am ${person.age} years old.`;

console.log(greeting); // 打印出
// Hello, my name is Zodiac Hasbro!
// I am 56 years old.
```

# 7、语法糖

```javascript
// 创建字面量对象
const createPerson = (name, age, gender) => {
  "use strict";
  // 在这行以下修改代码
  return {
    name,
    age,
    gender
  };
  // 在这行以上修改代码
};
console.log(createPerson("Zodiac Hasbro", 56, "male")); // 返回正确的对象

// 声明函数
const bicycle = {
  gear: 2,
  setGear(newGear) {
    "use strict";
    this.gear = newGear;
  }
};
bicycle.setGear(3);
console.log(bicycle.gear);

// 创建构造函数
class SpaceShuttle {
  constructor(targetPlanet){
    this.targetPlanet = targetPlanet;
  }
}
const zeus = new SpaceShuttle('Jupiter');  // 自动调用constructor函数
```

# 8、获取和改变私有变量

```javascript
class Book {
  constructor(author) {
    this._author = author;
  }
  // getter
  get writer(){
    return this._author;
  }
  // setter
  set writer(updatedAuthor){
    this._author = updatedAuthor;
  }
}
const lol = new Book('anonymous');
console.log(lol.writer);  // anonymous
lol.writer = 'wut';
console.log(lol.writer);  // wut
```

- 注意getter和setter不是函数

# 9、for循环

- `for (let index in arr)`获取的index是arr的索引
- `for (let item of arr)`获取的是arr的元素
- `for (let prop in obj)`获取的是obj的属性名

# 10、类

- 类声明（不会像函数声明一样被提升）

  ```javascript
  class Rectangle {
    constructor(height, width) {
      this.height = height;
      this.width = width;
    }
  }
  ```

- 类表达式

  ```javascript
  // unnamed
  let Rectangle = class {
    constructor(height, width) {
      this.height = height;
      this.width = width;
    }
  };
  console.log(Rectangle.name);
  // output: "Rectangle"
  
  // named
  let Rectangle = class Rectangle2 {
    constructor(height, width) {
      this.height = height;
      this.width = width;
    }
  };
  console.log(Rectangle.name);
  // output: "Rectangle2"
  ```

- constructor方法（构造函数）：用于创建和初始化对象

- super函数：调用父类的构造函数

# 11、this指向

- ES5：函数中this指向是调用该函数的环境

  - this是函数执行过程中，自动生成的一个内部对象，是指当前的对象，只在当前函数内部使用。（**this对象是在运行时基于函数的执行环境绑定的：在全局函数中，this指向的是window；当函数被作为某个对象的方法调用时，this就等于那个对象**）

  ```javascript
  // 1、全局调用
  function test1() {
      console.log(this)
  }
  test1()
  >> Window {window: Window, self: Window, document: document, name: "", location: Location, …}
  
  
  
  // 2、对象调用方法
  var name = "a"
  function Person() {
      this.name = "b";
      this.printName = function () {
          console.log(this.name);
      }
  }
  var p = new Person()
  p.printName()  // printName的执行环境是p对象
  >> b
  var printName22 = p.printName
  printName22()  // printName的执行环境是window对象
  >> a
  
  
  
  // 3、嵌套的调用
  function Person() {
      this.name = "a";
      this.a = function () {
          return function () {
              console.log(this.name);
          }
      }
  }
  var p = new Person()
  p.a()()  // 这里this指向的是p，而不是window，因为p是“父级”，window是”爷爷级“
  >> a
  
  
  // 4、匿名函数
  name = "a";
  var obj = {
      name: "b",
      test: function () {
          return function () {
              console.log(this.name);
          }
      }
  }
  obj.test()();  // 匿名函数的this是window
  >> a
  ```

  - 总结：ES5中函数运行时决定this的指向

- ES6：箭头函数的this是在定义函数时绑定的，不是在执行过程中绑定的。

  - this 在箭头函数中所指代的并不是运行时的对象，而是在定义的时候所在的对象决定。也就是根据外层的作用域（函数或者全局）来确定。
  - 简单的说，函数在定义时，this就继承了定义函数的对象。很好的解决匿名函数和setTimeout和setInterval的this指向问题

  ```javascript
  // 例子1
  var value ="outer";
  var obj ={
  	value:"inner",
  	getValue:()=>{
  		console.log(this.value);
  	}
  }
  obj.getValue()  // 箭头函数生效是在obj对象生成的时候，箭头函数总是指向定义生效所在的对象，这里即window
  				// 箭头函数中的this是来自父块的上下文this
  				// es6中箭头函数的this是来自父块上下文环境，如果父块还是箭头函数，依次往上找
  >> outer
  ```

  - 总结
    - 构造函数里this指向实例化对象
    - 方法里this指向调用者
      - 不调用时指向原型对象
      - 调用时指向调用者

