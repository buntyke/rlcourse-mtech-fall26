---
unit: 3
title: "Unit III: Monte Carlo & TD Prediction"
topics: "MC Prediction & Control, TD(0), n-step Returns, TD(λ)"
date: 2026-06-15
math: true
status: draft
published: false
---

## Prediction vs Control

- **Prediction problem:** given a fixed policy $\pi$, estimate $v_\pi$ or $q_\pi$.
- **Control problem:** find the optimal policy $\pi^*$.

Model-free methods solve these without access to $P(s' \mid s, a)$ or $R(s, a)$.

---

## Monte Carlo Prediction

### First-Visit MC

For each episode, update $v(s)$ using the return $G_t$ the **first time** $s$ is visited:

$$v(s) \leftarrow v(s) + \alpha\bigl[G_t - v(s)\bigr]$$

### Every-Visit MC

Same update, but applied **every time** $s$ is visited in an episode.

Both converge to $v_\pi(s)$ as $n \to \infty$ by the law of large numbers.

<div class="problem">

**Worked Example.** An agent runs one episode through states $s_1, s_2, s_1, s_3$ receiving rewards $0, 1, 0, 2$ (terminal). With $\gamma = 1$ and $\alpha = 0.1$, $v(s_1) = v(s_2) = v(s_3) = 0$ initially. Apply first-visit MC.

**Solution.** Returns from first visit: $G(s_1) = 0+1+0+2 = 3$, $G(s_2) = 1+0+2 = 3$, $G(s_3) = 2$.

$$v(s_1) \leftarrow 0 + 0.1(3 - 0) = 0.3, \quad v(s_2) \leftarrow 0.3, \quad v(s_3) \leftarrow 0.2$$

</div>

### MC Control: On-Policy

Use $\varepsilon$-greedy over $q(s, a)$ and update after each episode:

$$q(s, a) \leftarrow q(s, a) + \alpha[G_t - q(s, a)]$$

Convergence requires GLIE (Greedy in the Limit with Infinite Exploration): $\varepsilon_t \to 0$ and $\sum_t \varepsilon_t = \infty$.

---

## Temporal Difference Learning

### TD(0)

Update after **every step**, without waiting for the episode to end:

$$v(S_t) \leftarrow v(S_t) + \alpha\bigl[\underbrace{R_{t+1} + \gamma\, v(S_{t+1})}_{\text{TD target}} - v(S_t)\bigr]$$

The quantity $\delta_t = R_{t+1} + \gamma\, v(S_{t+1}) - v(S_t)$ is the **TD error**.

**Compared to MC:**

| | MC | TD(0) |
|---|---|---|
| Update trigger | End of episode | Every step |
| Bias | Zero | Non-zero (bootstrapping) |
| Variance | High | Low |
| Requires episodes | Yes | No (works online) |

<div class="problem">

**Worked Example.** State sequence $s_1 \to s_2 \to \text{terminal}$, rewards $0, 1$. $\gamma = 0.9$, $\alpha = 0.1$, $v(s_1) = 0.5$, $v(s_2) = 1.0$, $v(\text{terminal}) = 0$.

Apply one TD(0) update for each transition.

**Solution.**

At $t = 1$: $\delta_1 = 0 + 0.9 \cdot 1.0 - 0.5 = 0.4$. $v(s_1) \leftarrow 0.5 + 0.1 \cdot 0.4 = 0.54$.

At $t = 2$: $\delta_2 = 1 + 0.9 \cdot 0 - 1.0 = 0$. $v(s_2)$ unchanged.

</div>

---

## Bootstrapping

**Bootstrapping** means using an estimated value (e.g., $v(S_{t+1})$) rather than the actual return to form a target. TD methods bootstrap; MC does not.

**Why bootstrap?** Lower variance, immediate updates, applicable to continuing tasks. **Cost:** introduces bias because estimates are initially wrong.

---

## n-Step Returns

Interpolate between TD(0) ($n=1$) and MC ($n \to \infty$):

$$G_t^{(n)} = R_{t+1} + \gamma R_{t+2} + \cdots + \gamma^{n-1} R_{t+n} + \gamma^n v(S_{t+n})$$

Update: $v(S_t) \leftarrow v(S_t) + \alpha[G_t^{(n)} - v(S_t)]$.

---

## TD(λ) — Eligibility Traces

### λ-Return

Weighted average of all $n$-step returns:

$$G_t^\lambda = (1-\lambda)\sum_{n=1}^{\infty} \lambda^{n-1} G_t^{(n)}$$

$\lambda = 0$: TD(0). $\lambda = 1$: MC.

### Forward vs Backward View

**Forward view** (theoretical): use $G_t^\lambda$ as target — requires future rewards.

**Backward view** (implementable): maintain an **eligibility trace** $e_t(s)$ updated each step:

$$e_t(s) = \gamma \lambda\, e_{t-1}(s) + \mathbf{1}[S_t = s]$$

Update all states simultaneously:

$$v(s) \leftarrow v(s) + \alpha\, \delta_t\, e_t(s) \quad \forall s$$

The eligibility trace acts as a decaying memory of recently visited states.

---

<div class="practice-short">
<ol>
  <li>What is the TD error $\delta_t$? What does it represent intuitively?</li>
  <li>Why does MC have higher variance than TD(0)?</li>
  <li>When does the $n$-step return reduce to TD(0)? When does it become the MC return?</li>
  <li>What is an eligibility trace? How does it combine recency and frequency?</li>
  <li>In what situations would you prefer TD(0) over MC for policy evaluation?</li>
</ol>
</div>

<div class="practice-long">
<ol>
  <li>Prove that every-visit MC converges to $v_\pi(s)$ using the law of large numbers. What additional step is needed to show first-visit MC also converges?</li>
  <li>Show that TD(0) converges to a fixed point that minimises the **mean-squared TD error**, not the mean-squared error w.r.t. $v_\pi$. Construct an example where these differ.</li>
  <li>Implement TD(0) and MC prediction for the RandomWalk example (Sutton &amp; Barto Example 6.2) and compare their RMS error curves over 100 episodes for $\alpha \in \{0.05, 0.1, 0.15\}$.</li>
  <li>Derive the backward-view TD(λ) update rule from the forward-view $\lambda$-return, assuming offline updates (end-of-episode). At what condition does equivalence hold exactly?</li>
  <li>Explain why TD(λ) with $\lambda = 1$ and offline updates is equivalent to MC, but online TD(λ = 1) is not exactly equivalent to MC. What modification (True Online TD(λ)) fixes this?</li>
</ol>
</div>
