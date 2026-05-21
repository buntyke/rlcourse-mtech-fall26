---
unit: 2
title: "Unit II: Markov Decision Processes & Dynamic Programming"
topics: "MDPs, Bellman Equations, Policy Evaluation, Value Iteration, Policy Iteration"
date: 2026-06-08
math: true
status: draft
published: false
---

## Markov Decision Processes

### Formal Definition

A **Markov Decision Process** (MDP) is a tuple $\mathcal{M} = (\mathcal{S}, \mathcal{A}, P, R, \gamma)$:

| Symbol | Meaning |
|---|---|
| $\mathcal{S}$ | State space |
| $\mathcal{A}$ | Action space |
| $P(s' \mid s, a)$ | Transition probability |
| $R(s, a)$ | Expected reward |
| $\gamma \in [0,1)$ | Discount factor |

The **Markov property**: $P(S_{t+1} \mid S_t, A_t, S_{t-1}, A_{t-1}, \ldots) = P(S_{t+1} \mid S_t, A_t)$.

### Reward Formulations

**Discounted return:**

$$G_t = R_{t+1} + \gamma R_{t+2} + \gamma^2 R_{t+3} + \cdots = \sum_{k=0}^{\infty} \gamma^k R_{t+k+1}$$

With $\gamma < 1$, the return is always finite for bounded rewards: $|G_t| \leq R_{\max} / (1 - \gamma)$.

**Episodic tasks** have a natural terminal state $s_\text{terminal}$; the return is a finite sum.

---

## Value Functions

### State-Value Function

The **state-value function** under policy $\pi$ is:

$$v_\pi(s) = \mathbb{E}_\pi[G_t \mid S_t = s]$$

### Action-Value Function

The **action-value (Q) function** is:

$$q_\pi(s, a) = \mathbb{E}_\pi[G_t \mid S_t = s, A_t = a]$$

The two are related by: $v_\pi(s) = \sum_a \pi(a \mid s)\, q_\pi(s, a)$.

---

## Bellman Equations

### Bellman Expectation Equation

For any policy $\pi$:

$$v_\pi(s) = \sum_a \pi(a \mid s) \sum_{s'} P(s' \mid s, a)\bigl[R(s, a) + \gamma\, v_\pi(s')\bigr]$$

This is a **linear system** in $v_\pi$; with $|\mathcal{S}|$ states it has a unique solution.

### Bellman Optimality Equation

The **optimal value function** $v^*(s) = \max_\pi v_\pi(s)$ satisfies:

$$v^*(s) = \max_a \sum_{s'} P(s' \mid s, a)\bigl[R(s, a) + \gamma\, v^*(s')\bigr]$$

The optimal policy then acts greedily: $\pi^*(s) = \arg\max_a q^*(s, a)$.

<div class="problem">

**Worked Example.** Consider a 2-state MDP: $\mathcal{S} = \{s_1, s_2\}$, one action, $R(s_1) = 1$, $R(s_2) = 2$, $P(s_2 \mid s_1) = 0.9$, $P(s_1 \mid s_2) = 0.8$, $\gamma = 0.9$.

Write the Bellman equations and solve for $v(s_1)$ and $v(s_2)$.

**Solution.** The equations are:

$$v(s_1) = 1 + 0.9[0.1 \cdot v(s_1) + 0.9 \cdot v(s_2)]$$
$$v(s_2) = 2 + 0.9[0.8 \cdot v(s_1) + 0.2 \cdot v(s_2)]$$

Simplifying: $0.91 v(s_1) - 0.81 v(s_2) = 1$ and $-0.72 v(s_1) + 0.82 v(s_2) = 2$.  Solving gives $v(s_1) \approx 17.3$, $v(s_2) \approx 20.4$.

</div>

---

## Policy Evaluation

**Iterative Policy Evaluation** solves $v_\pi$ by repeated application of the Bellman operator:

$$v_{k+1}(s) \leftarrow \sum_a \pi(a \mid s) \sum_{s'} P(s' \mid s, a)\bigl[R(s, a) + \gamma\, v_k(s')\bigr]$$

Convergence is guaranteed: $\|v_{k+1} - v_\pi\|_\infty \leq \gamma \|v_k - v_\pi\|_\infty$.

---

## Policy Improvement

**Policy Improvement Theorem.** If $q_\pi(s, \pi'(s)) \geq v_\pi(s)$ for all $s$, then $v_{\pi'} \geq v_\pi$ everywhere.

The **greedy policy** with respect to $v_\pi$:

$$\pi'(s) = \arg\max_a q_\pi(s, a) = \arg\max_a \sum_{s'} P(s' \mid s, a)\bigl[R(s, a) + \gamma\, v_\pi(s')\bigr]$$

---

## Policy Iteration

Alternates evaluation and improvement until convergence:

1. Initialise $\pi$ arbitrarily.
2. **Evaluate:** compute $v_\pi$ by iterative policy evaluation.
3. **Improve:** set $\pi \leftarrow \text{greedy}(v_\pi)$.
4. If $\pi$ changed, go to step 2. Otherwise, $\pi = \pi^*$.

Converges in a finite number of iterations (at most $|\mathcal{A}|^{|\mathcal{S}|}$ policies to check, but typically much faster).

---

## Value Iteration

Merges evaluation and improvement into one sweep per iteration:

$$v_{k+1}(s) = \max_a \sum_{s'} P(s' \mid s, a)\bigl[R(s, a) + \gamma\, v_k(s')\bigr]$$

This applies the **Bellman optimality operator** $\mathcal{T}^*$ directly.

**Convergence:** $\|v_{k+1} - v^*\|_\infty \leq \gamma \|v_k - v^*\|_\infty$, so $v_k \to v^*$ geometrically.

<div class="problem">

**Worked Example.** Use one sweep of value iteration on the 2-state MDP above with $v_0 = [0, 0]$.

**Solution.** With only one action:

$$v_1(s_1) = 1 + 0.9[0.1 \cdot 0 + 0.9 \cdot 0] = 1$$
$$v_1(s_2) = 2 + 0.9[0.8 \cdot 0 + 0.2 \cdot 0] = 2$$

After a second sweep: $v_2(s_1) = 1 + 0.9[0.1 \cdot 1 + 0.9 \cdot 2] = 1 + 0.9 \cdot 1.9 = 2.71$ and so on.

</div>

---

<div class="practice-short">
<ol>
  <li>State the Markov property and explain why it is useful computationally.</li>
  <li>What is the difference between episodic and continuing tasks? Give one real-world example of each.</li>
  <li>Why do we use a discount factor $\gamma < 1$ for continuing tasks?</li>
  <li>What does the Policy Improvement Theorem guarantee?</li>
  <li>Compare Policy Iteration and Value Iteration: when would you prefer each?</li>
</ol>
</div>

<div class="practice-long">
<ol>
  <li>Derive the Bellman expectation equation for $v_\pi(s)$ from the definition of the return $G_t$.</li>
  <li>Prove that iterative policy evaluation converges by showing the Bellman operator is a contraction mapping under $\|\cdot\|_\infty$ with contraction factor $\gamma$.</li>
  <li>Implement Policy Iteration for the 4×4 GridWorld example from Sutton &amp; Barto (Example 4.1). Report the number of iterations to convergence and the optimal policy.</li>
  <li>Show that Value Iteration can be viewed as Policy Iteration with one step of policy evaluation per improvement step.</li>
  <li>Consider an MDP with $|\mathcal{S}| = 1000$ states and $|\mathcal{A}| = 10$ actions. Estimate the computational cost per iteration for (a) Policy Evaluation via linear solve, (b) iterative Policy Evaluation, and (c) Value Iteration. Which do you recommend?</li>
</ol>
</div>
