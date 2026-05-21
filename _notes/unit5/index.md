---
unit: 5
title: "Unit V: Function Approximation & Model-Based Methods"
topics: "Linear FA, Tile Coding, Dyna-Q, Case Studies"
date: 2026-06-29
math: true
status: draft
published: false
---

## Why Function Approximation?

For large or continuous state spaces, tabular methods are infeasible.  **Function approximation** represents $v_\pi$ or $q_\pi$ with a parameterised function:

$$\hat{v}(s, \mathbf{w}) \approx v_\pi(s), \quad \mathbf{w} \in \mathbb{R}^d, \quad d \ll |\mathcal{S}|$$

Key property we need: **generalisation** — updating $\mathbf{w}$ for state $s$ should improve estimates at nearby states.

---

## Linear Function Approximation

### Feature Vectors

Represent state $s$ by a feature vector $\mathbf{x}(s) \in \mathbb{R}^d$:

$$\hat{v}(s, \mathbf{w}) = \mathbf{w}^\top \mathbf{x}(s) = \sum_{i=1}^d w_i x_i(s)$$

The gradient is simply $\nabla_\mathbf{w} \hat{v}(s, \mathbf{w}) = \mathbf{x}(s)$.

### Semi-Gradient TD(0)

$$\mathbf{w} \leftarrow \mathbf{w} + \alpha \delta_t\, \mathbf{x}(S_t)$$

where $\delta_t = R_{t+1} + \gamma\, \hat{v}(S_{t+1}, \mathbf{w}) - \hat{v}(S_t, \mathbf{w})$.

Called **semi-gradient** because we do not differentiate through the TD target (we treat $\hat{v}(S_{t+1}, \mathbf{w})$ as a constant when computing the gradient).

<div class="problem">

**Worked Example.** State space $s \in \{1, 2, 3, 4\}$.  Feature vector: $\mathbf{x}(s) = [s/4,\; 1]^\top$ (linear + bias).  $\mathbf{w} = [0.5,\; 0]^\top$, $\alpha = 0.1$, $\gamma = 0.9$.

Transition $S_t = 2 \to S_{t+1} = 3$, $R_{t+1} = 1$.

Compute the semi-gradient TD(0) update.

**Solution.**

$\hat{v}(2, \mathbf{w}) = \mathbf{w}^\top [0.5, 1] = 0.5$. $\hat{v}(3, \mathbf{w}) = \mathbf{w}^\top [0.75, 1] = 0.375$.

$\delta = 1 + 0.9 \times 0.375 - 0.5 = 0.8375$.

$\mathbf{w} \leftarrow [0.5, 0] + 0.1 \times 0.8375 \times [0.5, 1] = [0.5419,\; 0.0838]$.

</div>

---

## Tile Coding

**Tile coding** is a practical feature construction for continuous states.

- Lay $n$ **tilings** over the state space, each offset slightly.
- Each tiling partitions the space into **tiles**; a state $s$ activates exactly one tile per tiling.
- Feature vector: a binary vector of length (tiles per tiling × $n$ tilings); exactly $n$ bits are 1.

**Advantages:**
- Linear in $\mathbf{w}$, so SGD updates are $O(n)$ not $O(d)$.
- Natural generalisation: nearby states share tiles.

$$\hat{v}(s, \mathbf{w}) = \mathbf{w}^\top \mathbf{x}(s) = \sum_{i \in \text{active tiles}} w_i$$

---

## Model-Based RL and Dyna-Q

### Model-Free vs Model-Based

| | Model-Free | Model-Based |
|---|---|---|
| Learns | Value/policy directly | Environment model |
| Sample efficiency | Low | High |
| Computation | Low | High (planning) |

### Dyna-Q

Dyna-Q integrates **direct RL** (real experience) and **planning** (simulated experience from the model):

1. Take action $A_t$, observe $R_{t+1}, S_{t+1}$.
2. Q-learning update on real experience.
3. Update model: $\hat{P}(S_{t+1} \mid S_t, A_t)$, $\hat{R}(S_t, A_t) \leftarrow R_{t+1}$.
4. Repeat $n$ times: sample $(s, a)$ from past experience, generate $(r', s')$ from model, Q-learning update.

With $n = 0$, Dyna-Q reduces to Q-learning. With larger $n$, convergence is much faster in terms of real-world steps.

<div class="problem">

**Worked Example.** Dyna-Q with $n = 5$ on a simple maze. After 10 real steps, how many total Q-learning updates have been made?

**Solution.** Each real step triggers 1 direct update + 5 planning updates = 6 updates per step. Total: $10 \times 6 = 60$ updates, compared to 10 for pure Q-learning.

</div>

---

## Case Studies

### TD-Gammon (Tesauro, 1995)

- Trained a neural network $v_\theta$ to play backgammon using TD(λ).
- Self-play: the network played against itself, generating its own training data.
- Reached world-class play — one of the earliest successes of RL on a complex game.

### Samuel's Checkers Player (1959)

- One of the earliest RL systems, predating the formal framework.
- Used linear function approximation with handcrafted features and TD-style updates.
- Demonstrated that an agent could surpass its creator through self-play.

### Elevator Dispatching

- State: floor requests, elevator positions/loads.
- Reward: negative waiting time.
- Discrete RL with large state space; function approximation and Dyna-style planning reduced convergence time significantly over conventional scheduling heuristics.

---

<div class="practice-short">
<ol>
  <li>Why is it called "semi-gradient" TD? What is missing compared to a true gradient descent?</li>
  <li>How does tile coding achieve generalisation between nearby states?</li>
  <li>What two sources of experience does Dyna-Q combine, and what role does each play?</li>
  <li>In what way is TD-Gammon remarkable given the RL techniques of the 1990s?</li>
  <li>State one advantage of model-based methods and one risk (hint: model errors).</li>
</ol>
</div>

<div class="practice-long">
<ol>
  <li>Derive the semi-gradient TD(0) update rule for linear function approximation from the mean-squared value error objective $\overline{\text{VE}}(\mathbf{w}) = \sum_s \mu(s)[v_\pi(s) - \hat{v}(s, \mathbf{w})]^2$ and explain why the resulting update is "semi"-gradient.</li>
  <li>Design a tile-coding scheme for a 2D continuous state space $s = (x, y) \in [0, 1]^2$. Use 4 tilings of $8 \times 8$ tiles each with offsets $(0, 0)$, $(1/4, 0)$, $(0, 1/4)$, $(1/4, 1/4)$ (in tile units). How many features does your representation have? Compute the feature vector for $s = (0.3, 0.7)$.</li>
  <li>Implement Dyna-Q on the Blocking Maze (Sutton &amp; Barto Example 8.2) for $n \in \{0, 5, 50\}$ and plot cumulative reward vs real environment steps. What does $n = 50$ reveal about model-based planning?</li>
  <li>Analyse the policy learned by TD-Gammon through the lens of the policy gradient theorem. Although Tesauro used TD rather than explicit policy gradients, explain how the self-play updates implicitly optimise a policy objective.</li>
  <li>Dyna-Q assumes a deterministic environment model. Describe how you would extend it to stochastic environments (e.g., using a distribution over next states). What additional memory is required? How does this affect planning quality?</li>
</ol>
</div>
