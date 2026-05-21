---
unit: 1
title: "Unit I: Foundations & Bandit Algorithms"
topics: "Probability recap, Multi-Armed Bandits, ε-Greedy, UCB, Thompson Sampling"
date: 2026-06-01
math: true
status: draft
published: false
---

## Probability & Linear Algebra Recap

Reinforcement learning rests on a handful of probability concepts used repeatedly throughout the course.

### Random Variables and Expectation

A **random variable** $X$ is a function from a sample space $\Omega$ to $\mathbb{R}$.  Its **expected value** is defined as:

$$\mathbb{E}[X] = \sum_{x} x \cdot P(X = x)$$

For a continuous variable: $\mathbb{E}[X] = \int_{-\infty}^{\infty} x \, p(x) \, dx$.

Key identity used throughout RL — the **law of total expectation**:

$$\mathbb{E}[X] = \mathbb{E}[\mathbb{E}[X \mid Y]]$$

### Concentration Inequalities

We often need to bound the probability that a sample mean deviates from its true mean.  **Hoeffding's inequality**: for $n$ i.i.d. variables bounded in $[a, b]$,

$$P\!\left(\bar{X} - \mu \geq t\right) \leq \exp\!\left(\frac{-2n^2 t^2}{\sum_i (b_i - a_i)^2}\right)$$

This is the engine behind the UCB algorithm's confidence intervals.

---

## The Multi-Armed Bandit Problem

### Problem Setup

An agent repeatedly chooses one of $K$ **arms** (actions). At each round $t$:

1. Agent selects arm $A_t \in \{1, \ldots, K\}$.
2. Environment reveals reward $R_t \sim P(\cdot \mid A_t)$.
3. Agent updates its estimates.

The mean reward of arm $k$ is $\mu_k = \mathbb{E}[R_t \mid A_t = k]$.  The **optimal arm** is $k^* = \arg\max_k \mu_k$ with value $\mu^* = \mu_{k^*}$.

### Regret

**Cumulative regret** after $T$ rounds measures total missed reward:

$$R_T = T \mu^* - \sum_{t=1}^{T} \mu_{A_t} = \sum_{k=1}^{K} \Delta_k \, \mathbb{E}[N_k(T)]$$

where $\Delta_k = \mu^* - \mu_k$ is the **gap** of arm $k$ and $N_k(T)$ is the number of times arm $k$ was pulled.

**Goal:** design a policy such that $R_T = o(T)$ — i.e., regret grows sublinearly.

<div class="problem">

**Worked Example.** Suppose $K = 2$, $\mu_1 = 0.7$, $\mu_2 = 0.4$, and an agent always pulls arm 1 after round 2. After $T = 100$ rounds, what is the expected cumulative regret if the agent pulled arm 2 exactly 5 times?

**Solution.** $\Delta_2 = \mu_1 - \mu_2 = 0.3$. The contribution of arm 2 to regret is $\Delta_2 \cdot N_2(T) = 0.3 \times 5 = 1.5$.  Arm 1 is optimal so $\Delta_1 = 0$. Total regret $= 1.5$.

</div>

---

## Exploration vs Exploitation

A fundamental tension: **exploitation** (pull the arm with the highest estimated mean) risks missing better arms; **exploration** (try all arms) wastes pulls on known bad arms.

---

## ε-Greedy Algorithm

**Algorithm.** At each round $t$:

- With probability $\varepsilon$: pull a uniformly random arm (explore).
- With probability $1 - \varepsilon$: pull arm $\hat{k}^* = \arg\max_k \hat{\mu}_k$ (exploit).

Estimated mean: $\hat{\mu}_k(t) = \frac{1}{N_k(t)} \sum_{s \leq t,\, A_s = k} R_s$.

**Regret bound.** With fixed $\varepsilon$, $R_T = O(\varepsilon T + K / \varepsilon)$.  Setting $\varepsilon = \sqrt{K/T}$ gives $R_T = O(\sqrt{KT})$.

---

## Upper Confidence Bound (UCB)

### UCB1

At each round $t$, pull the arm that maximises:

