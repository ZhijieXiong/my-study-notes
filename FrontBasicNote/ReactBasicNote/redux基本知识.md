# 1、基本使用

- 流程如下

  - 第一步：创建sotre（`const store = createStore(reducer, defaultState)`）

    - store存储所有数据

  - 第二步：用户发出action（`const action = {type: "toDoSomething"}`），store通过dispatch改变state（`store.dispatch(action)`），从而改变view

    - state和view一一对应，可以通过getState获取state（`const state = store.getState()`）
    - dispatch是view发出action的唯一方法
  - 注意：常自定义函数`actionCreator()`创建`action`对象
  
- 第三步：store收到action后，通过reducer计算出新的state
  
    ```javascript
    const reducer = function (state, action){
    	pass;
    	return newState;
    }
  ```
  
  - reducer无需手动调用，在创建store的时候就可以将reducer传入，这样store每次调用dispatch时就会自动触发reducer
    - reducer不应调用 API 接口，也不应存在任何潜在的副作用；reducer 只是一个接受状态（state）和动作（action），然后返回新状态的纯函数。
  - redux的一个原则是state是只读的，所以reducer应该返回一个新的state，而不是修改state
  
  - 第四步：可以通过subscribe设置监听函数（`const unSubscribe = store.subscribe(listener)`）
  
    - 可以通过subscribe来实现view的自动渲染
    - 调用unSubscribe可以中止监听

# 2、异步操作

- 什么是异步操作

  - 操作开始时发出一个动作（`dispatch(startAction)`）
  - 操作结束时，又发出一个动作（`dispatch(endAction)`）
    - 操作结束又可以分为操作成功和操作失败两种情况

- 什么是中间件（`middlewares`）

  - 中间件就是一个函数，用于对`dispatch`改造

  - 中间件可以使用别人写好的

    ```react
    import { createStore, applyMiddleware } from 'redux';
    import thunk from 'redux-thunk';
    import reducer from './reducers';
    
    const store = createStore(
      reducer,
      applyMiddleware(thunk)
    );
    ```

    - 这里`thunk`就是一个中间件，在创建store时，把`applyMiddleware(thunk)`传给`createStore`就会改造dispatch，使之能够接收函数参数（原本dispatch只能接受对象参数）

- 异步操作的一个例子

  ```javascript
  const fetchPosts = postTitle => (dispatch, getState) => {  
  // fetchPosts是一个动作生成器（actionCreator）
    dispatch(requestPosts(postTitle));  
    // 先发出动作dispatch(requestPosts(postTitle))
    return fetch(`/some/API/${postTitle}.json`)  
    // 进行异步操作，请求数据
      .then(response => response.json())  
      // 拿到数据转成json格式
      .then(json => dispatch(receivePosts(postTitle, json)));  
      // 异步操作完成，发出动作dispatch(receivePosts(postTitle, json))
    };
  };
  
  // 使用方法一
  store.dispatch(fetchPosts('reactjs'));
  // 使用方法二
  store.dispatch(fetchPosts('reactjs')).then(() =>
    console.log(store.getState())
  );
  ```

  ```javascript
  const REQUESTING_DATA = 'REQUESTING_DATA'
  const RECEIVED_DATA = 'RECEIVED_DATA'
  
  const requestingData = () => { return {type: REQUESTING_DATA} }
  const receivedData = (data) => { return {type: RECEIVED_DATA, users: data.users} }
  
  // actionCreator：需要返回一个以dispatch为参数的函数
  const handleAsync = () => {
    return function(dispatch) {
      // 在这里 dispatch 请求的 action
      dispatch(requestingData());
      setTimeout(function() {
        let data = {
          users: ['Jeff', 'William', 'Alice']
        }
        // 在这里 dispatch 接收到的数据 action
        dispatch(receivedData());
      }, 2500);
    }
  };
  
  const defaultState = {
    fetching: false,
    users: []
  };
  
  const asyncDataReducer = (state = defaultState, action) => {
    switch(action.type) {
      case REQUESTING_DATA:
        return {
          fetching: true,
          users: []
        }
      case RECEIVED_DATA:
        return {
          fetching: false,
          users: action.users
        }
      default:
        return state;
    }
  };
  
  const store = Redux.createStore(
    asyncDataReducer,
    Redux.applyMiddleware(ReduxThunk.default)
  );
  ```

  