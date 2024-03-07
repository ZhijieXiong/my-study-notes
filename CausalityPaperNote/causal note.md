- 时间序列传统因果发现：granger causality
- Linear Latent Causal Processes with Generalized Laplacian Noise

# Treatment Effect Estimation with Data-Driven Variable Decomposition

- ATE estimator
  - 对于二元干预，$ATE = \mathbb{E}[Y(1) - Y(0)]$
  - 在观察研究中，存在反事实问题，无法获得ATE
  - 如果直接计算ATE，会引入很大的偏差，因为没有考虑confounder对treatment的影响，所以treatment不是随机分配的
  - 提出propensity score来计算ATE
    - propernsity score: $e(U) = p(T=1|U) = p(T=1|X) = e(X)$
    - IPW: $Y^* = Y^{obs}\cdot\frac{T-e(U)}{e(U)\cdot(1-e(U))} = Y^{obs}\cdot\frac{T-e(X)}{e(X)\cdot(1-e(X))}, \quad \hat{ATE}_{IPW} = \hat{\mathbb{E}}[Y^*]$
    - $Y^* = Y^{obs}(\frac{T}{e(X)} - \frac{1-T}{1-e(X)})$
  - 过去基于propensity score的方法在计算ATE时将所有变量都视为confounder，导致计算出来的ATE估计不准确，并且方差波动很大
  - 本文提出的ATE估计：$Y^+ = (Y^{obs} - \phi(Z))\cdot\frac{T-e(X)}{e(X)\cdot(1-e(X))},\quad \hat{ATE}_{adj} = \hat{\mathbb{E}}[Y^+]$

# Neural Granger Causality

- 动机：格兰杰因果估计的方法主要分为两种，即model-based and model-free
  - model-based的方法主要有两种，线性假设的模型和VAR（vector autoregressive）。VAR需要指定最大lag（因果的滞后时间），如果lag过小，则学出来的因果关系不够充分，如果lag过大，容易过拟合。model-based的方法在现实世界数据上容易失效，因为现实世界的因果通常是非线性的
  - model-free的方法包括transfer entropy和directed information，它们可以用来估计非线性的因果。但是这些方法的估计方差很大，并且需要大量数据来进行可靠的估计，此外当数据维度高时，这类方法也不适合
  - 基于神经网络的方法（如AR-MLP、RNN）虽然在时间序列预测任务上表现效果很好，但却是黑盒模型，不能为多变量时间序列的结构关系提供解释，并且需要大量模型参数和数据，也并不适合高维数据

# LEARNING TEMPORALLY CAUSAL LATENT PROCESSES FROM GENERAL TEMPORAL DATA