$$\text{UCB}_k(t) = \hat{\mu}_k(t) + \sqrt{\frac{2 \ln t}{N_k(t)}}$$

The second term is an **optimism bonus** — arms pulled less often get higher bonuses.

**Regret bound (Auer et al., 2002):**

$$\mathbb{E}[R_T] \leq \sum_{k:\Delta_k > 0} \frac{8 \ln T}{\Delta_k} + \left(1 + \frac{\pi^2}{3}\right)\sum_k \Delta_k$$

This is an **instance-dependent** $O(\ln T)$ bound — dramatically better than $\varepsilon$-greedy for small gaps.

<div class="problem">

**Worked Example.** $K = 3$ arms, pulls so far: arm 1 pulled 10 times ($\hat{\mu} = 0.6$), arm 2 pulled 4 times ($\hat{\mu} = 0.5$), arm 3 pulled 2 times ($\hat{\mu} = 0.4$).  Current round $t = 17$.  Which arm does UCB1 select?

**Solution.**
$$\text{UCB}_1 = 0.6 + \sqrt{\frac{2 \ln 17}{10}} \approx 0.6 + 0.580 = 1.180$$
$$\text{UCB}_2 = 0.5 + \sqrt{\frac{2 \ln 17}{4}} \approx 0.5 + 0.917 = 1.417$$
$$\text{UCB}_3 = 0.4 + \sqrt{\frac{2 \ln 17}{2}} \approx 0.4 + 1.296 = 1.696$$

UCB1 selects **arm 3** (highest upper confidence bound despite lowest sample mean).

</div>

---

## Thompson Sampling

Thompson Sampling maintains a **posterior distribution** over arm means and samples from it.

For Bernoulli rewards with a Beta prior $\text{Beta}(\alpha_k, \beta_k)$:

1. At each round, sample $\theta_k \sim \text{Beta}(\alpha_k, \beta_k)$ for each arm $k$.
2. Pull arm $k^* = \arg\max_k \theta_k$.
3. Observe reward $r$; update: $\alpha_{k^*} \mathrel{+}= r$, $\beta_{k^*} \mathrel{+}= 1 - r$.

**Regret bound.** Thompson Sampling matches the Lai–Robbins lower bound of $\Omega\!\left(\sum_k \frac{\ln T}{\Delta_k}\right)$ asymptotically.

---

<div class="practice-short">
<ol>
  <li>What is the difference between cumulative regret and simple regret?</li>
  <li>Why does sublinear regret guarantee that the average reward converges to $\mu^*$?</li>
  <li>How does the UCB bonus term change as an arm is pulled more often?</li>
  <li>What prior distribution does Thompson Sampling use for Bernoulli rewards?</li>
  <li>State one advantage and one disadvantage of ε-greedy compared to UCB1.</li>
</ol>
</div>

<div class="practice-long">
<ol>
  <li>Derive the regret decomposition $R_T = \sum_k \Delta_k \mathbb{E}[N_k(T)]$ from the definition of cumulative regret.</li>
  <li>Prove that the UCB bonus $\sqrt{2 \ln t / N_k(t)}$ ensures each sub-optimal arm $k$ is pulled at most $O(\ln T / \Delta_k^2)$ times in expectation. (Hint: use Hoeffding's inequality.)</li>
  <li>Consider a 3-arm bandit with $\mu_1 = 0.8$, $\mu_2 = 0.5$, $\mu_3 = 0.3$.  Simulate UCB1 for $T = 1000$ rounds and plot cumulative regret. Compare with ε-greedy for $\varepsilon \in \{0.05, 0.1, 0.2\}$.</li>
  <li>Describe how Thompson Sampling can be adapted to Gaussian reward distributions. What conjugate prior would you use?</li>
  <li>The Lai–Robbins lower bound states $\liminf_{T\to\infty} R_T / \ln T \geq \sum_{k:\Delta_k>0} \Delta_k / d(\mu_k, \mu^*)$ where $d$ is the KL divergence. Interpret this bound and discuss its implications for algorithm design.</li>
</ol>
</div>
