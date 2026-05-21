# Lecture 5 — Gradient Bandits & Contextual Bandits

**Source material:** Sutton & Barto, *Reinforcement Learning: An Introduction* (2nd ed.), Chapter 2, §§2.8–2.9 (and brief callbacks to §2.4–2.7).

**Format reference:** `lectures/lecture4/lecture4.html` (reveal.js, deep-blue-on-white, definition / large-pseudo / worked example / intuition / question slide types).

**Structure:** 3 filler slides (title, today's journey, acknowledgements) + 30 content slides + 6 question slides interleaved. Vertical (sub-slide) stacks are used for derivations and equation transitions.

---

## Filler Slide F1 — Title

- Title: **Reinforcement Learning**
- Subtitle: **Lecture 5 — Gradient Bandits & Contextual Bandits**
- Author: Nishanth Koganti — VNR VJIET, M.Tech AI & DS

---

## Filler Slide F2 — Today's Journey

Bulleted outline:
- Part A — From action values to action **preferences**
- Part B — The gradient bandit update rule
- Part C — Why it works: stochastic gradient ascent derivation
- Part D — Empirical behaviour and the role of the baseline
- Part E — Associative search and contextual bandits
- Part F — Wrap-up, comparison, and bridge to policy gradient

Footer: link to course page `buntyke.github.io/rlcourse-mtech-fall26`.

---

## Filler Slide F3 — Acknowledgements

- Chapter 2 (especially §2.8–2.9) of **Reinforcement Learning: An Introduction** (2nd ed.) by *Sutton & Barto*.
- Course page link.

---

# PART A — From Values to Preferences (4 content slides + 1 question)

## Slide 1 — Recap: What We've Done with Values So Far

- Quick callback: \(Q_t(a)\) → action selection (greedy, ε-greedy, UCB, KL-UCB, Thompson Sampling).
- All previous methods **estimate value, then act**.
- New idea today: **skip the value estimate**; learn a *preference* for each action directly.
- Equation: \(\pi_t(a) \doteq \Pr\{A_t = a\}\) — we'll model the policy itself.

**Image (RL Book figure):** none required.
**Image (generated):** *"A side-by-side conceptual diagram in academic textbook style, deep navy blue and white. Left panel labelled 'Value-based': arrows from data → Q(a) estimates → argmax → action. Right panel labelled 'Preference-based': arrows from data → H(a) preferences → softmax probabilities → sampled action. Clean line art, no photographs, white background, sans-serif labels."*

---

## Slide 2 — Why Learn Preferences Instead of Values?

- Action values have a fixed numerical meaning (expected reward).
- **Preferences** \(H_t(a) \in \mathbb{R}\) have **no absolute meaning** — only relative differences matter.
- Adding a constant to every preference leaves the policy unchanged.
- This freedom enables a clean **gradient-based** update.
- Foreshadow: this is the seed of **policy gradient methods** in Unit IV.

**Image (generated):** *"A simple academic illustration: three vertical bars labelled H(1)=2, H(2)=5, H(3)=1, with an arrow showing '+1000 to all'; the three bars on the right are now labelled H(1)=1002, H(2)=1005, H(3)=1001 but the softmax probability pie chart underneath is identical in both cases. Deep blue and white, textbook style."*

---

## Slide 3 — The Softmax (Gibbs / Boltzmann) Distribution

Equation block (centred):

\[
\Pr\{A_t = a\} \doteq \frac{e^{H_t(a)}}{\sum_{b=1}^{k} e^{H_t(b)}} \doteq \pi_t(a)
\]

Bullets:
- Initially \(H_1(a) = 0\) for all \(a\) → uniform policy.
- Larger preference → higher selection probability, but never zero.
- Built-in exploration: every action keeps non-zero probability.

**Image (generated):** *"A clean line plot in academic textbook style, deep navy blue on white. X-axis: action index 1..5. Y-axis: probability. Three superimposed softmax distributions for preference vectors (a) all zeros — flat bars at 0.2 each, (b) [0,0,2,0,0] — peaked moderately at action 3, (c) [0,0,5,0,0] — sharply peaked at action 3. Legend in upper right. Sans-serif font."*

---

## Slide 4 — Question #1 (Softmax = Sigmoid for k=2)

Question box:
> **Exercise 2.9 (S&B):** Show that for two actions, the softmax distribution reduces to the logistic / sigmoid function.
>
> *Hint:* divide numerator and denominator by \(e^{H_t(1)}\) and let \(x = H_t(2) - H_t(1)\).

Speaker notes / answer:
\[
\pi_t(2) = \frac{e^{H_t(2)}}{e^{H_t(1)} + e^{H_t(2)}} = \frac{1}{1 + e^{-(H_t(2) - H_t(1))}} = \sigma(x)
\]

**Image:** none.

---

# PART B — The Gradient Bandit Algorithm (5 content slides + 1 question)

## Slide 5 — Gradient Bandit in One Sentence

Definition box:
> **Gradient bandit:** maintain a real-valued preference \(H_t(a)\) for each action, sample actions from a softmax over these preferences, and update the preferences after each step using a stochastic-gradient rule that pushes preference up when reward beats a baseline and down when it falls short.

Bullets:
- No \(Q\)-estimate ever computed.
- Update is differentiable in \(H\) — that's what makes it "gradient".

**Image (generated):** *"A textbook-style cartoon: a learning agent (simple stick figure) holds three slot-machine levers labelled with bars of different heights representing preferences H(1), H(2), H(3). Above the levers, a soft probability cloud labelled 'softmax(H)' rains down arrows of different thickness onto each lever. Deep blue ink on white, sans-serif labels."*

---

## Slide 6 — The Update Rule (Eq. 2.12)

Two stacked equations:

\[
H_{t+1}(A_t) \doteq H_t(A_t) + \alpha\,(R_t - \bar R_t)\,(1 - \pi_t(A_t))
\]
\[
H_{t+1}(a) \doteq H_t(a) - \alpha\,(R_t - \bar R_t)\,\pi_t(a), \quad \text{for all } a \neq A_t
\]

Bullets:
- \(\alpha > 0\): step size.
- \(\bar R_t\): running average of rewards (the **baseline**).
- Reward above baseline → selected action's preference increases.
- Non-selected actions move in the **opposite** direction.

**Image:** none — equation slide.

---

## Slide 7 — The Baseline \(\bar R_t\)

- \(\bar R_t\) is the average reward up to (but not including) time \(t\).
- Computed incrementally (callback to §2.4):
  \[
  \bar R_{t+1} = \bar R_t + \tfrac{1}{t}(R_t - \bar R_t)
  \]
- For nonstationary problems, use a constant step-size baseline (callback to §2.5).
- Choice of baseline does **not** change the expected update — only its variance (we'll prove this).

**Image:** none.

---

## Slide 8 — Pseudocode (large-pseudo block)

```
initialize H(a) = 0  for all a
initialize R_bar = 0,  n = 0

for t = 1, 2, ..., n:

    for each arm a:
        pi(a) = exp(H(a)) / sum_b exp(H(b))

    A_t ~ Categorical( pi )          # sample from softmax

    observe reward R_t

    for each arm a:
        if a == A_t:
            H(a) <- H(a) + alpha * (R_t - R_bar) * (1 - pi(a))
        else:
            H(a) <- H(a) - alpha * (R_t - R_bar) * pi(a)

    n <- n + 1
    R_bar <- R_bar + (R_t - R_bar) / n
```

Footer: *Sutton & Barto, Ch. 2.8.*

---

## Slide 9 — Worked Numeric Example (one update step)

Three-arm setup, before step:

| arm | H(a) | π(a) |
|-----|------|------|
| 1   | 0.0  | 0.33 |
| 2   | 0.0  | 0.33 |
| 3   | 0.0  | 0.33 |

Action sampled: \(A_t = 2\). Reward \(R_t = 1.0\). Baseline \(\bar R_t = 0.0\). Step size \(\alpha = 0.1\).

Compute:
- \(H_{t+1}(2) = 0 + 0.1 \cdot (1.0 - 0) \cdot (1 - 0.33) = 0.067\)
- \(H_{t+1}(1) = 0 - 0.1 \cdot (1.0 - 0) \cdot 0.33 = -0.033\)
- \(H_{t+1}(3) = -0.033\)

New softmax: π ≈ (0.32, 0.36, 0.32) — arm 2 is now slightly more likely.

**Image:** none — table slide.

---

## Slide 10 — Question #2 (Effect of Subtracting the Baseline)

Question box:
> **Scenario:** You are running a gradient bandit on a problem where every reward happens to lie between +9 and +11 (so the rewards are large but the *differences* between arms are small).
>
> (a) What does the algorithm look like with \(\bar R_t = 0\) (no baseline)?
> (b) Why does subtracting \(\bar R_t \approx 10\) make learning more reliable?

Speaker notes / answer:
- Without baseline, every \((R_t - 0)\) is large and positive → every selected action has its preference jacked up regardless of whether it was actually better than the alternative.
- With baseline near 10, the update sign reflects whether \(R_t\) was *above or below average*, which is what we actually care about.

**Image (generated):** *"Two side-by-side bar charts in deep navy and white textbook style. Left chart titled 'No baseline': three preferences all rising rapidly together. Right chart titled 'With baseline': one preference rising, two preferences falling, clearly separating. Sans-serif labels, clean academic look."*

---

# PART C — Why It Works: Stochastic Gradient Ascent (6 content slides as VERTICAL stack + 1 question)

> **Note:** Slides 11–16 are a **single vertical stack** so the audience can step through the derivation one equation at a time.

## Slide 11 (vertical 1) — The Goal: Gradient Ascent on Expected Reward

Equation:
\[
H_{t+1}(a) \doteq H_t(a) + \alpha \frac{\partial \mathbb{E}[R_t]}{\partial H_t(a)}
\]
where
\[
\mathbb{E}[R_t] = \sum_x \pi_t(x)\,q_*(x).
\]

Bullets:
- We *want* exact gradient ascent on the expected reward.
- Problem: we don't know \(q_*(x)\).
- Plan: rewrite the gradient as an **expectation we can sample**.

---

## Slide 12 (vertical 2) — Step 1: Introduce a Baseline

Derivation:
\[
\frac{\partial \mathbb{E}[R_t]}{\partial H_t(a)} = \sum_x q_*(x) \frac{\partial \pi_t(x)}{\partial H_t(a)} = \sum_x \big(q_*(x) - B_t\big) \frac{\partial \pi_t(x)}{\partial H_t(a)}
\]

Why it's legal:
\[
\sum_x \frac{\partial \pi_t(x)}{\partial H_t(a)} = 0
\]
(probabilities always sum to 1, so their gradient sums to 0).

**Boardwork callout:** "🖊️ Convince yourself the baseline term vanishes."

---

## Slide 13 (vertical 3) — Step 2: Multiply and Divide by \(\pi_t(x)\)

\[
\frac{\partial \mathbb{E}[R_t]}{\partial H_t(a)} = \sum_x \pi_t(x) \,\big(q_*(x) - B_t\big) \,\frac{\partial \pi_t(x)/\partial H_t(a)}{\pi_t(x)}
\]

Recognise as expectation over \(A_t \sim \pi_t\):
\[
= \mathbb{E}\!\left[(q_*(A_t) - B_t)\,\frac{\partial \pi_t(A_t)/\partial H_t(a)}{\pi_t(A_t)}\right]
\]

Choose \(B_t = \bar R_t\) and use \(\mathbb{E}[R_t \mid A_t] = q_*(A_t)\):
\[
= \mathbb{E}\!\left[(R_t - \bar R_t)\,\frac{\partial \pi_t(A_t)/\partial H_t(a)}{\pi_t(A_t)}\right]
\]

---

## Slide 14 (vertical 4) — Step 3: The Softmax Derivative (Boardwork)

Boardwork box:
> 🖊️ **Claim:**
> \[
> \frac{\partial \pi_t(x)}{\partial H_t(a)} = \pi_t(x)\,(\mathbb{1}_{a=x} - \pi_t(a))
> \]

Sketch (quotient rule):
\[
\frac{\partial}{\partial H_t(a)}\frac{e^{H_t(x)}}{\sum_y e^{H_t(y)}} = \frac{\mathbb{1}_{a=x}\,e^{H_t(x)}\sum_y e^{H_t(y)} - e^{H_t(x)} e^{H_t(a)}}{\left(\sum_y e^{H_t(y)}\right)^2}
\]
\[
= \mathbb{1}_{a=x}\,\pi_t(x) - \pi_t(x)\pi_t(a) = \pi_t(x)(\mathbb{1}_{a=x} - \pi_t(a))
\]

---

## Slide 15 (vertical 5) — Step 4: Plug In and Recover Eq. 2.12

Substitute the derivative into the expectation:
\[
\frac{\partial \mathbb{E}[R_t]}{\partial H_t(a)} = \mathbb{E}\!\left[(R_t - \bar R_t)(\mathbb{1}_{a=A_t} - \pi_t(a))\right]
\]

A single sample of this expectation is exactly the update from Slide 6:
\[
H_{t+1}(a) = H_t(a) + \alpha\,(R_t - \bar R_t)(\mathbb{1}_{a=A_t} - \pi_t(a))
\]

**Conclusion:** Eq. 2.12 is **stochastic gradient ascent on \(\mathbb{E}[R_t]\)**.

---

## Slide 16 (vertical 6) — What the Derivation Bought Us

- The expected update equals the true gradient → **convergence guarantees** of SGA apply.
- Baseline \(B_t\) is a free choice — only affects **variance** of the update, not its expectation.
- Choosing \(B_t = \bar R_t\) is simple and works well in practice but is not provably optimal.
- **This same recipe powers REINFORCE and policy gradient methods.**

**Image (generated):** *"A textbook-style schematic: in the centre, a loss-landscape contour plot in shades of blue. A red arrow labelled 'true gradient' points uphill. A scatter of small grey dotted arrows labelled 'noisy SGA samples' point in roughly the same direction with spread. Clean academic style, white background."*

---

## Slide 17 — Question #3 (Why the Baseline Doesn't Bias the Update)

Question box:
> **Question:** In the derivation, we added \(-B_t\,\frac{\partial \pi_t(x)}{\partial H_t(a)}\) to each term in the gradient sum. Why is the *expected* update unchanged for any choice of \(B_t\) (constant, zero, or \(\bar R_t\))?

Speaker notes / answer:
\(\sum_x \partial \pi_t(x)/\partial H_t(a) = 0\), so multiplying by any \(B_t\) that doesn't depend on \(x\) and summing gives zero. Variance changes; expectation does not.

---

# PART D — Empirical Behaviour (4 content slides + 1 question)

## Slide 18 — The 10-Armed Testbed Shifted by +4

- Sutton & Barto re-run the testbed with all true means shifted up by **+4** (so \(q_*(a)\) ~ N(+4, 1)).
- This makes raw rewards uniformly positive — a stress test for the baseline.

**RL Book figure:** *S&B Fig. 2.5* — `material/RLBook/Chapter2/_page_59_Figure_2.jpeg` (or equivalent extracted asset). Show with footnote:
> *Sutton & Barto, RL: An Introduction, Ch. 2, Fig. 2.5.*

---

## Slide 19 — With vs Without the Baseline

- **With baseline** (\(\bar R_t\) = running mean of rewards): converges quickly to optimal action.
- **Without baseline** (\(\bar R_t = 0\)): degraded performance — preferences drift because every reward looks "good".
- Confirms what we proved on Slide 17: baseline reduces variance, doesn't bias.

**Image:** reuse Fig. 2.5 from previous slide *or* a callout zoomed onto its two curves.

---

## Slide 20 — Choosing \(\alpha\): A Parameter Study

- Like ε-greedy and UCB, gradient bandit has a sweet-spot \(\alpha\).
- Too small: learns too slowly. Too large: noisy, unstable preferences.
- Inverted-U curve in S&B's parameter study (Fig. 2.6).

**RL Book figure:** *S&B Fig. 2.6* — `material/RLBook/Chapter2/_page_63_Figure_0.jpeg` (parameter study). Footnote:
> *Sutton & Barto, RL: An Introduction, Ch. 2, Fig. 2.6.*

---

## Slide 21 — Question #4 (Predicting the Effect of \(B_t = 1000\))

Question box:
> **Scenario:** You replace the baseline \(\bar R_t\) with the constant \(B_t = 1000\) (much larger than any actual reward).
>
> (a) Will the algorithm still converge to the optimal policy *in expectation*?
> (b) What practical problem will you observe in your training curves?

Speaker notes / answer:
(a) Yes — expected gradient is unchanged (Slide 17).
(b) Variance of the update explodes: every \((R_t - 1000)\) is a large negative number, so each step makes a huge swing. Convergence will be slow and noisy.

---

# PART E — Associative Search / Contextual Bandits (6 content slides + 1 question)

## Slide 22 — From Nonassociative to Associative

- All bandit settings so far: a *single* situation, find the best arm.
- Real problems: the best action **depends on context** (time of day, user, sensor reading, screen colour).
- We need a **policy** — a mapping from contexts to actions, not just one action.

**Image (generated):** *"A two-panel academic illustration in deep navy and white. Left panel labelled 'Nonassociative bandit': one slot machine, agent points at the best lever. Right panel labelled 'Contextual bandit': three coloured slot machines (red, green, blue) presented one at a time; agent points at a different lever for each colour. Clean line art, sans-serif labels."*

---

## Slide 23 — The Coloured-Slot-Machine Story (S&B §2.9)

Bullets:
- Several different \(k\)-armed bandit tasks; one shown each step at random.
- The machine displays a **colour** indicating which task it is.
- Goal: learn a *policy* — "if red, pull arm 1; if green, pull arm 2; …"
- Reward depends on **(context, action)** pair.

**Image (generated):** *"A textbook-style cartoon: three slot machines side by side, coloured red, green, and blue, each with three levers. Above each machine, a thought bubble shows the agent recalling which lever was best for that colour. Deep navy and white, sans-serif text."*

---

## Slide 24 — Definition Slide: Contextual Bandit / Associative Search

Definition box:
> **Contextual bandit (associative search):** at each step the agent observes a context \(C_t\), selects an action \(A_t\), and receives a reward \(R_t\) drawn from a distribution depending on \(C_t\) and \(A_t\). Goal: learn a policy \(\pi : \text{contexts} \to \text{actions}\) that maximises expected reward.

Bullets:
- Like a bandit: action affects only the **immediate** reward.
- Like full RL: requires learning a **policy**, not a single action.
- Bridge problem between Lecture 1's bandits and Lecture 6's MDPs.

**Image:** none — definition slide.

---

## Slide 25 — Where Contextual Bandits Sit in the RL Landscape

Three-card layout:

| **k-armed bandit** | **Contextual bandit** | **Full RL (MDP)** |
| --- | --- | --- |
| One situation | Many situations | Many situations |
| Pick best action | Pick best action *per context* | Pick best action sequence |
| No state transitions | No state transitions | Actions affect next state |
| Immediate reward only | Immediate reward only | Delayed, cumulative reward |

**Image (generated):** *"A horizontal flow diagram in academic textbook style, deep navy on white. Three boxes left to right labelled 'k-armed bandit', 'Contextual bandit', 'Markov Decision Process'. Arrows between them labelled '+ context' and '+ state transitions'. Clean sans-serif labels."*

---

## Slide 26 — Application Lens: Personalised Recommendations

- Arms = candidate articles / ads / products.
- Context = user features (location, time, history).
- Reward = click / no-click, purchase / no-purchase.
- Industry deployments (news feeds, ad targeting, A/B testing) are mostly contextual bandits, not full RL.
- Why: feedback is immediate, no long-horizon planning needed (yet).

**Image (generated):** *"A clean schematic in deep navy and white: on the left, a user icon with feature tags 'age', 'location', 'history'. An arrow labelled 'context C_t' goes into a central box labelled 'policy π'. From the box, three arrows fan out to candidate items 'article A', 'article B', 'article C'. One arrow is bold, labelled 'A_t'. A reward icon (thumbs up / down) returns from the chosen item. Textbook style."*

---

## Slide 27 — Question #5 (Exercise 2.10 Adapted)

Question box:
> **Scenario (S&B Exercise 2.10):** A 2-armed bandit task whose true values change between two cases:
>
> - Case A: \(q_*(1) = 10, q_*(2) = 20\) (probability 0.5)
> - Case B: \(q_*(1) = 90, q_*(2) = 80\) (probability 0.5)
>
> (a) If you **cannot** tell which case you face, what is the best expected reward, and how should you act?
> (b) If you **are told** which case (associative / contextual), what is the best expected reward, and how should you act?

Speaker notes / answer:
(a) Average values: arm 1 → 50, arm 2 → 50. Indifferent; best expected reward = 50.
(b) Pick arm 2 in case A (=20) and arm 1 in case B (=90) → best expected reward = 0.5·20 + 0.5·90 = **55**.
The information about context is worth +5 per step.

---

# PART F — Wrap-up & Bridge (3 content slides + 1 question)

## Slide 28 — Comparison Table: All Four Bandit Algorithms

| | ε-greedy | UCB | Gradient bandit | Contextual bandit |
| --- | --- | --- | --- | --- |
| Learns | values | values + bonus | preferences | per-context policy |
| Exploration | random ε | optimism | softmax | depends on inner alg. |
| Tunable | ε | c | α (and baseline) | varies |
| Best when | simple, robust | generic rewards | gradient-friendly | context observable |

Footer: *S&B, Ch. 2.7–2.9.*

---

## Slide 29 — Bridge to Policy Gradient (Unit IV Foreshadowing)

- The gradient-bandit derivation is a **template** for a much bigger family.
- Replace the softmax-over-preferences with a softmax-over-**neural-network-outputs** → policy network.
- Replace the average-reward baseline with a learned **value function** → actor–critic.
- Replace immediate reward with **return** \(G_t\) → REINFORCE.
- We will revisit this in Unit IV with full machinery.

**Image (generated):** *"A clean evolution diagram in academic textbook style: four boxes left to right, connected by rightward arrows. Box 1: 'Gradient Bandit (H, π, R)'. Box 2: 'REINFORCE (θ, π_θ, G_t)'. Box 3: 'Actor–Critic (θ, π_θ, V_φ)'. Box 4: 'Modern Policy Gradient (PPO, etc.)'. Deep navy ink on white, sans-serif labels."*

---

## Slide 30 — Exit Check

Bullet summary:
- **Gradient bandit:** preferences + softmax + stochastic gradient ascent.
- **Baseline** reduces variance, never biases the expected update.
- **Contextual bandit:** policy maps context → action; bridge to full RL.
- **Next lecture:** Markov Decision Processes — when actions also affect *the next state*.

---

## Slide 31 — Question #6 (Exit Question)

Question box:
> **Scenario:** You are designing an algorithm for a news app that picks 1 of 5 headlines per visitor. You have rich user features (location, recent reads).
>
> (a) Is this a bandit, contextual bandit, or full RL problem? Why?
> (b) Would you reach for a **gradient bandit** here, or does the contextual nature change your choice? What would you change in the algorithm to make it context-aware?

Speaker notes / answer:
(a) Contextual bandit — feedback is immediate (click/no-click) and there's no long horizon, but the best headline depends on user features.
(b) Plain gradient bandit ignores context. Make preferences functions of context: \(H_t(a) = \theta_a^\top \phi(C_t)\). Then the same SGA derivation gives a per-context policy update. (This is essentially the springboard to policy-gradient with function approximation.)

---

# Image Asset Summary

## RL Book figures to use (already in `material/RLBook/Chapter2/`):

| Slide | Figure | Path / source |
| --- | --- | --- |
| 18, 19 | Fig. 2.5 — gradient bandit with vs without baseline | extract from `RLBook.md` (page ~59) |
| 20 | Fig. 2.6 — parameter study | extract from `RLBook.md` (page ~63) |

## Generated images (Nano Banana Pro 2 prompts):

The detailed prompts are written inline in each slide above (Slides 1, 2, 3, 5, 10, 16, 22, 23, 25, 26, 29). All prompts share a consistent visual style:

> "Academic textbook illustration, deep navy blue (#213c8b) ink on white background, clean line art, no photographs, sans-serif labels, minimal but informative — matches a reveal.js lecture deck for an M.Tech RL course."

---

# Vertical-Stack Summary (for slide builder)

The reveal.js vertical-stack groupings are:

- **Stack A — Derivation (Slides 11–16):** one `<section>` containing six nested `<section>` slides for step-by-step navigation.

All other slides are top-level (horizontal).

---

# Question Distribution

| # | Slide | Topic |
| --- | --- | --- |
| 1 | 4 | Softmax = sigmoid for k=2 |
| 2 | 10 | Effect of subtracting the baseline |
| 3 | 17 | Why baseline doesn't bias the update |
| 4 | 21 | Effect of \(B_t = 1000\) |
| 5 | 27 | Exercise 2.10 — value of context |
| 6 | 31 | Exit: contextual recommendation system |

Questions are interleaved across all five content parts (A, B, C, D, E, F).

---

# Slide Count Check

- **Filler slides:** 3 (title, journey, acknowledgements)
- **Content slides:** 30 (Slides 1–30)
- **Question slides:** 6 (Slides 4, 10, 17, 21, 27, 31)

Note: Question slides 4, 10, 17, 21, 27, 31 are *included in* the 30-content count (they're the active-learning beats interleaved through the lecture). If the user wants 30 *non-question* content slides plus 6 questions on top, expand each part by one slide (e.g., add a "Common pitfalls" slide to Part B and a deeper "Variance of the gradient estimator" slide to Part C).