- 目的：从测量到的时序数据中恢复出“时间延迟的因果的潜在变量”（time-delayed latent causal variables）并识别这些“潜在变量”之间的因果关系
- 现有工作
  - 第1类：提取观测变量之间的因果关系
    - Peter Spirtes and Clark Glymour. An algorithm for fast recovery of sparse causal graphs. *Social science computer review*, 9(1):62–72, 1991.
    - David Maxwell Chickering. Optimal structure identification with greedy search. *Journal of machine learning research*, 3(Nov):507–554, 2002.
    - Shohei Shimizu, Patrik O Hoyer, Aapo Hyvärinen, Antti Kerminen, and Michael Jordan. A linear non-gaussian acyclic model for causal discovery. *Journal of Machine Learning Research*, 7(10), 2006.
  - 第2类：给定因果变量进行推理
    - Peter L Spirtes, Christopher Meek, and Thomas S Richardson. Causal inference in the presence of latent variables and selection bias. *arXiv preprint arXiv:1302.4983*, 2013.
  - 第3类：假设潜在因果变量是独立的，识别潜在因果变量
    - Francesco Locatello, Stefan Bauer, Mario Lucic, Gunnar Raetsch, Sylvain Gelly, Bernhard Schölkopf, and Olivier Bachem. Challenging common assumptions in the unsupervised learning of disentangled representations. In *international conference on machine learning*, pp. 4114–4124. PMLR, 2019.
  - 第4类：提取潜在因果变量之间的关系
    - 利用the vanishing Tetrad conditions（在该条件下线性高斯模型的潜在因果变量可识别），提出GIN（Generalized Independent Noise）条件用于估计线性非高斯潜在变量的因果图：Feng Xie, Ruichu Cai, Biwei Huang, Clark Glymour, Zhifeng Hao, and Kun Zhang. General- ized independent noise condition for estimating latent variable causal graphs. *arXiv preprint arXiv:2010.04917*, 2020.
      - the vanishing Tetrad conditions：Charles Spearman. Pearson’s contribution to the theory of two factors. *British Journal of Psychol- ogy*, 19:95–101, 1928.
      - 线性高斯模型：R. Silva, R. Scheines, C. Glymour, and P. Spirtes. Learning the structure of linear latent variable models. *Journal of Machine Learning Research*, 7:191–246, 2006.
      - 后续工作：Adams, N. R. Hansen, and K. Zhang. Identification of partially observed linear causal models: Graphical conditions for the non-gaussian and heterogeneous cases. In *Conference on Neural Information Processing Systems (NeurIPS)*, 2021.
  - 第5类：非线性独立组件分析（Independent Component Analysis, ICA）
    - 假设潜在变量在一定辅助信息u（如时间索引、域标签、类标签）条件下独立，深度生成模型就可能可以拟合x和u（x是观测数据）。也就是说they can recover independent factors up to a certain transformation of the original latent variables under proper assumptions
    - Aapo Hyvarinen and Hiroshi Morioka. Unsupervised feature extraction by time-contrastive learning and nonlinear ica. *Advances in Neural Information Processing Systems*, 29:3765–3773, 2016.
    - Aapo Hyvarinen and Hiroshi Morioka. Nonlinear ica of temporally dependent stationary sources. In *Artificial Intelligence and Statistics*, pp. 460–469. PMLR, 2017.
    - Aapo Hyvarinen, Hiroaki Sasaki, and Richard Turner. Nonlinear ica using auxiliary variables and generalized contrastive learning. In *The 22nd International Conference on Artificial Intelligence and Statistics*, pp. 859–868. PMLR, 2019.
    - Ilyes Khemakhem, Diederik Kingma, Ricardo Monti, and Aapo Hyvarinen. Variational autoen- coders and nonlinear ica: A unifying framework. In *International Conference on Artificial Intel- ligence and Statistics*, pp. 2207–2217. PMLR, 2020.
    - Peter Sorrenson, Carsten Rother, and Ullrich Köthe. Disentanglement by nonlinear ica with general incompressible-flow networks (gin). *arXiv preprint arXiv:2001.04872*, 2020.
  - 第6类：和本文最接近的工作，要求潜在因果变量是互相独立，以便具备可识别性
    - David Klindt, Lukas Schott, Yash Sharma, Ivan Ustyuzhaninov, Wieland Brendel, Matthias Bethge, and Dylan Paiton. Towards nonlinear disentanglement in natural data with temporal sparse coding. *arXiv preprint arXiv:2007.10930*, 2020.
    - Aapo Hyvarinen and Hiroshi Morioka. Nonlinear ica of temporally dependent stationary sources. In *Artificial Intelligence and Statistics*, pp. 460–469. PMLR, 2017.
- 动机
  - 现实世界的观测变量多数情况不能直接结构化为因果变量，如图像的像素，所以第1、2类工作不行
  - 该任务的挑战在于潜在因果变量在大多数情况下是不可识别的，或者说不能唯一恢复的（Aapo Hyvärinen and Petteri Pajunen. Nonlinear independent component analysis: Existence and uniqueness results. *Neural networks*, 12(3):429–439, 1999.）
  - 然而，现有方法（第3、4类）受到各种各样限制，如要求潜在因果变量之间是线性关系、要求一定类型的稀疏或最小假设以及需要大量可观测数据作为潜在变量的子节点
  - ICA的现有工作仅考虑了潜在因果变量之间独立或者是线性关系的条件下，来发现因果，当潜在因果变量互相不独立或者互相是非线性关系时，现有的ICA方法无法解决，所以第5类工作不行
- 本文贡献
  - 研究场景
    - 观测的时序数据中没有直接的因果关系，但是观测数据由底层的潜在过程（latent processes，和latent factors同义）或混淆因子（confounders）生成，并且互相之间（观测数据和潜在变量、潜在变量之间）存在时间滞后的因果关系（time-delayed causal relations）。时间滞后：指过去对未来有影响，未来对过去无影响
    - x~t~ = g(z~t~)：观测变量是潜在变量的非线性可逆混合
  - 两种设置
    - 非参数化非平稳设置（a nonparametric, nonstationary setting）
      - $z_{it} = f_i(Pa(z_{it}), \epsilon_{it})$
      - $z_{it}$：其中一个潜在因果变量
      - $f_i$：unknown nonparametric function with some time delay
      - $Pa(z_{it})$：$z_{it}$的父节点，也就是其原因变量
      - $\epsilon_{it} \sim p_{\epsilon}$：噪音项
    - 参数化设置：$f_i$是线性映射
  - 两个目标
    - 理解在什么条件下，潜在时间因果过程是可识别的
    - 开发一个有理论基础的训练框架，在适当设置下，强迫假设的条件成立
  - 贡献
    - 在两种设置下，都establish the identifiability of the latent factors and their causal influences, rendering them recoverable from the observed data
    - 提出了LEAP（Latent tEmporally cAusal Processes estimation）
