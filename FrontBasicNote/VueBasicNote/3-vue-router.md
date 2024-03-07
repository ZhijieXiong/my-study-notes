- 步骤
  - 导入路由对象，调用`Vue.use(VueRouter)`
  - 创建路由实例，传入路由映射配置
  - Vue实例中挂载创建的路由实例

- 详细过程

  ```javascript
  // router/index.js
  import Vue from 'vue'
  import VueRouter from 'vue-router'
  
  Vue.use(VueRouter)
  
  const routes = [
    {
      path: '/',
      redirect: '/hoem'
    },
    {
      path: '/home',
      name: 'Home',
      component: null
    },
    {
      path: '/about',
      name: 'About',
      component: null
    }
  ]
  
  const router = new VueRouter({
    routes,
    mode: 'history'  // 不使用hash监听前端路由，而使用history
  })
  
  export default router
  ```

  ```vue
  // App.vue
  <template>
    <div id="app">
      <div id="nav">
        <router-link to="/">Home</router-link> 
        <router-link to="/about">About</router-link>
        <router-view></router-view>  <!-- 路由的组件所在的位置 -->
      </div>
      <router-view/>
    </div>
  </template>
  
  <style>
  
  </style>
  ```

  ```javascript
  import Vue from 'vue'
  import App from './App.vue'  // 导入App组件
  import router from './router'  // 导入router组件
  
  
  new Vue({
    router,
    render: h => h(App)
  }).$mount('#app')
  ```

- router-link的属性

  - to：跳转的路径
  - tag：渲染成标签的类型，如tag=button即表示连接为按钮
  - replace：使用replaceState而不是pushState

- 代码实现路由

  ```javascript
  this.$router.push('/home')
  this.$router.replace('/home')
  ```

- 动态路由，类似react-router

  ```vue
  // router/index.js
  const routes = [
    {
      path: '/user/:id',
      component: () => import('../components/User.vue')
    }
  ]
  
  
  // App.vue
  <template>
    <div id="app">
      <div id="box">
        <el-button-group class="btn-group">
          <el-button type="primary">
            <router-link v-bind:to="'/user/' + id">用户</router-link>
          </el-button>
        </el-button-group>
        <router-view />
      </div>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        id: 'dream'
      }
    }
  }
  </script>
  ```

  - v-bind中，双引号为js表达式，单引号为字符串
  - \$router是创建的路由对象，\$route是当前活跃的路由对象
  - 获取动态路由参数，可以使用\$route，即`{{$route.params.id}}`获取

- 路由懒加载（用到时再加载）：一个路由打包为一个js文件，而不是把所有前端路由组件都打包到一起

  - 下面写法为非懒加载

    ```javascript
    import User from '../components/User.vue'
    
    const routes = [
      {
        path: '/user/:id',
        component: User
      }
    ]
    ```

  - 下面写法为懒加载

    ```javascript
    const routes = [
      {
        path: '/user/:id',
        component: () => import('../components/User.vue')
      }
    ]
    ```

- 嵌套路由

  ```javascript
  const routes = [
      {
          path: '/data',
          name: 'data',
          component: () => import('../views/Data.vue'),
          children: [
            {  // 默认显示内容
          	path: '',
          	redirect: 'news'
      	  },
            {
              path: 'news',  // 这里不用加 /，最后路由为 /data/news
              component: () => import('../views/News.vue')  // 需要到Data组件里加router-view占位
            },
            {
              path: 'info',
              component: () => import('../views/Info.vue')
            }
          ]
      }
  ]
  ```

- 添加查询字符串传递参数

  ```vue
  <router-link v-bind:to="{
  	path: '/user',
  	query: {
  		name: 'xzj'
  	}
  }">用户</router-link>
  ```

- 补充：\$router和\$route实际上是加到Vue原型上的，所有可以再template里访问到它们

- 导航守卫

  ```javascript
  new Vue({
    router,
    // store,
    render: (h) => h(App),
  }).$mount("#app");
  
  
  // 前置守卫（钩子）
  router.beforeEach((to, from, next) => {
    // to和from都是$route，可以往route里加meta属性，在meta里加一些属性
    next();  // 必须调用next
  })
  // 后置守卫（钩子）
  router.afterEach((to, from) => {
    // to和from都是$route，可以往route里加meta属性，在meta里加一些属性
  })
  ```

  - 上面的是全局守卫，除此以外还有路由独享的守卫和组件守卫

    ```javascript
    {
        path: '/data',
        name: 'data',
        component: () => import('../views/Data.vue'),
        beforeEnter: (to, from ,next) => {},
        afterEnter: (to, from) => {}
    }
    ```

  - 写到组件内就是组件内的守卫

- keep-alive

  - router-view也是一个组件，如果该组件被包在keep-alive里，所有路径匹配到的组件都会被缓存
  - keep-alive是vue内置的组件

  ```vue
  <keep-alive>
  	<router-view/>
  </keep-alive>
  ```

  
