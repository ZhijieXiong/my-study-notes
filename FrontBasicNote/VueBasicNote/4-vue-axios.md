- 安装：npm install axios --save

- 请求方式

  ```javascript
  axios(config)  // 默认get请求
  axios.request(config)
  axios.get(url[, config])
  axios.post(url[, config])
  axios.options(url[, config])
  axios.delete(url[, config])
  axios.head(url[, config])
  axios.patch(url[, config])
  ```

- 例子

  ```javascript
  // 单个请求
  axios.post('http://127.0.0.1:8888/api/courses', {
    'showState': 'category',
    'courseCategory': 'C'
  }, {}).then((res) => {
    console.log(res.data)
  })
  
  // 多个请求
  axios.all([
    axios.post("http://127.0.0.1:8888/api/courses", {
      showState: "category",
      courseCategory: "C",
    }),
    axios.post("http://127.0.0.1:8888/api/courses", {
      showState: "category",
      courseCategory: "Java",
    })
  ]).then((results) => {
    console.log(results);
  });
  ```

- 全局配置

  ```javascript
  axios.defaults.baseURL = 'http://127.0.0.1/8888';
  ```

  ![image-20210520130052351](/Users/dream/Desktop/StudyData/前端相关/img/axios-常见配置.png)

- axios的实例

  ```javascript
  // 每个实例有自己独立的配置
  const axiosInstance1 = axios.create({
    baseURL: 'http://127.0.0.1:8888',
    headers: {
      'Content-Type': 'application/json',
      // ...
    },
    // ...
  })
  ```

- 封装axios，抽象为一个模块

  ```javascript
  import axios from "axios";
  
  export function request(axiosBaseCfg, axiosCfg) {
    const instance = axios.create(axiosBaseCfg);
    return instance(axiosCfg);
  }
  ```

- 拦截器（最好一起封装）

  ```javascript
  const axiosInstance1 = axios.create({
    baseURL: 'http://127.0.0.1:8888',
    headers: {
      'Content-Type': 'application/json',
      // ...
    },
    // ...
  })
  
  axiosInstance1.interceptors.request.use((config) => {
    // 请求成功
    return config;  // 必须返回才能发送数据
  }, (err) => {
    // 请求失败
    return err;
  });
  
  axiosInstance1.interceptors.response.use((res) => {
    // 响应成功
    return res.data;
  }, (err) => {
    // 响应失败
    return err;
  });
  ```

  