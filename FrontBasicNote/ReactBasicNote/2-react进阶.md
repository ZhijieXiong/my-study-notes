[TOC]

# 1、React生命周期

- 生命周期的三种状态
  - `mount`  将组件挂载到DOM上
  - `update`  将数据更新到DOM上
  - `unmount`  将组件从DOM中移除
- 生命周期钩子函数
  - `componentWillMount`
  - `componentDidMount`
  - `componentWillReceiveProps`
  - `shouldComponentUpdate`
    - 返回一个布尔值，如果希望更新，则返回true，反正返回false
  - `componentWillUpdate`
  - `componentDidUpdate`
  - `componentWillUnmount`
- 通过在组件（即类class）中重写这些方法来达到一些目的
- 生命周期钩子函数执行时间
  - 首次渲染
    - `constructor`  ==>  `componentWillMount`  ==>  `render`  ==>  `componentDidMount`
  - 数据更新（假如shouldComponentUpdate返回true）
    - `shouldComponentUpdate`  ==>  `componentWillUpdate`  ==>  `render`  ==>  `componentDidUpdate`

# 2、React插槽

- 插槽：父组件可以控制子组件的内容

- 原理：父组件把html通过props传入到子组件（React的插槽需要自己写）

  ```jsx
  // 例子
  class Parent extends React.Component {
    constructor(props) {
      super(props);
    }
    render() {
      retrun (
        <div>
          {this.props.children.map((item, index) => {
            // ...
          })}
        </div>
      );
    }
  }
  
  ReactDOM.render(
    (
      <Parent>  {/* 这3个h1标签会传到props.children数组里 */}
        <h1>1</h1>  {/* h1同样可以传props参数 */}
        <h1>2</h1>
        <h1>3</h1>
      </Parent>
    ), document.getElementById("root")
  );
  ```

# 3、React路由router

- 前端路由的两种方法
  - hash模式
  - history模式（需要后端配合）

- ReactRouter三大组件

  - `Router`  所有路由组件的根组件，包裹路由规则的最外层容器
  - `Route`  路由规则匹配组件，显示当前规则对应的组件
  - `Link`  路由跳转的组件（相当于a标签）

-  深入了解

  - `Router`组件

    - 一个组件/JSX中`<Router></Router>`的个数不限
    - `<Router basename="/home"></Router>`  规定根路径

  - `Route`组件

    - `<Route exact path="/home" component={Home}></Route>`  exact表示精确匹配

  - `Link`组件

    - `<Link to="/home"></Link>`  to可以是字符串
    - `<Link to={ {path: "/home", search: "?key=xxx", hash: "#aaa"} }></Link>`  to可以是对象
      - 这样href就是"/home?key=xxx*aaa"，它会自动拼接路径
    - `<Link to="/home" replace></Link>`  replace表示直接替换当前页面，而不是前进
      - 当前页面是`localhost:3000/`，则历史history为`["/"]`
      - 进入到about页面（不是replace），则history为`["/", "/about"]`
      - 此时再进入home页面，则history为`["/", "/home"]`，这里是直接把`/about`替换了

  - 当调用路由显示相对应的组件时（即`<Route path="/home" component={Home} />`），会自动传一些参数到Home组件的props里，如下

    - `location`  即对应的Link组件的to

    - `history`

      - `history`里面有各种方法，可用于前进后退等，例子如下

        ```jsx
        import React from 'react';
        import ReactDOM from 'react-dom';
        import {BrowserRouter as Router, Route, Link, Redirect} from 'react-router-dom';
        
        function Home(props) {
          return (
            <div>首页</div>
          );
        }
        
        class About extends React.Component {
          constructor(props) {
            super(props);
          }
        
          hanldeClick = () => {
            let state = {};
            this.props.history.push("/", state);  // 除了push表示跳转，还有go(一个数字，可以为负)、replace、goback
          }
        
          render() {
            return (
              <div>
                About<br/>
                <button onClick={() => {this.hanldeClick()}}>跳转到home</button>
              </div>
            );
          }
        }
        
        class App extends React.Component {
          constructor(props) {
            super(props);
          }
        
        
          render() {
            return (
              <Router>
                <Route path="/home" component={Home} />
                <Route path="/about" component={About} />
              </Router>
            );
          }
        }
        ```

        

    - `match`

      - `match`下的params里可以获取参数，如id
      - 还有一些属性，如`url`等