- 提出的条件
  - 非参数化（NonparametricProcesses，NP process）设置：$f_i$三阶可微，$g$是单射并且处处可微的
    - $\underbrace{\mathbf{x}_t = g(\mathbf{z}_t)}\limits_{Nonlinear\ mixing},\quad \underbrace{z_{it} = f_i(\{z_{j,t-\tau} | z_{j,t-\tau} \in \mathbf{Pa}(z_{it})\}, \epsilon_{it})}\limits_{Nonparametric\ transition}\ with\ \underbrace{\epsilon_{it} \sim p_{\epsilon_{i}|\mathbf{u}}}\limits_{Nonstationary\ noise}$
    - $$\mathbf{z}_t \in \mathbb{R}^n$$
    - 假设1（Nonstationary Noise）
      - 以**u**为条件时，噪声是非平稳的
      - 从生成合成数据的代码来看，该条件的物理含义是不同域/分布的数据里的噪声受不同信号调制
    - 假设2（Independent Noise）
    - 假设3（Sufficient Variability）
  - 参数化设置：潜在因果变量是一个自回归过程，并且是线性求和的；$g$是单射并且处处可微的
    - $\underbrace{\mathbf{x}_t = g(\mathbf{z}_t)}\limits_{Nonlinear\ mixing},\quad \underbrace{\mathbf{z}_{t} = \sum\limits_{\tau=1}^L \mathbf{B}_{\tau}\mathbf{z}_{t-\tau} + \epsilon_t}\limits_{Linaer\ additive\ transition}\ with\ \underbrace{\epsilon_{it} \sim p_{\epsilon_{i}}}\limits_{Independent\ noise}$
    - $\mathbf{z}_t \in \mathbb{R}^n$
    - $\mathbf{B}_{\tau} \in \mathbb{R}^{n \times n}$是状态转移矩阵
    - $\epsilon_{it}$假设是平稳、时空独立的
    - 假设1（Generalized Laplacian Noise）
      - 每个数据生成过程中的噪声之间相互独立，并且从拉普拉斯分布中采样
    - 假设2（Nonsingular State Transitions）
      - 生成数据过程中使用的转移矩阵$\mathbf{B}_\tau$要求是满秩的
      - 合成数据代码实现：随机生成大量矩阵，得到每个矩阵的条件数，选择一个合适的值（如4分位点）作为生成转移矩阵的条件数阀值，这样生成的转移矩阵满足满秩要求，并且计算稳定，因为条件数低

- 方法

  - 为了保证噪声满足非平稳条件，使用基于流的估计器学习噪声分布

    - 基于流的估计器（本文使用的是Neural Spline Flows）：一种生成模型，和VAE区别在与基于流的生成器不是去估计参数的后验分布（VAE的问题就在于它估计后验分布时，是去最大化对数似然函数，再进一步转换为最小化ELBO，而经过中间这一道转换，就不知道生成的参数后验分布和其真实分布究竟差得有多远），而是直接去估计参数的分布

    - 思想

      - 选择一个简单的分布$U \sim p(u)$，假设目标分布$X \sim T(U)$，即目标分布是简单分布的变换。

      - 就像已知一个随机变量X服从均匀分布，随机变量Y是X的函数$Y=T(X)$，求Y的分布，即求Y的概率密度

      - 基于流的生成就是找到一系列转换函数$T=T_1\ \circ \ T_2\ \circ\ \cdot\cdot\cdot\ \circ\ T_n$，将简单分布一步步转换为要求的复杂分布

      - 因为基于**Change of Variable Theorem**，目标分布可以写出简单分布的函数，即$log(p_G(x)) = log\pi (G^{-1}(x)) + log|det(J_{G^{-1}})|$

      - x是生成器输出，G是生成器，$\pi(z)$是输入的分布（简单分布），$J_{G^{-1}}$是$G^{-1}$的Jacobian矩阵

      - 所以为了求目标分布的似然函数，需要对生成器做限制，即生成器可逆（至少输入向量和输出向量维度相同），生成器的Jacobian矩阵行列式好求（$|det(J_{G^{-1}})| = |det(J_{G})|^{-1}$）

      - 于是为了求更可能复杂的生成器，就让输入经过多个转换，也就是上面的$T=T_1\ \circ \ T_2\ \circ\ \cdot\cdot\cdot\ \circ\ T_n$

      - 实际上从公式中看，只有$G^{-1}$，所有训练的是$G^{-1}$网络，再反过来使用

      - 公式（5）是Coupling Layer（具体见李宏毅视频）

        ![](/Users/dream/Desktop/paper/paper-kt/img-causal/Coupling Layer1.PNG)

        ![](/Users/dream/Desktop/paper/paper-kt/img-causal/Coupling Layer2.PNG)

        ![](/Users/dream/Desktop/paper/paper-kt/img-causal/Coupling Layer3.PNG)

      - 公式（6）是

    - 资料

      - bilibili搜索 李宏毅-Flow-base Generative Model
      - [文字资料](https://mp.weixin.qq.com/s?__biz=MzU0NTYxODExMw==&mid=2247484057&idx=1&sn=88c373a88536cc378d56509fc7ac46d2&chksm=fb6b6337cc1cea216bf81bab76a347ed7bc98a7735290335eb306c69e2ab6ace4386baf33c71&scene=21#wechat_redirect)

- 代码

  - 生成数据
    - `gen_da_data_ortho(Nsegment=5, varyMean=True)`
      - 生成5段数据，每段长度7500，数据维度是4维，即数据的shape是(5*7500, 4)
      - 生成的data.npz包括以下内容
        - y: (37500, 4)，每一个元素都是从高斯分布或者拉普拉斯分布，即N(0,1)或者L(0,1)，中采样得到，并对每一维度做了归一化
        - x: (37500, 4)，调制混合后的信号，5段数据分别用5个不同信号调制，再通过多层非线性混合
        - c: (37500)，每一个数据的标签，取值为0~4，表示使用的哪个信号调制
    - `linear_nonGaussian_ts()`
      - 参数
        - lags = 2：时间滞后，即因果变量之间的关系只往前看2个时刻
        - Nlayer = 3：潜在因果变量非线性混合得到观测变量的层数
        - length = 4：（lags+length）是生成的时间序列长度
        - negSlope = 0.2：leaky_ReLU的系数，乘在大于0的元素上
        - latent_size = 8：潜在因果变量的维度
        - transitions = []：潜在因果变量之间的转移矩阵，有lags个矩阵
        - noise_scale = 0.1：拉普拉斯参数
        - batch_size = 50000：生成的时间序列数据条数
        - Niter4condThresh = 1e4：用于找合适的矩阵条件数，来生成转移矩阵
      - 生成线性非高斯时间序列数据
        - 线性：潜在因果变量之间的关系是线性的
        - 非高斯：
        - 最终生成的观测数据和潜在因果变量之间是非线性关系，即多层MLP，
      - 生成过程
        - 随机生成条件数合适的lags个潜在因果变量之间的转移矩阵 $\mathbf{B}_\tau^\mathbf{u}$，这样可以限制转移矩阵的条件数比较小，可以得到比较稳定的数值。（矩阵条件数$cond(A) = ||A|| \cdot ||A^{-1}||$，其中$||A||$表示矩阵某种范数，代码中用的是二范数）
        - 生成公式：$\mathbf{x}_t=g(\mathbf{z}_t),\quad \mathbf{z}_t = \sum\limits_{\tau=1}^L\mathbf{B}_\tau^\mathbf{u}\mathbf{z}_{t-\tau}+\epsilon_{it}$
        - $\mathbf{x}_t$：观测数据，潜在变量的非线性混合
        - $\mathbf{z}_t$：潜在变量（latent variable）
        - $\epsilon_{it}$从拉普拉斯分布$La(0, noise\_scale )$中采样得到
        - $g(\cdot)$：非线性混合，即多层MLP，权重参数矩阵是标准正交矩阵（保证可逆），激活函数是`leaky_ReLU`
        - 因为因果滞后时间是lags，所以$\mathbf{z}_1, \mathbf{z}_2, ..., \mathbf{z}_{lags}$和$\mathbf{x}_1, \mathbf{x}_2, ..., \mathbf{x}_{lags}$是随机生成的，具体来说：（1）$\mathbf{z}_1, \mathbf{z}_2, ..., \mathbf{z}_{lags}$是从标准正态分布采样，再做标准归一化得到的；（2）$\mathbf{x}_t,t <= lags$是混合$\mathbf{z}_t$得到的，即$\mathbf{x}_t=g(\mathbf{z}_t)$
      - 生成的`data.npz`包括以下内容
        - `yt` latent variable，即$\mathbf{z}_t$
        - `xt` observed variable，即$\mathbf{x}_t$
      - 生成的`W%d.npy`是转移矩阵，即$\mathbf{B}_\tau^\mathbf{u}$



