- `Switch`组件

  - `Switch`组件可以让自己内部的`Route`只匹配一次，只要匹配到了，剩下的路由规则将不再匹配

  - 不使用`Switch`的例子

    ```jsx
    function App(props) {
    	return (
    		<Router>
    			<Route path="/abc" component={Com1}></Route>
    			<Route path="/abc" component={Com2}></Route>
    		</Router>
    	);
    }
    // 结果是访问/abc会同时显示Com1和Com2
    ```

  - 使用`Switch`

    ```jsx
    function App(props) {
    	return (
    		<Router>
    			<Switch>
                    <Route path="/abc" component={Com1}></Route>
                    <Route path="/abc" component={Com2}></Route>
    			</Switch>
    		</Router>
    	);
    }
    // 结果是访问/abc会显示Com1
    ```

    

- 重定向

  - 如果访问某个组件时，有重定向组件，那么就会修改路由（即路径），显示所对应的组件内容

    ```jsx
    import React from 'react';
    import ReactDOM from 'react-dom';
    import {BrowserRouter as Router, Route, Link, Redirect} from 'react-router-dom';
    
    function Home(props) {
      return (
        <Redirect to="/login"></Redirect>
      );
    }
    
    function Login(props) {
      return (
        <div>登入页面</div>
      );
    }
    
    function App(props) {
      return (
        <Router>
          <Route path="/home" component={Home}></Route>
          <Route path="/login" component={Login}></Route>
        </Router>
      );
    }
    ```

# 4、React状态管理redux

- redux用于管理react的数据（状态），适合于中大型应用，作用如下	
  - 解决组件之间的数据通信
  - 解决数据和交互较多的应用
- 安装：`npm install redux`
- `store`  数据仓库
- `state`  （对象） 数据仓库里的数据存放到state里
- `action`  动作，触发数据改变的方法
- `dispatch`  将动作触发成方法
- `reducer`  （函数） 获取动作，改变数据，生成新state，从而改变页面

```jsx
import React from 'react';
import ReactDOM from 'react-dom';
import Redux, { createStore } from 'redux';

const reducer = (state={num: 0}, action) => {  // state为初始状态
  switch (action.type) {
    case "add":
      state.num++;
      break;
    case "minus":
      state.num--;
      break;
  }
  return {...state};  // 要返回一个全新的状态
}

const store = createStore(reducer);

function add() {
  store.dispatch({  // dispatch调用reducer
    type: "add"
  });
}

function minus() {
  store.dispatch({
    type: "minus"
  });
}

function Counter(props) {
  let state = store.getState();
  return (
    <div>
      <h1>计数：{state.num}</h1>  {/* 获取数据 */}
      <button onClick={add}>加1</button>
      <button onClick={minus}>减1</button>
    </div>
  );
}

ReactDOM.render(<Counter />, document.getElementById("root"));

store.subscribe(() => {  // 监听，每次数据变化，触发函数
  ReactDOM.render(<Counter />, document.getElementById("root"));
});
```

# 5、react-redux

- `Provider`  自动将store和组件进行关联
- 映射函数，即下面例子的`mapStateToProps`和`mapDispatchToProps`，用于将store映射到组件的props里
- `connect`  将组件和数据连接

```jsx
import React from 'react';
import ReactDOM from 'react-dom';
import {createStore} from 'redux';
import {Provider, connect} from 'react-redux';

const store = createStore(reducer);

function reducer(state={num: 0}, action) {
  switch (action.type) {
    case "add":
      state.num++;
      break;
    default:
      break;
  } 
  return {...state};
}

const addAction = {
  type: "add"
}

function mapStateToProps(state) {  // 将state映射到props上
  return {
    value: state.num
  };
}

function mapDispatchToProps(dispatch) {  // 将dispatch映射到props上
  return {
    handleAddClick: () => {
      dispatch(addAction);
    }
  };
}


class Counter extends React.Component {
  render() {
    const value = this.props.value;
    const onAddClick = this.props.handleAddClick;
    return (
      <div>
        计数：{value}
        <button onClick={onAddClick}>加1</button>
      </div>
    );
  }
}

// 将mapStateToProps、mapDispatchToProps映射到组件上，形成一个新到组件
const App = connect(
  mapStateToProps,
  mapDispatchToProps
)(Counter);


ReactDOM.render(  // 使用Provider就不用subscripe
  (
    <Provider store={store}>
      <App />
    </Provider>
  ),document.getElementById("root")
);
```

